/* ============================================================================
 * main.c
 * Bare-metal validation application for the crypto chip on the ZCU106.
 *
 * Waits for a pushbutton, sends the matching known-answer test vectors to the
 * PL over SPI, compares the results against golden values computed on the
 * host, and drives the board LEDs.
 *
 * CONTROLS (ZCU106 5-way pushbutton, SW14-SW18)
 *   GPIO_SW_W            run the Ascon-128 vectors
 *   GPIO_SW_E            run the SHA-256 vectors
 *   both within 250 ms   run everything, Ascon then SHA-256, then the
 *                        rejection and recovery checks
 *
 * NOTE: SW3 and SW4 on this board are SRST_B and POR_B. They reset the MPSoC
 * and must not be used as user inputs.
 *
 * LEDs: all eight user LEDs are driven together as one bar.
 *
 *     idle    : slow pulse, 168 ms on every 2.7 s  (alive, waiting)
 *     running : fast even blink, ~6 Hz             (test in progress)
 *     pass    : ALL EIGHT SOLID ON
 *     fail    : ALL EIGHT DARK
 *
 * Idle and running are 16x apart in rate so they cannot be confused, and the
 * two verdicts are the two extremes. Idle pulses rather than sitting dark so
 * that a board waiting at the menu can be told apart from a failing run and
 * from a bitstream that never programmed.
 *
 * The blink patterns are generated in hardware, so the indication keeps
 * running even if this application stops.
 *
 * Build: Vitis application project on the standalone (bare-metal) BSP for
 * psu_cortexa53_0, using the XSA exported from the Vivado block design.
 * ============================================================================ */

#include <string.h>
#include "xparameters.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "xil_types.h"
#include "sleep.h"

/* ---------------------------------------------------------------------------
 * Peripheral base address
 *
 * After you build the block design, Vitis generates a symbol in xparameters.h
 * for the peripheral. The exact name depends on the instance name you gave the
 * block, so the fallback below is used if the symbol is not found. On a Zynq
 * MPSoC with a single PL peripheral on M_AXI_HPM0_LPD, 0x80000000 is the usual
 * default. Check the Address Editor in Vivado if the ID register read fails.
 * ------------------------------------------------------------------------- */
#ifdef XPAR_CRYPTO_AXI_TOP_0_S_AXI_BASEADDR
  #define CRYPTO_BASE   XPAR_CRYPTO_AXI_TOP_0_S_AXI_BASEADDR
#else
  #define CRYPTO_BASE   0x80000000U
#endif

/* Register offsets, matching crypto_axi_top.v */
#define REG_ID          0x00U
#define REG_CTRL        0x04U
#define REG_XFER        0x08U
#define REG_STATUS      0x0CU
#define REG_LED         0x10U
#define REG_BTN         0x14U

#define ID_MAGIC        0x5AA5C0DEU

/* STATUS bits */
#define ST_SPI_BUSY     (1U << 0)
#define ST_CHIP_BUSY    (1U << 1)
#define ST_RESULT_RDY   (1U << 2)
#define ST_CHIP_ERR     (1U << 3)

/* LED status codes */
#define LED_IDLE        0U
#define LED_PASS        1U
#define LED_FAIL        2U
#define LED_RUNNING     3U

/* BTN register fields */
#define BTN_STATE_MASK  0x003U          /* [1:0] live debounced state    */
#define BTN_CODE_SHIFT  2U              /* [3:2] latched event code      */
#define BTN_CODE_MASK   0x00CU
#define BTN_PENDING     (1U << 4)       /* [4]   event waiting           */
#define BTN_RAW_SHIFT   8U              /* [9:8] raw pins, pre-polarity  */

/* Event codes, matching the button bit order */
#define EVT_ASCON       0x1U            /* W pressed        */
#define EVT_SHA         0x2U            /* E pressed        */
#define EVT_BOTH        0x3U            /* both pressed     */

/* Protocol commands */
#define CMD_SHA256      0x01U
#define CMD_ASCON       0x02U

/* SCLK divider: system clocks per SCLK half period.
 * f_SCLK = f_clk / (2 * div). The slave requires f_SCLK <= f_clk / 8, so the
 * minimum safe value is 4. Simulation shows f_clk/6 still passes and f_clk/4
 * fails, so 8 (giving f_clk/16) leaves comfortable margin. Raise it if you
 * ever see intermittent mismatches; that is the first thing to try. */
#define SCLK_DIV        8U

#define POLL_LIMIT      100000U   /* iterations before declaring a hang */

