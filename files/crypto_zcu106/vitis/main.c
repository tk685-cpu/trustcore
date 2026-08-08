/* ============================================================================
 * main.c
 * Bare-metal validation application for the crypto chip on the ZCU106.
 *
 * Sends known-answer test vectors to the PL over SPI, compares the results
 * against golden values computed on the host, and drives the board LEDs:
 *
 *     running : both LEDs blinking alternately
 *     pass    : LED_PASS solid on
 *     fail    : LED_FAIL blinking fast
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
            xil_printf("  ERROR: chip raised err (STATUS=0x%08X)\r\n",
                       (unsigned int)st);
            return -1;
        }
        if (++guard > POLL_LIMIT) {
            xil_printf("  ERROR: timeout waiting for result "
                       "(STATUS=0x%08X)\r\n", (unsigned int)st);
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
    for (i = 0; i < n; i++) xil_printf("%02X", p[i]);
    xil_printf("\r\n");
}

/* ---------------------------------------------------------------------------
 * Main
 * ------------------------------------------------------------------------- */
int main(void)
{
    u8  got[32];
    int i;
    int pass = 0, fail = 0;
    u32 id;

    xil_printf("\r\n");
    xil_printf("=====================================================\r\n");
    xil_printf(" Crypto chip validation on ZCU106\r\n");
    xil_printf("=====================================================\r\n");

    WR(REG_LED, LED_RUNNING);

    /* -- Step 1: prove the AXI path itself works ------------------------- */
    id = RD(REG_ID);
    xil_printf("ID register: 0x%08X ", (unsigned int)id);
    if (id != ID_MAGIC) {
        xil_printf("MISMATCH (expected 0x%08X)\r\n", (unsigned int)ID_MAGIC);
        xil_printf("\r\nThe AXI path is not working. Check, in this order:\r\n");
        xil_printf("  1. the bitstream actually programmed\r\n");
        xil_printf("  2. CRYPTO_BASE matches the Vivado Address Editor\r\n");
        xil_printf("  3. the PS AXI master port is enabled and connected\r\n");
        xil_printf("  4. the PL clock and reset are connected\r\n");
        WR(REG_LED, LED_FAIL);
        return 1;
    }
    xil_printf("OK\r\n");

    /* -- Step 2: set the SPI clock divider ------------------------------- */
    spi_cs(0);
    xil_printf("SCLK divider: %d (f_SCLK = f_clk / %d)\r\n\r\n",
               (int)SCLK_DIV, (int)(2 * SCLK_DIV));

    /* -- Step 3: SHA-256 known-answer tests ------------------------------ */
    xil_printf("--- SHA-256 ---\r\n");
    for (i = 0; i < N_SHA_VEC; i++) {
        memset(got, 0, sizeof(got));
        if (run_sha256(sha_vec[i].msg, sha_vec[i].len, got) != 0) {
            xil_printf("  FAIL len=%-2d (transfer error)\r\n", sha_vec[i].len);
            fail++;
            continue;
        }
        if (memcmp(got, sha_vec[i].digest, 32) == 0) {
            xil_printf("  PASS len=%d\r\n", sha_vec[i].len);
            pass++;
        } else {
            xil_printf("  FAIL len=%d\r\n", sha_vec[i].len);
            dump_hex("got", got, 32);
            dump_hex("exp", sha_vec[i].digest, 32);
            fail++;
        }
    }

    /* -- Step 4: Ascon-128 known-answer tests ---------------------------- */
    xil_printf("\r\n--- Ascon-128 ---\r\n");
    for (i = 0; i < N_ASC_VEC; i++) {
        memset(got, 0, sizeof(got));
        if (run_ascon(test_key, test_nonce,
                      asc_vec[i].pt, asc_vec[i].len, got) != 0) {
            xil_printf("  FAIL len=%-2d (transfer error)\r\n", asc_vec[i].len);
            fail++;
            continue;
        }
        if (memcmp(got, asc_vec[i].result, 32) == 0) {
            xil_printf("  PASS len=%d\r\n", asc_vec[i].len);
            pass++;
        } else {
            xil_printf("  FAIL len=%d\r\n", asc_vec[i].len);
            dump_hex("got (ct||tag)", got, 32);
            dump_hex("exp (ct||tag)", asc_vec[i].result, 32);
            fail++;
        }
    }

    /* -- Step 5: negative tests, the chip must reject bad requests ------- */
    xil_printf("\r\n--- Rejection tests ---\r\n");
    {
        u32 st;

        spi_cs(1);
        spi_byte(0x55);            /* unrecognised command */
        spi_byte(0x04);
        spi_cs(0);
        usleep(1000);
        st = RD(REG_STATUS);
        if (st & ST_CHIP_ERR) { xil_printf("  PASS bad command rejected\r\n"); pass++; }
        else                  { xil_printf("  FAIL bad command accepted\r\n"); fail++; }

        spi_cs(1);
        spi_byte(CMD_SHA256);
        spi_byte(40);              /* SHA length above the 32-byte limit */
        spi_cs(0);
        usleep(1000);
        st = RD(REG_STATUS);
        if (st & ST_CHIP_ERR) { xil_printf("  PASS oversize length rejected\r\n"); pass++; }
        else                  { xil_printf("  FAIL oversize length accepted\r\n"); fail++; }
    }

    /* -- Step 6: recovery, a good vector after the rejections ------------ */
    xil_printf("\r\n--- Recovery after errors ---\r\n");
    memset(got, 0, sizeof(got));
    if (run_sha256(sha_vec[0].msg, sha_vec[0].len, got) == 0 &&
        memcmp(got, sha_vec[0].digest, 32) == 0) {
        xil_printf("  PASS chip recovered and answered correctly\r\n");
        pass++;
    } else {
        xil_printf("  FAIL chip did not recover\r\n");
        fail++;
    }

    /* -- Result ---------------------------------------------------------- */
    xil_printf("\r\n=====================================================\r\n");
    xil_printf(" passed: %d    failed: %d\r\n", pass, fail);
    if (fail == 0) {
        xil_printf(" RESULT: ALL PASS  (LED_PASS solid)\r\n");
        WR(REG_LED, LED_PASS);
    } else {
        xil_printf(" RESULT: FAILURES  (LED_FAIL blinking)\r\n");
        WR(REG_LED, LED_FAIL);
    }
    xil_printf("=====================================================\r\n");

    return (fail == 0) ? 0 : 1;
}
