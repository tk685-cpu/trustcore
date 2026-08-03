// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Wed Mar 11 14:48:01 2026
// Host        : GCP-E101-12 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [4:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [63:0]douta;

  wire [4:0]addra;
  wire clka;
  wire [63:0]dina;
  wire [63:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [63:0]NLW_U0_doutb_UNCONNECTED;
  wire [4:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [4:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "5" *) 
  (* C_ADDRB_WIDTH = "5" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     6.371475 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "23" *) 
  (* C_READ_DEPTH_B = "23" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "64" *) 
  (* C_READ_WIDTH_B = "64" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "23" *) 
  (* C_WRITE_DEPTH_B = "23" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "64" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_9 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[63:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[4:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[4:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
FPXllyX2NFs/RMngGqZy2bLYbZr92CdofeZrJOHklWXExpaPgHNYp2Lzm4MnflbnrfSkCmLwwKT5
zfRgEip7FKQ5Zhb73p0MAIADixBZ/ZRt4hQkJL0T9brm0waLHfanjnov2aCX6jN3LbQc3ujmDga6
Dd73k78u4xjRTDv1/P4=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kr7VKKvChFoiyRCReag+OvU3jnmG9pN0cv+BxhNmMKLthg/ksgNZyU3L+fQ7cmIQELtlUjwjkBAP
Jjq5RsCnHbJxj+Ys1GNhriiBsxLqxWCP8onhAVvgZN2xZFOih0UWpqlU8NVP8Eww1ohvkDgxTstC
3kDmYehxIUJjqCC/mgRZmuezqugrFdubYmBoz16tUvD17iA5qqCIMS9xSIXYp2LBNekmWEwrVqzu
R4koEo4UlXl/CEw0XY3QvMoHnlXgu6N/6sc+nxZtKSwjiMVvGnZE9UVvJPAC3Hn3zKFGlK53mmGO
Tj0dWzhwX0ahSYzkyJC/HLdbGZmriL2UNvDyFw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
CaLc9FGt3AdRHfNtGAsGFY/QEvHY1Vv4TvvgCDsdDMqiuDeLizFJDJeskBWjeKDoE2cufK8TxiBq
mySRQNJoeOKnxTiDdf+Rx6m0iR6h/YeswegYwgghpM5KVrl6mSwF3+4yEovPM7a+9ArDQ5vl+WT8
SilNGzyW0KnTwe7+szs=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
cEnudSW1X71p0Xuq6jrXOxHnBku87IA0RA3zKqmeZHZM0r+9rEm5MSzX8RecnQ994yiqeyxbIH2l
fGEzUzr0ZzryS3fkf2LnJuB39f2YARW9eVCSiaeWaraZuY1l89T+h3vgdlurS/1LIraYLS1MyOXa
6F1LAcQp3W4OO4ctc3q1FRMZGldRS1biMsKwJ8Lxj8NEOm67UfgFrJNQAxbVXEfbWRWhKtwNxcTB
JbgC8j4EHkIA46mzoHloeBAL6KieplQUBjKXSSTb66rxglbFhWLy+mirROHcocu9J4ZbvTRYZEww
4lso1lqAllVLAoKYqa3WImZuSRoTbGDngBt9Lg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rOyI+x4PlmKcVSFoN3oKgSYpVlmYxc194Ej04il/YmBg10xopy4zmtu5sdCP/uGSNYcNGWeAiw01
mNf98KyNgTUFXruHCA38qjhhEIvl4vfWWn3W3mFRxrIuwmnreT6qTvgMaxIkCdVBDP7Iy7O6WmCf
3Va5X5hnCHhtXgX5UYniBHiLjmupv63B8XMAYDH2n6mQ3H0DF7mtb7psBafd0Z6+IWUbmzwMtKrf
ZrRJBGAhNT0i1KrEjEh/rWjN7Z7N32zQ+Pl1kc5gYCQIX5McfdTdqSaRVXZ/HF90ymS7/8d5LDyj
Er+ORdcjnOn6oAyY4PuUUl4OYUHv5k+RglTe5Q==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bJa7kPSpDipzoJoQu1APEjc8vFLqBfQZK/grZvWijD7/FgMTerFCWLUY6n8DWeGdvjXvTeyrqCHE
2rP/H57wUqPC8tIJlGm6ZYQGjZ3TgYqLrJshDE5zYMTO//q0vuSraWvZP7A7SLuW6y7tFE/nplpx
L8gbYORx6j70okGUwnamCMS9yhFr7Z2QTJne1k4GNFGvy66URk3k5cBPl5j4/1yc4xGV+aWYl6L8
q8RorRU/CltObHKrji/jdiY1WtdGrkpRyCEFc+XNPazL9xSLLu5bz6XlvKwoks+8a5KYT/VFUovM
JbM0bpAXM8Z7rGaPuXjqXtZBg5praTZLu/WNcA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PYKBDinOGc/kIVdFzXrz2wA4/QNFxLDrQfTWfR5TjYE6bm49vrZi0bawcr9HXp4OP1+XxPLB3oCP
oV5e/rYeDln531ebt8yEg27XCoSHEX4FU8oG8aBJ8fqgWayOnAMJt025WodOxuZXbhT1zPo7J3uh
6iO9Mv7RtYE2fZ1W+G8oN//FTOEJYPWlKYnt0cDeZrN3I4rHHptZHuu7l8T+df0PYea3x6U3Mvkl
ojZ+TwQtdu0NuYY5j3QNgx3+W2XYq1M773FAnEz/deW54EjE+jf1jjrBk2pl8SYxeKuutS15oPVF
eHdqXYVcJxoUY5JH8z04lITKEnZ4oq6sYS6dog==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
tl+2vFCWZ583gQGsVC7oopz2NCKBiJ9uOHYBGzJZheOHJMqI/ehNvo25l710eBx00tztXzM30AH6
ZhAJg+kJwE2jO0MV5fmG5dnwXmLqoGEJMBs7xwWxvYK7w/0z9M0AJKD7HnuC+IiLhNU/fIxyuE+I
+vWqp//RcfY0tMMp2I2J1yEW6GUahS1ve/4JchssZ7Xu7VthoSDWXMQWATbvsUsDzeSo2+Ruz8Kq
Dc05HqEU8NgBxDPPEKLCcdKLp4byglwj7iCAtCjsPy8P18qjgb2sycFjNgmaiNMMB51WqeD+hneG
hLOue9bqVdEojkrb3q4WbsGZKz0bAGsryxslOlYHP1b8vey3yI2ixA80wyERe8d3GRIeZiSxGykH
qWxsE6x/iyi8QRb5mXZPMApA+Fln8tYmn7+1rFCm8gF4gJWhr1PsSJqTi658symGrzT0Ghjvf2QL
SvvoaeNdy0pOsWs7jLBFndd4GiFA+9K6Y33sziLToU9EvvFokENIslod

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oYiCujFRj1F3wKsGZlHR9niEtR9MLXEVAVfy+f/3xrmpW6Ye5a+fBCvm4TH+iRQefGHNdMPnzTNW
K/pEPAS9uMJjOdFiu+APT+LYrSRnEg4W0dX5buSDGM6LBWAuMseoTMjbJJoYDGLRckJgW43E30mX
ej4823nkbfwc+Ecbrup825qLyv8RTQLNHafvJA5lSapdqXwnlOIYRmcHn+sfAh5pGv9kW9aokcdh
ObR2XYxX99rYloyvz3x0pmjxD5ILW4SQMB1IUEuuyqX6eb5IQ+kZ41hjvsHIuQH29vzpCfV9Jqha
WC5yxxK1R+cleZSKD1H1gVzbTei8uFs/91Bgeg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
urNc+S8AFPj+GVFdqJE5V7P8O6QI6MA3nkwYb8NKbYbVufnXKg6voJIRYYeYr7EOa8mrqirozWbY
Lln9SLWnkaAy2LvL/N6WahoQdCt++4RH+xe768XvSrVUFPrIwZRixqMLurc/tPov4i5P/ukZKl18
ZPZvXRzUNlvCZnMPcF+5QCQihqPbjcZ0YyGgWgX/ipTGG3sNqmylGN7qLa4Rgqu/mB5a2xVyu5Wc
911+/X3VVFx697WVaP5V0SbOzYN8R8+8B8kdznwixMA+f4lSbBXyRysVOSzYjo8bKEMqyKMVBQn9
xDmEuV0DvVWXdO7VPvWA1LuJFwS07OxeI2GCcQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QcP7fsLZxaDrG29e9HQeXfu2TsKsdyW7Yc1vWct6lbmDEfXkWMU1fFWSPIjPzRc9UOnfEu0bRn+B
D+8MWokqes3WF7txljBmgUPiNGZ8arUU6ENa/IY/Wv7iaB/ZKM5PtdnFAkjDIrYyKFCTz/U6Yzwi
hBGGarK/wYQOLzeeKRewiPTiNUL7tztWuMZ1t1msxD951EeKrwjrjcXIIuf/TzrOGUOlWgjHlnrl
4Q/lfMAnRLBNTSWG+5wWewCE8jK2X/gJ5AV4p3x1WP3+JglbxpP39l3pzedXqciZPbuz2XlFnRPV
KByaUaAShzJ56p8+0HjWebibqQdieGNPiPWW0Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 29824)
`pragma protect data_block
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
INkXQBPe36UUvbACBA==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