#define RD(off)         Xil_In32(CRYPTO_BASE + (off))
#define WR(off, val)    Xil_Out32(CRYPTO_BASE + (off), (val))

/* ---------------------------------------------------------------------------
 * Vector tables
 * ------------------------------------------------------------------------- */
typedef struct { u8 len; u8 msg[32]; u8 digest[32]; } sha_vec_t;
typedef struct { u8 len; u8 pt[16];  u8 result[32]; } asc_vec_t;

#include "crypto_vectors.h"

/* ---------------------------------------------------------------------------
 * Hex printing
 *
 * xil_printf is a cut-down printf. Width and zero-pad modifiers and uppercase
 * %X are not guaranteed to be supported across BSP versions, and a specifier
 * it does not understand is printed literally. That would corrupt exactly the
 * output you need most: the ID register value and the got/exp dumps on a
 * mismatch. These helpers use only %c, which every version supports.
 * ------------------------------------------------------------------------- */
static const char HEXD[] = "0123456789ABCDEF";

static void put_hex8(u8 v)
{
    xil_printf("%c%c", HEXD[(v >> 4) & 0xFU], HEXD[v & 0xFU]);
}

static void put_hex32(u32 v)
{
    int i;
    for (i = 28; i >= 0; i -= 4)
        xil_printf("%c", HEXD[(v >> i) & 0xFU]);
}

/* ---------------------------------------------------------------------------
 * Low-level SPI helpers
 * ------------------------------------------------------------------------- */
static void spi_cs(int active)
{
    /* CTRL: [0] cs_n level (0 = frame open), [15:8] clock divider */
    WR(REG_CTRL, (SCLK_DIV << 8) | (active ? 0U : 1U));
}

/* Returns the byte received while `tx` was sent, or -1 if the master hung. */
static int spi_byte(u8 tx)
{
    u32 v;
    u32 guard = 0;

    WR(REG_XFER, tx);

    do {
        v = RD(REG_XFER);
        if (++guard > POLL_LIMIT) {
            xil_printf("  ERROR: SPI master did not complete a byte\r\n");
            return -1;
        }
    } while (v & 0x100U);          /* bit 8 = spi_busy */

    return (int)(v & 0xFFU);
}

/* Waits for the chip to stage a result. Returns 0 on success. */
static int wait_result_ready(void)
{
    u32 st;
    u32 guard = 0;

    do {
        st = RD(REG_STATUS);
        if (st & ST_CHIP_ERR) {
            xil_printf("  ERROR: chip raised err (STATUS=0x");
            put_hex32(st);
            xil_printf(")\r\n");
            return -1;
        }
        if (++guard > POLL_LIMIT) {
            xil_printf("  ERROR: timeout waiting for result (STATUS=0x");
            put_hex32(st);
            xil_printf(")\r\n");
            return -1;
        }
    } while ((st & ST_RESULT_RDY) == 0U);

    return 0;
}

/* Reads the fixed 32-byte result back in a second SPI frame. */
static int read_result(u8 *out)
{
    int i, b;

    spi_cs(1);
    for (i = 0; i < 32; i++) {
        b = spi_byte(0x00);        /* dummy bytes just to generate SCLK */
        if (b < 0) { spi_cs(0); return -1; }
        out[i] = (u8)b;
    }
    spi_cs(0);
    return 0;
}

/* ---------------------------------------------------------------------------
 * Operations
 * ------------------------------------------------------------------------- */
static int run_sha256(const u8 *msg, u8 len, u8 *out)
{
    int i;

    spi_cs(1);
    if (spi_byte(CMD_SHA256) < 0) { spi_cs(0); return -1; }
    if (spi_byte(len)       < 0)  { spi_cs(0); return -1; }
    for (i = 0; i < len; i++)
        if (spi_byte(msg[i]) < 0) { spi_cs(0); return -1; }
    spi_cs(0);

    if (wait_result_ready() != 0) return -1;
    return read_result(out);
}

static int run_ascon(const u8 *key, const u8 *nonce,
                     const u8 *pt, u8 len, u8 *out)
{
    int i;

    spi_cs(1);
    if (spi_byte(CMD_ASCON) < 0) { spi_cs(0); return -1; }
    if (spi_byte(len)       < 0) { spi_cs(0); return -1; }
    for (i = 0; i < 16; i++)
        if (spi_byte(key[i])   < 0) { spi_cs(0); return -1; }
    for (i = 0; i < 16; i++)
        if (spi_byte(nonce[i]) < 0) { spi_cs(0); return -1; }
    for (i = 0; i < len; i++)
        if (spi_byte(pt[i])    < 0) { spi_cs(0); return -1; }
    spi_cs(0);

    if (wait_result_ready() != 0) return -1;
    return read_result(out);
}

/* ---------------------------------------------------------------------------
 * Reporting
 * ------------------------------------------------------------------------- */
static void dump_hex(const char *label, const u8 *p, int n)
{
    int i;
    xil_printf("       %s ", label);
    for (i = 0; i < n; i++) put_hex8(p[i]);
    xil_printf("\r\n");
}

/* ---------------------------------------------------------------------------
 * Test suites. Each returns the number of failures and adds to *ran.
 * ------------------------------------------------------------------------- */
static int suite_sha256(int *ran)
{
    u8  got[32];
    int i, fail = 0;

    xil_printf("\r\n--- SHA-256 (%d vectors) ---\r\n", N_SHA_VEC);
    for (i = 0; i < N_SHA_VEC; i++) {
        memset(got, 0, sizeof(got));
        (*ran)++;
        if (run_sha256(sha_vec[i].msg, sha_vec[i].len, got) != 0) {
            xil_printf("  FAIL len=%d (transfer error)\r\n", sha_vec[i].len);
            fail++;
            continue;
        }
        if (memcmp(got, sha_vec[i].digest, 32) == 0) {
            xil_printf("  PASS len=%d\r\n", sha_vec[i].len);
        } else {
            xil_printf("  FAIL len=%d\r\n", sha_vec[i].len);
            dump_hex("got", got, 32);
            dump_hex("exp", sha_vec[i].digest, 32);
            fail++;
        }
    }
    return fail;
}

static int suite_ascon(int *ran)
{
    u8  got[32];
    int i, fail = 0;

    xil_printf("\r\n--- Ascon-128 (%d vectors) ---\r\n", N_ASC_VEC);
    for (i = 0; i < N_ASC_VEC; i++) {
        memset(got, 0, sizeof(got));
        (*ran)++;
        if (run_ascon(test_key, test_nonce,
                      asc_vec[i].pt, asc_vec[i].len, got) != 0) {
            xil_printf("  FAIL len=%d (transfer error)\r\n", asc_vec[i].len);
            fail++;
            continue;
        }
        if (memcmp(got, asc_vec[i].result, 32) == 0) {
            xil_printf("  PASS len=%d\r\n", asc_vec[i].len);
        } else {
            xil_printf("  FAIL len=%d\r\n", asc_vec[i].len);
            dump_hex("got (ct||tag)", got, 32);
            dump_hex("exp (ct||tag)", asc_vec[i].result, 32);
            fail++;
        }
    }
    return fail;
}

/* The chip must reject a bad command and an oversize length, and must still
 * answer correctly afterwards. */
static int suite_negative(int *ran)
{
    u8  got[32];
    u32 st;
    int fail = 0;

    xil_printf("\r\n--- Rejection and recovery ---\r\n");

    (*ran)++;
    spi_cs(1); spi_byte(0x55); spi_byte(0x04); spi_cs(0);
    usleep(1000);
    st = RD(REG_STATUS);
    if (st & ST_CHIP_ERR) xil_printf("  PASS bad command rejected\r\n");
    else { xil_printf("  FAIL bad command accepted\r\n"); fail++; }

    (*ran)++;
    spi_cs(1); spi_byte(CMD_SHA256); spi_byte(40); spi_cs(0);
    usleep(1000);
    st = RD(REG_STATUS);
    if (st & ST_CHIP_ERR) xil_printf("  PASS oversize length rejected\r\n");
    else { xil_printf("  FAIL oversize length accepted\r\n"); fail++; }

    (*ran)++;
    memset(got, 0, sizeof(got));
    if (run_sha256(sha_vec[0].msg, sha_vec[0].len, got) == 0 &&
        memcmp(got, sha_vec[0].digest, 32) == 0) {
        xil_printf("  PASS chip recovered after errors\r\n");
    } else {
        xil_printf("  FAIL chip did not recover\r\n"); fail++;
    }

    return fail;
}

/* ---------------------------------------------------------------------------
 * Button handling
 * ------------------------------------------------------------------------- */
static void print_menu(void)
{
    xil_printf("\r\nReady. Press a button on the 5-way switch:\r\n");
    xil_printf("   W          Ascon-128 vectors\r\n");
    xil_printf("   E          SHA-256 vectors\r\n");
    xil_printf("   W + E      everything\r\n");
}

/* Returns the event code, or 0 if nothing is pending. Acknowledges in
 * hardware before returning so the next press is not missed while a test
 * suite is running. */
static u32 poll_button(void)
{
    u32 v = RD(REG_BTN);
    u32 code;

    if ((v & BTN_PENDING) == 0U)
        return 0U;

    code = (v & BTN_CODE_MASK) >> BTN_CODE_SHIFT;
    WR(REG_BTN, BTN_PENDING);          /* write-1-to-clear */
    return code;
}

/* ---------------------------------------------------------------------------
 * Main
 * ------------------------------------------------------------------------- */
int main(void)
{
    u32 id, evt, btn_raw;
    int fail, ran;

    xil_printf("\r\n");
    xil_printf("=====================================================\r\n");
    xil_printf(" Crypto chip validation on ZCU106\r\n");
    xil_printf("=====================================================\r\n");

    WR(REG_LED, LED_RUNNING);

    /* -- Step 1: prove the AXI path itself works ------------------------- */
    id = RD(REG_ID);
    xil_printf("ID register: 0x");
    put_hex32(id);
    xil_printf(" ");
    if (id != ID_MAGIC) {
        xil_printf("MISMATCH (expected 0x");
        put_hex32(ID_MAGIC);
        xil_printf(")\r\n");
        xil_printf("\r\nThe AXI path is not working. Check, in this order:\r\n");
        xil_printf("  1. the bitstream actually programmed\r\n");
        xil_printf("  2. CRYPTO_BASE matches the Vivado Address Editor\r\n");
        xil_printf("  3. the PS AXI master port is enabled and connected\r\n");
        xil_printf("  4. the PL clock and reset are connected\r\n");
        WR(REG_LED, LED_FAIL);
        return 1;
    }
    xil_printf("OK\r\n");

    spi_cs(0);
    xil_printf("SCLK divider: %d (f_SCLK = f_clk / %d)\r\n",
               (int)SCLK_DIV, (int)(2 * SCLK_DIV));

    /* -- Step 2: report button polarity ---------------------------------- */
    /* With nothing pressed the raw bits should read 00. If they read 11, the
     * buttons are active low: set ACTIVE_HIGH to 0 in the button_ctrl
     * instance inside crypto_axi_top.v and rebuild the bitstream. */
    btn_raw = (RD(REG_BTN) >> BTN_RAW_SHIFT) & 0x3U;
    xil_printf("Button raw state (idle): 0b%d%d %s\r\n",
               (int)((btn_raw >> 1) & 1U), (int)(btn_raw & 1U),
               (btn_raw == 0U) ? "(polarity OK)"
                               : "(WARNING: expected 00 with nothing pressed)");

    /* Drain any event left over from power-up bounce */
    WR(REG_BTN, BTN_PENDING);

    print_menu();
    WR(REG_LED, LED_IDLE);

    /* -- Step 3: main loop ----------------------------------------------- */
    for (;;) {
        evt = poll_button();
        if (evt == 0U) {
            usleep(2000);
            continue;
        }

        fail = 0;
        ran  = 0;
        WR(REG_LED, LED_RUNNING);

        switch (evt) {
        case EVT_ASCON:
            xil_printf("\r\n[W] Ascon-128\r\n");
            fail += suite_ascon(&ran);
            break;

        case EVT_SHA:
            xil_printf("\r\n[E] SHA-256\r\n");
            fail += suite_sha256(&ran);
            break;

        case EVT_BOTH:
        default:
            xil_printf("\r\n[W+E] Full run\r\n");
            fail += suite_ascon(&ran);
            fail += suite_sha256(&ran);
            fail += suite_negative(&ran);
            break;
        }

        xil_printf("\r\n=====================================================\r\n");
        xil_printf(" ran: %d   passed: %d   failed: %d\r\n",
                   ran, ran - fail, fail);
        if (fail == 0) {
            xil_printf(" RESULT: ALL PASS  (all 8 LEDs solid on)\r\n");
            WR(REG_LED, LED_PASS);
        } else {
            xil_printf(" RESULT: FAILURES  (all 8 LEDs dark)\r\n");
            WR(REG_LED, LED_FAIL);
        }
        xil_printf("=====================================================\r\n");

        /* Discard anything queued by button chatter during the run */
        WR(REG_BTN, BTN_PENDING);
        print_menu();
    }

    return 0;
}
