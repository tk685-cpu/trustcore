// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Mar 12 14:36:25 2026
// Host        : GCP-E103-08 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/eleves/Desktop/Ascon/Ascon.gen/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_sim_netlist.v
// Design      : blk_mem_gen_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_1,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_1
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     6.700549 mW" *) 
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
  (* C_INIT_FILE = "blk_mem_gen_1.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "25" *) 
  (* C_READ_DEPTH_B = "25" *) 
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
  (* C_WRITE_DEPTH_A = "25" *) 
  (* C_WRITE_DEPTH_B = "25" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "64" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_1_blk_mem_gen_v8_4_9 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 29808)
`pragma protect data_block
7GwHBwR83vjxOWvio3EduwgmaukHTUi1RsE9qql2RCSgOoQjbJ/v9ywg0T7PGqRBw7/7dD0J0Fbf
yxxT2bohgFK6wPm9EXCPud2+YOn2T8R6U4RYz9His08mCWycNr7QK0m028xI6PatpVRJNlhnEVkn
OniYPrhkhapncpYs1pCNVXtFQOUeBU9DI+YGcYyTkCy1hRvopfSarI4OKWACHjaNTZSxWwnwFzMd
yainxuHs/O5NPHyht/AGeHLjGhuLE6Bx0knn+W30E/L/tG6ZlhQy26+2Dd2aQVxBVRT5PRjWl1tL
ZhsdNI6y4QK5GeVBfnH2APUFm7+X5LBDQgLeyWBYguje8Q/ai7a/Cg13Z61TUt665oIu/Jea9GyO
g8XAeI4AN2R0pytyolsGWhBC4hV8RnyvaCWqZ6ZDbDF+j+ImwF4trRiOcaCQk4ZnZaq+d5OLJDlk
ZVhBhwysvEFO4T+Bi0dR3QI9HJxkIPXED6HznlWWRNCQrDwleMXaD6t22Gqrl/rwbQdgZ6NX5uSA
YUbW7QZDP6IuJtnPVZSedVMdE9a7VgljrrARvnn6+lQ7NbGKWKGT0g605HbFJ2hbPbKV/ifMhmSX
yczaevhhVwhPcyhqTSjdvpBvm/Z9E3mULlt/qXJehzWumjVQ4sEYGSj7R8EtF5EZlzqYSKd+RX6L
baIw2MjIhEmnU5Phut2NlzyZTnANpYrygszWFAWlTjacrNBDdGjtWTBUUb5pBOB35zI/1A+kCNkW
iHzavijUaEstJEkV/rGxPpFd47D77h+d69VECeqXz+6OBq9GNCVFqPj0LC2cbKCtc0h6EJIpAo3l
ic3EZ1PnruAjK3EaMxmFfsUOlj0lUuoeURTIPlf4WY9pP9zABcR8FJEoXTyHWBNoPJXmzb41vQUc
DYC5SIjpEMtVl4zSxUtG60PnHmp3Dg4UiCGa8/IZR4GAIcd0B7LTPaoteUSA7Jm/ZH5DF5knHXn0
X+7R+z2p8rljcAkn5IVU/1dIu3wbg3HQSkAF7u9YkG+Uup1zmI2er5nVkaV8yfiqlxkX0axnqX/X
WQUMvzTsG/yJkMgaSRSffxgZfqzuO5+zMTJPIq8ywGlzszEdqhSMmerfi4v5PCDNNbGqjPfo9uHy
RWnHUx05M+5E7D2kKzpK/NPgEXn+vLbssvZ6F4fgMMIxcdTsMtuWyoV1NHr5E0Gu2Ku0YAmtEHzL
g4BQ8S/i92lhg0zY2W1/e3lcUFMPN+ac5fkjOCRqydockfI2qMPAlDAu9xh9EqZeWZV2Dc5X4OMx
6HQOfbn36El40DPISsjvsjmsds8WZYWQOcxH5LEH+ti584C1I1Kpa1Zj2eT1CB6O2L21EM3UaXGD
KFZteoPuLNvBv+UpChdfCbRyrguboqUWhf1n2Hl1taMsZiS8I55sv71c1sA977wQLiwoUKD/NtdB
erFe2amvYtLR+/C1qw6tk4F30vyOII5o1Hf5a5Je0aUluQwODBCs4jeo7j02cBQkENhmoSfX92hc
lDmNIcZ7iv1mQrnCJAzjefSitIfLsQzLlY1dcYSUfap43aB5H1TJBTKa+xBfstlwrOVQXxdmfl/T
hZWQRjSNjxxUZZQ4zmRS0qrchA3TNGwjxoVnqWhiqnBd8WQC1+wNM1sq67fqNmCm47X53QCAqWcm
r/53tjOj+rxL6gi9Q0D1MzIFTAIe2r1jqF0wV3Ez5Uhy028I93zqG3c1KD0/VgWa/m4iRLlstaMm
ioWBymcBP4+pZkpFeWEYJsfjrbHNPBDxAnEPNMpkdEZQJilYUbeHj0QUUF+cvqem2Xp7yzBZ7UDy
1S8Fd2cnE7MZI3H7qA1HLxY5/2u9AhVkGra4G3XSgWO3ssbR9W+LF90pMZ7KnZzHI1ogb57o4kee
7Cn2v5yn7DJx4zUwAGcvvihhjngUX/uqUou3tVBmukfFeq+frXuV+34ZlgVTE7GneFBsJj+DR0Sv
fk5dfF0yZJr71udKh85J6XbpB4PSE6GyWKiyria3vOkYZoVECZQpjJSBpcw+rrILmBywPAlNiSK4
kk0jScl/aKyBvvXq5QL4eV2eYzIOcjuJJghmPhB8Lr6anUsUPeIt0id/OxEuWq2dWlCUWWlxG2k/
k1V+6RvO46G7xXiS1xxQOdtD61rGCIDkN8mZFwjlWTCsnQqvYSLGScIi/s6pxGoDyhC870iyJGS8
GduRglvqPOKIMlYNnwRzmhSb5v1dSm1QYc1h1XhP1qH2DUgupGew34S7+LPxK0DwzESGSmKkolkW
Fgf0Hw9t65GDUvuUncIIanMJyfXFRjoJgYuKSAwxbv+mJlBzR4XoqdRcrWNB80DBS4nFM3bOZjxi
bDN5dGBJ7hZhwTCMrCxj/GPy3UJ2WTu0ylCE0Rg0Zr4+WweCMpnoaQxUCbMURU3tODU/g9EWQr0/
od4eos/CzTT2T7xFdcMQECSzJUPifhDus83+SdGeAXDVc7VSBs501UOSin1ul6byU3q5cacg1M5J
ADQ/AbMksXRWgoUxyljoHiT9+a+I3qAXFj6RhPLUJ5W0neV2B6+HIWk/VQCO8DZKqRDGmv95R/zC
NiwV8lPRkgfXUbH0DBS3qeI7gCHOCGDATRHYNnR4nPc1eeEdaaCxiIk69WhP8QskzNUekVNQmmpp
xKe1waWsqbg6GQ3z8aRvGr6Us5aTucRE+jdRtxrj26+F3YSkP+o66lZ0Rs1lwqCacDRoZgSIDUT8
c/xbT/OquB027pgl6bDjw3j8QofMwolurTiHAsqp3OZ67SUGlwq9HP9Ogb0EL57Nmk0JfOgBaOAS
RWAgWgx5i2ytA1tYUlk3dreWE+iSOjIhEO3IHHulmSfNyssknTdV5qHjNO353yIj8XyK5XdwO8Bj
dkol9Jct9Xdswy3ICFxRUjaKf5cKQMybrC27PaU2pYLuyR1u9R4mwSNHejvJkKI7+6mhIyOBkKWA
VrkzGgKB+rNuPhWMP/vJdDMOk/g5/quteBI8730buYJnH0Uw9PEmkgxiWPvqXhnB9pjpRpOiS2bD
h069B5wkr+IGao43aNLmWZ7+ep3jVipqGbdKGafO6IYFWrg9+xg078wfCUzak5PqylJmaMsZkkwc
flhKewAeJW/PqCsF4KaL4OxrAoSv+1yqfi/HQ3gkE7SrE+eFGNQwH0RTSUWHUHAfmDEYJWcHxZX2
GdTKfvYI4/ttGPEQxI4oOshJMHLuWykpjUUzdzI8aPJqNr0n5xu0yVP5IaqRbp2j+4eFKSN0t4qw
clDgEBAxwONUyWx4ZPDLHwPKF8FdNPO/JmSA6xhak7Penf+uVuzEaSj2PZu4KEDyUe+of2wA/m2J
mxNDSUCeneLbGFlRA0NegsTUch+srzFsVJ7yjFWD5z14vgzRgyW22wp+i4yhTezKOclBglsLz4dr
gI4+P7fM4fN5+wMTRXunBCU/Ksay/GE1YnLPYOPquuWqgsw1FLNOH7wFQamlzMtK15BUq1hczDKL
uALRPyEibPomkbDiEO6u+UUVPIuL3/8veQLGnclzaOoT9/8trwd3D+wFW+oSIK/hJwbmhTNTdawb
1xhyzbbCz+W4d+Y6FWGb7Gxzdlan6BJcaKXfoNzJ/Df6XpzfLF3YM6kfEmcbHnIq/Fgpgv1aG3qc
MetILGihf3gLa0Mq2vkFsA1UYIq5MP7TWLl/zdPSdYUVAHGUUWluPO+8zfc81zJyu7hAcngrY8nW
ZFg+Ahf1E9h7YXaxzkmCUBH3IvfGznp5u548WfEbw87mIxy7XLbwzfdxsLizTdUyChe/xj3EZHiP
FylhEgxKj/CisapcaywSOIo/bhvmEnLF54xOym6u7iu5kqAE42Mg49V/StOGkKUeBxRzcc+oHdP9
BcUvoVavrc18QsAMQoFySulit/7FAI+/+Eq1DHp36D+JGLght/u1+Ed6r6urR434uWUrwXHeLWBw
pwy3SwoFJ1wLEtRJnisyB1hrhL92SvYC3wDBFdh0NXBpM0HS5sshXJE8KX1ucKOEoDkw8uaTesUj
S47/nif38n/4XCwee08yojMPGFHfJhuov9ASCEmmojRPOWPSx44oh8Pl1QBF8K3vLGk7dAXvCmXL
qd+2Hz7PTJq41R7KybD9QQseQotSh8xBNwiyRpqRje/BQqGrfK4/O3G6akEMbV8J2ULQZfzunXGW
Aq8rjqD/PPi6zDo2qz2Y0y1u1ykxepgYKE7b2CdM6bdkRyLdU2c2eirBK1mM4YETsZtBDzymsHzT
EO9HjZSkMupqss9k3Fs2JA/CaBAfX+U8zT0WfhGgSsnmY455aAvO3VeGTqb+pnKy4QEaz0GeTX2g
ySZ0OFHMbXQnpV2bQjed0RetR+pRl41uL05rw+p4OcjS8sjJ+18bx265wo7vnEtpKHp9cz9QqtZm
nTEeJMbRuwkhP2tWCC/dz6WX49MgVL/V88eqwrdsJR2c8XLOjwABTEfxH3qxWDbL1feLcw1xXGJn
v96Tpfay42huGnQWPm8sbw8UY2nqZjRhFWbBEE3oqtMOwljGWGbM4zQfIdo9jMAeZp8zLJHDDDnR
rYainNNklcjm/GmejAp/k+87qc+Dz77giHgqL12Kqrp4jBB4DaLKInOOWonE+ir+e99ywz7oXANV
9psu/Hn08DnTpUS8/jDKzxnOHqVmHz9z0PagDlXqyIgh0qrPlaIyprpX/QRjhvUoj6YRSX5DJPjq
9uHQBtKmYN93c94f9LdPOWHw8dMt4pRYIJ8Z8l5YmFsrN/Pp+8G3yY6IDGVVipW6NePo94vYdtqT
tivqMblsShKsOsDDdRIYq/jksuvVB9g4yDnR9dWWN46fchCsRywZDLyMnoYM3dL5Rv8mydAYwnqg
vHViWHGupTFs8YtIYxLWgb1sTtJdigLCLiyZELEb9+/lUSZ9znmYvZww8i0a5x0HO4SFx1dwARNI
6oNe32FE79W7YgjrR5tKpZLhi6JZp6UP094or2e+/PjeeCWYc7e5ekH14WnyqwSRB50w4gbd4wsB
uyBvGQVRIVDrXD2i7ax/qNpr2RQKJM4dv6lpzn0WmYd8OZ6IkLdaJQ3JXqEy8FaBdBt9JLWdrIoQ
DEG2YPyUT2Vue7G6qfZyfFEa5LaqpEAdRUKA79LrjilDixyQornc9o9q28H9iwU9zmG+HVX/2Bt6
xUbMyadxQgOT4OXZG4lMe3nOQUQ3a/QJ3hR55ctKPu/p0mPs1AqHScyfimdr7Rt4g9M5w0fIJ6TI
1X4gvCQZ+w6c0On0ngpig8v1htStC3HarrQ1bF5TYPIgd1EX7yS1roBT+9swSuZlVjcRwnGXeXRT
5nRM6V6qMqc4ORhq0tLGZ3SItYydLwMjaSc75+t9qAXMWTN7nkdH6MDtaDr5NBVeePrAE8tfOleG
2wJV0mYUx/JA4sS4ZnWN6p90up2c+5Px2keW1hZVnNCxsZi1iCDeq2Za/yXTHyWT0zmgvxdNX7w2
aK+269dsk+FmR7AyulYlIZ8po17ZO8VQMcN3tRJWU8iih77knQUU/EDtU0ivksnWyobOcp2cJvSz
NT73D/iO5+gfBJzRi5PetPRLZ+UfHDEOm9uf7FRhdCUdqgiImfw/Oqc5Rni81xOCsTbs3Lby4sOU
26GKAou9N9hX6cBC5YPivymXoAQPCsjidZ1ZZZGQIlahBGGQ3QQbwu4tuDlj3Y/wOY0UAZHfhjKl
bjMMIJ7ODl+rdbOWd/mdyvxWFmoyuJmxXX22ZLHShe/D7UOAdQ2BY3CjuBK3cNSrRB/TFUv6ukA/
/6ncHNB5FpSBdK54oMOJcC448XQ1H+u+vOUa/I0h4UWBA7pq6wvg/uqVFqCNDbIL6S3Tlnz/+js6
RnlNNMbTypSPRoQXA9/BD/HEkdf11OsKnlW2O6oJkLvOgHLImsv3ppi2bQ4aPpr2HacNROlf0YmK
W8fJ9VKXsMbj05D4ByXaMzPpw7fsJK1HVCReVY0oF3Y9JIUwemNx+g4QSXG+LKYHkioBLpGQD0lI
aYGMYA2PgTYVHY++DtwINlPXj9SB/GVe87SeIHam+kntED4NaAc/iIDfsxknpUoE44/ghAKi/J9E
P5jELbY4SspQiNjfLHAc0dptxM7XVIoQlp/PCV8If5xkKg8JTL3aT+7v4Ita+BFQDRug01yhAexm
NAVUxC7XcAv3t+z/RJ15TsuJxE+U7wxVEeajZUufGDsrR0PnFeMkZspeUmmJb/87my+H5sLCVTSs
4rcXHSf8JUHcqJgsgjcZL84YhUMOVfwly3PhoxvfxP5CSNMtTTQwCwx3ns2AIDPTa7Ih/78b8ql2
ERlg70tN7q4qvMHvN9Llm5171bMMwSPeV3i4gc8xthGO2wCnXzOCthbg1Yw3UHL6YIDakf566QpS
kHRn6vl0dJlsVDFVF4iaSmFORRy/tIEKKClqodgyC39mxTy8X3rSyU1a4JBnl+QFeMfYkMu87KtW
xXsNX/Nl16PwOuGmqrDjjINWMzcY5NIoofplfMnjoelC/17Y2+iuoPoB16fBE8uRyfgy/qqTBCU9
0SH1i0n6/J7cPURwdkEqIVmHYvMCe9Yefvp0hgFw4T0i7YKVB7iyGa1jrozF5ZAG0NnXeEpzOiRn
5+0g0RypGNgylGbnugcpBSFYNN2+/6Culbhh/6PNg1ThuLs+7aksjSrI2NngSQgVpPRZKThZoLQh
YfhGjfeQ0yMYx5An/vg2pQ1pF/hrscdNK6hjShBHhCHUlpVySqk5TDnaovUdLv2ldArFS6RC1veK
SELMOWxu4CdU1iHmU8/PAqVv1EYIsI9V1oPeebmBZs9tQa1fh+Mk7Fgn0B9WuqVMcgj5wC+ptn3F
8bWtrzH4/lHxh/Ctl6dl61OoSTS4Ojp6wsj4HwUiG9qnLiEH7SPt8jvcpFwB3Aee/9wFuxDgAu+b
28POjF8M8TokeItZslvWjeEZECry5dzTu1VCRVqQn00mKRawPPt4x3UJTJdtBFOTMD/6w4gDbD/0
OzMIYDFBjZcnDwxPG5GnZjmWHYfmjpreFFd6zFaf8cwMsUjWLI5lWDTw+GJxe4jO7TRN9APZ+0qv
s4ttfPuUX8VWNFY96Z6FCAh2TqnMcJaIzetWDrv5YSD0zT7dnoiae+U1vqtA1Feru6GAFczD8f7R
Oe1lt+PnUMXWnYx59oJFV+o1+D157hCwoxv9uFCxd603bjh/PtX8dTP7nU7jmycioG26JLJP33f0
dCZFpm/M6V4zXXfPyzQ2G9hZpMZl3BlN64apnlBe2nIAJ6wyAzKfRQ+MmO08M/+lt9wHz6B0C4MQ
gYU6B3Otw4SnWWdQ6FJdkVEp1BNxofmQV08Z7mybJDxdzeJr6GWSk35jOqkrosFUHPDyPCgWJkp8
jH2n23jbc7GDksBOciKlHu+B9tkpa/D/N0YtcQZsSJuRSIzay0syDM1VTIqDvGk7KV/3NHp0+IWE
xTTn+YL9Y9BSFiKV6Dh3qpptEv8L1FJxJgEvShI9+WpWThQEfZrEQKV31SfDDHjueb9hy/HjDQ/R
GU+pVT2lv7zhqEVKKgSWfrNvTIh7OSZSBZa2qAUKc77Tg1wPoHxF7d9YYkw0+SIxizXVXP97/v6J
t3QEQvdOhDNVxrZpUaXsQbK22l8oEjpY6W+UeJiCaccOJ36KzdH3crohcWp5WW2Y/pN0PwBD6VHB
wSFJ2ipB9mOLpkKsO1trYlSUuoz6aceYOJK24kdgJYHEO49S77NTP+DbGgz2KK0KrYwA8cRFWZVj
pUOekUkz30hYOhLEYsw3cdvxkydTZOKNIcBQbIuiBHHNar8CCUpDhBVvqA4oQhKJ9hY2JNvJBBk7
x8ZK9HQGAK+VFKXAnYzl00zvRhLuQg+6yRd7EMcPj54qhU3UAMWWg7MEhUcXyNwqh+vfBzuy37K4
C+PSlA8vuzlD1u0FzitAg36cIVWP+VXPm4zXfSlqfhr/yLXURd49LgntakSr8IXGgG+qn40HnSWJ
iB99MuDiCKPDmBWU6h8VclUhhDTo+W7mv6yA7l2sKR0jv4ebbqWqJ43RT7zkBf5isODPK2twiSur
Wg1D4y2VsClbfwQtGrE3g7zxUGUjRE5zz/M4gpD/+DMPVFz3fJzCM038RAvpoHfjQo5zg401F8PY
i3g/8nlXD31VdxrTt+aaR+J4IfzFkMBE46fFjQHB3Dnab0ST7HBf4N1m/5m2mn3aeY/89T1hbP16
8v1IqWEx2FjhQINunbP1y0vJcmDC3m7GhQ9CD6Nvbh/LGCacXhgXUhMFhMDfEf2/axU41Mp6MZmI
txEafDa4uia6YowOpLn8+c0xmkUofGc0jMsMsrGEqlUFCjFkUPgPB+mcN2Atq87KC8vGBmOW4+Yv
BxNfQgwHJcuTclLVOlg2UawkREBIgOh+zcZLr8hp0RWXl1JGot8vHezr/i+lV4/HLIebihubery/
DRrt24MPh8PqM9yABfANrWX1AQoBw9F0RnkK6+g06zGYm1zStNRA7XitCN1SZB8c3sYbNAfqokAT
cM2yNkMomfuDZEYWCLE1XJoXsUV3hqVS0s0qsvOeKYyR4tpjGsB4qZbKt/T1enOFNl4deA5RdcMT
gjnEv1sE2JaTc43r8TcVmytiwGPN2nXzllTmhPSVERA9XntkGc3lrsXjLMU9RkxulQ7QC3rEs/It
MG0pt7zlmwWGmAiBsHWAypjH/LI4TwMJk+BPVHe+0osMde4jWbseH/VkoMztYxOh+UjtlJr8IR2C
638wB8y81znSxXAKkfFD6EKWU058Zorva8AQ5MCv5sHH8NlNv2Sy7+r+gFTC/05TawJf54C9Yx7C
vS0/Q7Fl+rB+30vUuFotplNioVgnRHg7ERjE5x2JZh7aimU/vlVEfKXrDDD6kT65lnoPApLF8P59
+rPPwajVsnQ80XEJdtH5/76ve15nFl5VQI/pNTMjUJkOzpxdCEwCjKj4CDkOsBDAk+ixhSEItQ1x
k29jtFZdwdoqlijKnufpk4vbfqnqxAxyQm2XyOjrwOrnMgOPaGfS/7htqSk+avIvcHh0vqh1JtEJ
m8/GV13HzgFRugdgut+g8HOrqL/F1nlgwjjin+wG7KQsI660LQNgo1bJBoNQza7hoFMHZEewXh18
NpHHkiFCD7ZVREzbEP92L5l593CGdjIbPwhqv6EpoK5nu6ztaPKsw5ggIW4SdRsHDTqV3ayfhwCW
WiLpdONXf/vls2blAYpGHVLQdPn1zFYr/svh53JfI3OnE4DKbhDZoBhSrHm8bjtbDU9TVbJmVSYL
A4vFWYNMdnKPNvV3yuFEkta6g+uPTcRWLbhRXAPuL9EP3bgNQSPRAm71EnlHETya/Fb2+qZGt+9H
l8EGMfLFnc52g+NIac4p7ZF2VpB7Rd32l1w70aHp2pj+jMfvDVQdzH8kadVZgEJ7fD3fNK965NJa
XDhLfjDs+P2mrAUBm0mrCQ2VUHjwjZCtfoo0rPpdqe3+u7/sv8ex8+AYa3wUNHutfHlFCOEDNXnb
VGh3sh7VeIRyFi4/ENelQ8minL319FLjZke1NP2AQ9pRCoZingnGcwXZ4AndvoQ0gP62Q9RHarwy
9rErZ3Uf7PtjY3k3adtxOspdO5D6e8T6QTzGeH6rwrueBnVcUPCo+2AANp5ejIKyNnvMq8dsPJwf
1v0OjzswQhjYXIhCn5GYLc/x4/XwKt45zGmQ77dNbALIuLIX6d8sjdARTxt9tPf2Hpdr08KrNslV
aouNk5KoflgmLDpOR3nCLZLtEVvOq6ABjZm1PodHMfZCUKoYjaU9n1csAOxXIIllAVwt+4QvwGII
9Xjth8xuu/ss7zRAjQCqlnjbJ5YsnolC1dS9/ylqyQQ7wYka7YMPc+OEhKqQghQRx2/f4XNOQwjG
34lHxPY1SsmIebI3J4fo7EeQH93WqqjpIGRk0KwohK/IHmD8W/TxG86Kxv3bif9jR5lZ1F+85NP6
LYH9vXbppWhlFGu61CWnJWYzfPHtN/G87Rj83C3DwuFwkeLnt1nJN0dPgdhLHU4cWjlfn3lLGpd0
s9kSB9zmyD/IDpg/Y1kEuw7egbyOdipbb5yuPC6bDa6jIJYTpIhxnuSlj27qFFOu5pgPbt/553eo
7kk1SF6MVOq/3wLgzrOB1gsYyGj7cN7+0CBq+Po7CPNmNv35m1FgTtYBISU6cynMBDDbEJZnguEv
dGfDA8649ohwm4vJAxvYkp2d9ByUaVcO0GinqY8MDrNDE+xPg4EZIjzmCciznGBZTESblvl++IcQ
C6GrMTUsGZk5CG0wTL1mdXR7neyYx+m5wIH+VaCLfWCnqr8YtdfWnw7FNiL6Rq/Z/SoHFBr2kCdJ
dtxMfSDaTLPzj1KNAaCje/7Fc0u78+g2D5g12vfORHGvAID8skzmRKrtvMSKazexpo51bXVjLcEa
DrJC9KmdICKhH8KN08BPfsO8yPVFRlULvZa1yK/dkiRJk2uSK3q3W1HKbm5P9luhuElJfhTSUEzw
2Hfp44+fJV0PMSFMNwh/fFLpIw61kFXBD8LXGRutknML03XOjUTJ8U9BF1fWKek24cdd6Wfm5mQh
mPS/vQKnGyLf1CZqEL+IrqhYzx4afMlFj6Dbtf0TnGrthtTifxzqpxPMwBeLAiejBx/Sa5HtUDND
Qi6mFuQiE/oe24LqeB4Aq1K1ayFYMCCvMSB/FCCdHL44eXQj5KAPSf6RhW9xQ2lq3Dpr+76nQpJ7
Po5tk0CT7tqk9yLQhj85ikrQid+lozQ/+uzlKFiidXpUvuUvD8pcxNa78kJ5l0yUKl06ehU5GBwD
G3lv5wVSs+XlteU2C2BvWDCgkNs/dc1/4JN3aBia59dtdp0aHjkiqkKF/nv+LWeTJmFvYpdHU+hO
m949UOIDr5iOvX+97cjpLQiDzJt2wiKbuCTcbhWUv3DYwKum3SSWm5/x7437ixqwwxNR47lEGNc8
Cs2+74DE/O7np2n04ZHvZxf6kObJ2ivCbSmmyADJ1rPmMYef+HpK7ZlNeUdaiQ5zmY4dNKQIxoJz
YFfP/pZu+YaY0qcusBiWTzbOIv4sl+eCOmVO3XbQL0s8q+T3UAQdlvw/tTrB/7cSTA4S2H9FsidS
ublY0l8fPCg2wUPycollZ1sHMLF/YuX0O9Ba8rUJI0CABxMeOLh6lZ2qyPtBKGEV8+1NLbC6C17S
O2sMciEL0M9dzkuisJujSciQK8aLivBO8RIfpTkvXWkct9fkxNkHasOZLrUMzVO+ba49APZFJ+Ll
kP+pIUrbjZgOpmh/M9qeT8ugpRAThrJOH4L//f0UEF89pnmyj+eGt5ccqiAnNA3lVPOwwTPgfJOu
Gc4RyxbQv8Yiy8kaxvHEaYi4G9jjYjeeqoQUKEvC8vckrHe3pMGqzAxkfZetjvRvyEnx0eZRYA2+
WsQJe2duSPQ6z0qYIZl3/2WiSUVWxyww3FNB2bmgCmRx0hGDF3H4+0oq09y+reiLD6I9/eIPMuMM
YSZT5sZly82iV6p27sO3RFWhs7qInO/AimlUphXIwK38pHEMLtz5fWjfq+MHM899LSk8iUObqneG
U5D+a9I7X/ZNEj+O2fmtQ+W0mW31HOU1dHfbMmIofbsSBOEf6rbxvukrCRHL9oxWr6tLIYhsxHj7
n5/6go3ja42vvNaM6V5wx9k4Q+R2BJLBX+8qj6B9hlFY6BmG7YMkc4usAZstaPl6ZxTAcMYdUFwA
IRKTMrqmwHdmboMKQOZitjw/8BjY+TjUDQwRDU+3ryxd6UiTbRsK0gKbp1V8wMNSMrL6sMQDg1Gq
1nYan+x4YNutlsI+plAIs0mbN5CbWVB7ANOnK1ZK+yt30AmP2PGmsuYMGaW0TQ5KTULcMlD8drJU
jsDR50ktdehV/ppMmE95YjITjP8OUh+rQA9W5YNycPKKsXaqAcJIqatRWINYL3bu0yFWQbxduaMH
mXubMyg9oHbGPZLJA2fMzscYAg3ErgEjUztIc7QjkCWXrqIdrvWLW/Yqa1ti+zzADH8d46zDmlHX
+a/48h0rpwzoKYG16MuGljyKDo/wRwZ5xCAKpll3OSwqWMY3e3bZBgvDQ//OySKimTwFgQAhsX+j
JAaJEWwfGgppdRxVwYIa0JImiDmvYQwp28xaoA6HN3C3wULqGD63L/ru3I4KgfB2LS2NaIC9Hzn0
+54sHe+lmPWjIJaJDJwsjz7cb5Uf31dnOePFB2M2+IBsxBOU1qAcqshuNjcVM4U66Xiudf5iSNC0
ze1AI0xRClsFrI5LIyLsWi9K+/NZ82jBYUc3dOS2BRZhSm8+vTIiByrQaMWm2XPBcVr0KC8JlHTJ
sYoiMgV4uyZbdfOh5un8Z00T9LiroorKuF7SPj745ihJ+ovgjaM/jnD9Qs18FxTMLYTKFYaUFz+i
zjhu9poF/c7WmOTZPCuXljeIMdkHU4kb1p+fgVdhd5QX/LOEpU3vQ55xUTi5/eIxAvcKln1ShmJP
1t12WeazSRojbUaP4vsk6bDE9BUuIqYFTdMkV3WU5moOBrdONBHGKRlBIMxCMP6r49fyjQY3+y6t
+JMs1kbAfdOr2KkwNssWATBj5SX36QtlAriQNp9Uv2XnoKvEuvUWmf05+J8d6WHVfZvT2h4HF+dm
On7oJLa/R0FY+sSqdgSnyWkVkenJnakGKu5zR6YVOZNZmRwpD8WPPbIGLS/xvZCF8TLlP9R0viM+
jJjHvOvj8SFlgZrsqXA5zWYMNdQA80+APg5HccW+MLNNIdfLTFh2cSbyo5OPVqZirCN4AaEPmqXq
st0skDkbjuYLJdMUXaM3SuRE/xNGa1sY523U/uPegSwr5JfVQ0vWZnL2fFVrSGmKXjCF68Bmc/IN
2Xbkgz0geWBreU4nYZA/cQHYrG3qZnPkkzENPgSef8UhC5y0xn7/SmOaYxIcn4Xg5dVNffRYKuXn
wRHEO7IZgGq2t01d1NV60eJsVPKfHLIKYtJ4Ak45JlpzQ7l0RNkmPwW+LoFNurcIb3dHzUdQqD3W
c2bojNjXH1nXHKd58j13yrm/zAxTxt9mgYtXX2riqhQpcXpHW7LFppEvARyK9YQTBugO3g4N/i3F
bw66Gd0bSueLMLstmImybbfl+T2G1a0H5A+ezYoy9q9N9XqqmnTcKfLWgrMshM8VJVrdoCLA8k+w
73b3ixoUofoohdsqQCW8C5yodvEliNekohseLcXWN2YasrKESMqT7ZMs66PvCW6HUEk7+EEj53w1
XuPCfpocmCEacXN+JdEIrHgZkX8V8nbmyDY/RGmK9BRvFWehpZHJn3XE36DYD8vTEeTx4PfeKqLv
HWLSm/XCjie8Bf9/hUkaazadEnPWhdFY5KdHs9noPOPH7aKQHVC8+/Y8ggpU9W6DpjvNJVQNIe2V
Xu9KgyMqkoqD6/t7E11u4WsqQUBkl04mj96fXMkdAiS5EvhvQqsMRR/ODkACf2QOnsSNZgF2uI/Y
xOO8XAoRq3VZWTv9SZbhDuzLxRS+7E/IgKae5+wDcK2xbWrkxcnDc6lSpxLQ8vinXHFQTz2R13pt
h3F2QXIPGTbqdutWjMstqlTZ8dbrKETj6f0Edy7tlhc8NlMjDvvsyDlJgYj3nxfmYZMu128fFRit
cLILEWbVyaN5ThKJYf72dPFt0hZp6CGm4UFVOecCVDGzcQrupmVuDo/fAwGmXBuNG4NwGVcLAL0l
0xC3jyImMKGKTsTbegP2B0YBEQqj5YVokxnJDFcpmo2qTt00NeUcaLtujjbvITAs3Qc5QKCnZzjE
LDbYXnyw7cz9PKhNQWyiX8nm9Xho9evd9+0SY4hQSyajnrl05isB9Cd79zw2sWUntdi7F472orM5
ev9i3Ns6yZH5sVYAc9On76b0lG1tqamwRonjooUKP/L4Mc/HgthpZhf5VjwKQF7VzVHL/kWV0IyM
hPaproT3gLahbWMTEhe5w+vK0KExOOZ6BLctSqCKKo77sx33qJMcK0i3jiX+r5dZzhx6eKwqhvAZ
0N4rQasou7AfaZiTi8VFoJhkeRb7K78X1SQm8/vz4DijKPW/gSvvbmTE17ed9Mdx4CXnQQ1OgxHg
Xdzb8hiEtLeUJRAWXr/VOCs/aoxOQMWvcjnxwfOzgprx97optdRHo6nhs1sbUDQHOrB+222UdtA6
fbgHWq3P6mesc+52LR8NhzuK3EawElJi94doMGtjR8pum9pQ8Rb0qgQHh8oegxk8kFYBSX+ZABdw
Iu+yU4XxkGBQioDtGYWxklEAPJFQJ0kFxjWZ7cLTSngOKp7j4zoTMW7uruqljM8Gk4u8is11Exei
YVvLUX8EPN+JenP2GktI4L7IGtWyRkZ/eKtv0d9PFGkHGWvfVe80UcO49BMOE8QIn/8WxBK8vN4K
Bju0gy3tUTC02RJbZFTs+k6GCRpw++HApXPFwHBpELXDJO2dYytaHa4wY5vt47cJlHzi9Z7iYlhh
BgjsYGbH81uqBlUlJ2xU42J1W7bUtZzfEKd67yV6HeamOdCNzD7VpcM2adkLmVqvKq7KanKi/NOj
UYz0u1Q4b6CvSOIOuh2Iq9XzfMzVoCik5q31Ysf2Ya9G3VyrBuAiiCmfhp7Im2GBYVnixuTSCeRv
uo76t+EsYU3815GyfxRPkzklBRq2sQkQFMXaek4PAy4K8zMaQ33ErWFjQVXTSbsypNcrFyYMB3z0
n1zkVOWH24AdLoznyWOUCLVvfowhZHSn3rBAxzKrlEu/yONPe6meEMhsrXojZeIbs/Nu5sSXqi1v
TmQYYDPzlLpDiPJfONeW5XXhhWHe7uo1ZpZihQ1g3YJkBlrm9K61LT7bA4IjyBc6jlnOhbqTIDcq
BOg/iUu8163eOYbKFxGe2xA8KKCUWYtTu/d/lEdeEeLwABrj1pVOcamFvafhNTVrR5D5lP4q+GAK
s+oLOa/TTMQNpVajfz9S0CBhoqXyQ73emuwhXZuceV8HuMT45LeKWlIob8w8OIzVpnkztxXlTsht
M1FBciZcKN0mQXCPc/q0buKlJvfE3x8UEuUhht11a0Ibt/katDcxU5GIbrua3aSZeSet/tUbcfHZ
MKTYj9m8QAI2hvJbOeMX49SSlVJhLpeNBC/pHjjcJpiHKnPFC7n8XTT2mBFLUclEbvO2TeMfYnQ8
zuHGIi1jKQfFaargReNyuiSNsVwacdsRmYIKhWqmWdcTpqsJu7/rwuJeMKEjx8PZDhwYEpcnTtGD
2StDC+yBXc25jfC7FkZwvOugOZZuni9o+mH3ypYehu1/iJgBw/loyTYxF2aL8CWFTxwziVrrG4Z7
qUDWM9TiP+zNZ7R+DNRPT5LeLHwVeRPRj6VVpk3DPCTGDjh7wmEkNJ0lH0DcgyMjMT4RjHPfnKCx
3ZjshbVSIrNA6xq8+pFzBr4G7iNJNlxNdoulCqzxJNHymZssLK4rS31jY68QPFkYq0vPhiwTFZv3
s8QBpSj+sF6aGumWH/YoZ7E9F/4/s20XPIZRG0ba3HwD3rAfLorNZZ65yz+FBQYrDoe4cDMlOp2o
B2xbbHT/yWOtksu00r68LpAroMbWX/759TNNFAXjHk28pUETmnAAlIujBHNxVPBFAhR/Y+acT15W
aDQwxnzTQ8lvqIi+8uP+27qRl6ItebePezJojKksvFLr8ucfOCIMMXlVVOH+DVXJqrN6gxTV+h3a
c8GZwzGcTl+7mX/bzxkpmB+drAgCaZaY8W1wF0MxVSAHIV6VetU7pxH+1HPjCl4WtJ70bOUaxcAR
vHzPQ1AyZvdIyGzDBbJYO1e3UveXTzAeYV0SZ5i3RKcNrdStJbX6G6d0FYAch+XHMqZJRlbaKjI6
VEvqM3IymSsyBpELoHz8fH4AYidLF6AWtdZMo3Q3aFkD+s0TudNA2pTfX9QjVwp8NRzhKBZahubG
x7XNFLpuOJ/egPLy2OZYbHbePQMJ4/ilhlqfqOzLpuwQw/4HlNmm5zgPBtdlX0nPZsyjEjj/KYVU
LyXe4+nwUR1MS6j6KLz4HTXL0akALzBU7v4DnIV/mp1hUFkJ1XP3px/c2lnvBF3CF5nV8flqpGxR
cLaoAXx73UFVVq/qMmJ7bROYV7Dtz7lyfCkkL1SQvU8QQu7xmD5P7cioku5HVje8Swded08lLXRx
fgYPpweLqd3zXDcXR5r3NzswnITomNXQS3TIBxG7GfkqaGBduHGBJ5so9QRipId7KbsQ6eLC9qtD
8cTh03JJBpX5Pc97wHll4PetTHKl1lXi4HLkPqT5OhYiQGpGTQRsuV6YsE8ZECqEr2rZNr94ELVX
2IEtoCickCcJN/98mck3yiOtyZfaHGlmF2tAXv+wBcyrfGKftPm6M2bHrBC6VvUc6kHwxKfr3yu7
xt20Jx0+KAq0bssVcAP/puZpFDGxicao96dBG0vS8gwf67WRvifrqp8zq2ptNZLzYziCVAgGPIU0
pqPMBuyiR6AIt2UvaTMooflWbaL1OojVbVf0xeHUoAAamgBdYFtIjWaV78K2TG6od2TF/n3SmHQy
ezVMkcCneSv6uVJMNS0YlwLGMzpxIKkzleVhq0vrLwxP/Y4+X2y/ILKnJcb+Oy65q2W7VvXhClq9
FMVVoexmmA2eGaFEN9/yitN6YdXhSRaGoSYZaj0TPoju4WPmAl6MwrjBBbbOltZ90h0XOEh8MSz+
81iMkP7Bs8TrpFEKTlCZLSq2RpW7n0YLRV3MDX1fdzU3uaNMOo0MpQA0LztP8pniC2//W7f43Z80
wawqJPu9RCveq8tYGnT9e/U7Momxnz5e/ds2C8DZtHVFrEPgCq/myJl6FOcpbZWWa51aNpL3Flo4
oy884b/upLk91VArKgMjr5gFJMOSsONwu5NvZOJH5jACImiCTqT1vMFeuVJOC0f7uXhmHsU3W44r
yyCYk/FPmvRV5GNe6v1ng5MDRl7LfPLWoPPSALS1aF1tRSR/Xuk93gFnWRgCAnbQcpkHtFnm/Mke
dXfjAn3eXJomPnCxT7r42KWbnzw9rK/Tq0z9re/7ZgRwpiaRs3HLgRV/qLP4iSZPrpSBsP5sqAVF
9TtVh1hmdWOK9X82N2VDU9AUSBrTSOtBfhM9nEJizrZEqV749zehAX3S5g8qXNxMT6govhUS8Inw
FOftdvVrCq1ZajKOpPBhembkyNolnMvROctpI7bu/J/zbO6w10tnVE/mO8WpTL2+geskLFOo9E9L
xxsTAOZpT/UbKedTrxG1g+Gg0IHeKHZUO3nwjC/ryJaLbHOxe23/28HbqWN4G8NyfVau6K23eoG3
ttw1VFcUCz+n/Y+9p2h93H+PzTTQ7GiLjLd43k9IC5rypakhLozbOV8TLEGYGfAVEEVuoHU3YK/+
VJf0Nkzjn1q5ssBwE25IZPEdkzqunuz86aCfIBVSpnbKyNA9UEo+AlSaC1S4zbxVtdX9UgnoTUTg
G9QvuezDQgLs5j4QJUVLaD/lfogBlZwN2vMVi95ASyTvZGA7QEQH0Vg9fmpoQKz3z9EiuZkVcpRd
FILrVb5Z90u5RcNRLdDnylpd4QIXKBmkg26XdutlRxitMZ2SMgAN2Mdlz3auffez9EQ7QpZVg1Os
LY/h/4DHih2qogz3of2FOXh/y3tATTSQx+G0YV3Pe5oJA0KkNGaXzW96Ug/0NQtnua6yIVCXKbry
x9iuOyfx4RD/PsZ8i9pJZj6uQZFowYn0il+RwsSEx1as3Xuolk2cEmqP6hsxAoK3kaCdsP/ikWdm
Jxvg/JgFZjdsmUQuXsst7FvZwDOIarWKJaaDvw6CKJg31CIM5Y+J9ol3+1Y8pWR/W9feYls3gIn6
IQGZHxrajAUUK3qzjkc2yNO05rZZCccWZop2tnggCp6Eka4fqwwUdi9z7zF8M2PIZxiTuPDoQpx2
FBwuFpUVq8fo5i/fe1AMN3VtSgwfIyreulWKwl2/CXZJTes2vmGbMCpD6ccMgegVih1WIzKdQBoz
8dwgmha4lDQHPSC3YtsuIxAA11fgYr3cvJVUg1uOeGLdIviIwiw3mj9QQ9IFeuw0Ioh+hWhag2Of
hPj8obVdTjdume+YP0pXzNndLWI8m456pEPtsOTp5HIQ2hUJvtFFx1lah830xMNsY90MoAZ99XhQ
MPcd4uD9+fFkL5cL7vZ3cK9sK0oG6/z2CV/dAJdwkBi0/BOHtb5yIgRIW/VIou6OdLr28WfyBtfb
KgcVAG9zBiQpnIF1SLYAdZrYJ42RQZHQVgPAaK7Xa8pC363p0infTi60BQhXNHusNvx2juNVhdjx
Q7PfMfsGLcfMnOShdA68kMb73bTch3EcwWgWLSEH2UywxiaUycgbMvG6dcCniGq45GuIAsJAHHW7
xncamDCvEQSvXjmgTaLJ3V7o2rre0YcMJdjsjhnooy8Sg4xQ3L0N7s/rx8klo4VPgU3IeWB/wQ78
bljWM1f9pt2xTeLLae/7yszgJf89a8IbEAhqPLYNKjspwuer+2qfBg4e79oMpPx4AMGEo2TXPwZ6
xV7h6Y9PwJUXzalOBPBdqa/xDX8GuxBGncn7Qhz8ckYdGiXgoeDYpeRNzd/2/3rcV1YgD0+pxe4c
5Rjs2uPTJDLLjzUlz5+sIZ4w2UqEebDRM+CVGBMNrFvX1bnQITAafFuChhxr+kgkEv/41cjMLm28
fIYpBz9srp6neTZO5ww8Vp6ciBLLc0jBHxnrD/t71qjlUQqMsbrElHb3T/rHH0GvIpvhaOOa9A1/
1eff9589DkcRE87U4YJGgAiwWr6gTMpPuaLL2rqEkg/VXm2tB/+r3e+4tx3W8pPBuszjsFE178rE
xxtuEOV2zstIBfn9Fyi4N7hYPWDU+Pva5mC5HbkS4QGzzdgQlKHTfjOOqVh6XyzxQ4+Q104vvt+9
yaaCnmbrO5g/bud91GpICCkWpTn13NHo6mBOrDs1LiLnikqUaggqoIToPpSaztOBpob0hRwjKx4y
VmDQwMYg5wsb7PQTtSYcGRRetMTBGkZBqzMv7dBk+KIPBF0h7bpz8KwwznZ8Uz/wM8GmrrMpK19K
GSZrUKt4USJjYuCBn0mAjsIv157SoqwH/7xZDqKyEQitQHGS+JxiH4EJTmY45cBEJrF+VigTk6LP
TCOwlDEi2lyxvbt4998QipIy6crsil6vLjaIQyUCBNYt1ROqm25RjuqT3cSf8MNwziXpD30U0bvx
ixZjLnxIFeGxP6XRikzJcahu6autqG6VhlTp7ncMButAXovPxwSGZgh1UTRiSNZVAbcn2GrR3VVn
kjZGFWGuyOc98+BKPQbVwZxtdCxU2VXOk9u75zMCyl5POGP4cGF00wP4Ov3nYuJvBpAlGzmVwIW0
sFfA4aFnKzcaQWU/YVBodDH0Ne2fhfI2T0JiEBCriIn4LslK4b2e3gyDagzC8iVqAo9LsId8yFub
pVAoLcjBQFGBhQmLX2K1DC6B02MpQFbBblMcqQAdah1rxQFgh8Z758uHywq/nUltWLdbCcPcWhrw
v8spyvFkExH/Md31pFKDudMjwfrDe/nWr3BIhv9/Epo63z9o+8/fHIVaq/CRe9fal2fhRUa6i4wi
pEns9M17Mi1f8SuMdwQrvJp8dqLQRw91a1yZBNUNRyI5B1lOg2oOVqN15DfBYPd5rHlYOW5n6dlR
Iqz4/7Ikx9CnTSVovCHFwAZEYyW6OG9aeH2i6dybQQA8WseIX9Mx4bk/93foRf+StfC5M8uUtAQf
pKHYFqswZ/lFrTsPF4f9s1nH0gapCG1qXr2a8pB6LF43za+K3UUa3LLwmLLsEdvvzq80xfoqQMkt
ma2K3Oo0nBAUl7k6XZDBaKd/qAEMxPLzwnSOnNFBwmfzb+teSKVmvDZlItwXHk3FFx/wL2nmbYvW
2zcMd2Xdw0CU5dlPM4t0CFZUTYLcqKlKCpEAE0ue3JrMgSktFP3CELRENoVmhtNAJ3FJpm4xJbSD
Bh3kFfdHgib5Sb5PynaqgfVtJFdQwMT46YSY27w69pMjRqFf64ws1sFES1gLx2PnQQe7ChnkyDXr
z3LcknWjXKRhuOTFTovE93KLQebPtDGjd8g9mH8m6/NbzEDuOr5bYPZUNIjxqyAUKzvfgnuwrram
4m5fxgqxDVGJJgJNToee7fM3n42HxGbj9eltaUdm0s8Gu5NXQJu4DCvsSQ4lXkpDSYuOrbWpoqWk
ZKrNw+uV9SZgSOci7h6Al+wNIuRjdpNOE1zvm+5DI6Ezr5mZewkU5jMeI7b0NiJ8j9HSaXqLWwWy
Qv2xEl3J9IA46F041NX9gBPztxQ4PkjDONQsCZ3l56BcekXKWDElEiYzE/aKrzCv4b0ckNVNecLL
rHiySExLrHlFz29WkmsPaMP4WhFJp28qJzwNlkkVB9k2IN1mwuC/EZDO1Oz2St8sHxdc1L40wosa
MZG1yvwMDavipD6kAUOceWNfxcvxid0I83SV1dqJwfXG8R3KL0NGTiy+pX+kpA0SXtlLFi/5Axm2
KhNsUiYwL3pSIhhewnOtmWYDnO1Ceizt/7Nq+Vm5lCendEoqq4QRZw92jS7o/OtUqHm9xwQ5PRGf
JPW+zdO4z8w6dKJfpEpnJkYHoB9TZHqJsursCT0eM5TumtyFXbwtfOz/kEQBVBfLVKKrKPd6bcJS
h3t7CjX2/Y5hcVti4IN1QDD4OdwxrNChYazpzSQL7/knzUbJa/Mt/P6SNWxwzU8RpOAh+iNDcEpy
oKz+o7q4BhxecY8AAvH82T090iPP/Z56GUWhlzEAwXSbMlUSic+oizVAinH+pd4RsDks5IyusUnx
cJnQ7Ovy7WMXOLxtDgSf0xnYGDA97kDzcipGlvve8t2FkQyaad7pLi0ejUJ6Y76eQuV3YznIiV3y
NtkCqYZcCfGBotelYdEAPOM9NxJQOBmenJgKGZx/8y6H264pnmw6h6YhLAOwP9ggXIj2bAuXS/C1
oPGuT3Go5m3hiGj74WXCxtRGJjLjvTL4cvq1p2Xfymx/zm5zlEqb0zR3yJDG/g7zRVDGT8HmLrbQ
8eWMdncPqLAWVGBC/+nGV2i+t/jTA/7QFQI0BdRnY8LumjBjpkP2r8unDSJN4LH0H4wCZUfastaN
9EANxUOujSDa/kYjzrVQ543/wPBMUhGfxMVNNA/lyFf+8iYf4xhAUaCaUiCon+EPOUPMJJ7FN0eC
uJFPjgeYg2DgwWO53/YBrksq+0Vv7RQzEa52fKeF6KaRbkbl+Ax+ow5IBLDDIVhpsi3hzu+CW69/
gO5ZCoSX4smq2nc3N3FaDBxtY28UBWQCpnQHjgiOGaKh8Fz6T0EixKX1RFAjs6aO5gQjg3/M9my4
RrbZ3ELBy5bjkpPvmHa31ISB3tu8qbN27U161tqq4n9yBtx9+SPhuF4x6kPrwWX1uRC+ak+LI9OI
bIei7fs0F0+y/JLErD744XlbPymrT7DLMtMg9piBEUCdEcJ1jUdTxMe/U9Er2JAD+dEDG/huRG49
RFfQZTBlTpfRxIkhMydgryb2b+xch4OcPw/1hLZNJ+u+DUB5WOo1ZoFy7I6M1EzJzwH0xZjy6YcX
/J9OfgGBqjg21S9AhT9iIo23IKDUVg95qdQp5fc4GzYCAnSpqqzxwJZmCvyf8QQu52GNAxNsuRii
sArM+NgryA4ibonmQqnmonESkF3OznJpxrRuQoeO1OdiCaf/QPc2hs0A76iTuumoCnvvsrzgxVho
acWJ5V13J2y40ndcDX0w7vlxTMCDvqJLmA/ZgiePUadysqvcgSdWyWZFLKwq3g/hJ0gPR2MwI3UQ
AuvsFrqXW5ru/y71JAG17mJuoii7ewPH4giFPNP+FZb0lRGHWBLfDSbKSqz9NaOOIXzgRxvJQOo5
WKnXH7FsjTSILM596h4cGnLbDbryIJMpp+RKj0uKz5xcbMZi8AQaKAuRX9TSuGT/xggYdtu4tckk
GpQbIMTkJNdmvSOI7VymWq+tHYN3ET39rIVrNpe2X1zaEaod2+BVl/TnZ+UMXvJPrBGb+Q9PMBhC
O0557lPNDyy04Q/fd5SVytb1vSlgjjqMS+doLNCCnNNDKvcyYaKyn7HQdxDAIBQlpe/ryo/pbNsc
X/lcqXQAwmNzZIzRtYjwFMYrmlAkNBFw7DNs68SwvnvzpZQft0I26R6ZbTsFVZ73n81V5wyrxExt
8tCq9FmqoaEuVIcXWHSjJq1Uj7nHoFn57wl1wGgcs99uwo9eBaMVD4E7iCF+dfiufmCk7ml87JXI
vWIW03gvjBp7O118ax0C0+gV0dJ1uhuavRTyUdUohtu0fziG5xtGTycA3F3ilHRR4MfgKl8TXPxQ
KfwtUWujVZLkTVztVWw4DXcovZPhp1hImq0GUFNC36DHkEqrBrnaPksP/ErZVVglltrgQQAL8KTX
xv0VtKOyCYs6MEeBrtcdHVbqWR90q0Dfsh5BQqIc9sD+M7PYikUv4iVy/p+jMcCN0ZeDth7BbqyR
ScXnRiD8X7LQobgu9AAaVFVoXuVRIRqQQpWEaAevRzT5NNyyDsuGYTbcGDxmxI03fWu+ldUvkpDC
uPmhUecbKMVTNTQPGm58pgJkI34A/Q3HiL/PEz+KD8W0uK1iAkOxe7BcIw5UA6xuHf0SMWLZtxUW
xliook2VyMpigZKyiJ8olBUa0bNDRhFZiWmfsRGRyM+CgBTMJY9pXVhTzgCHHVmPwinCGQCOQJM0
+AuMWEgBjqggPe/2NQjT+28JX4SPuom0KH9Mc0sBWEY62DwHGAwfU+Q1oSrjVfz9mR/BYXavK0SL
4lzE9MEIAjDpSB5Y81aSAM+8kp1WMLxQuKPJic0vvFZkMQZtLgLRf1KH4h61ECTMo9CLGfmIGU7z
gdJxHbVLxGKBnZ18qrj7vAJaUyuWom7oX04r2BbMlkXiUbVVxQ5xoZZyeVy/AO73l5uM+J1/m/XL
J/fUg0ZnNDyVIRxJyD/CcbuxW3Fv0l52XyuseYz84EbANuTgnZfQ660Caejr1p1I1k5wrV+VXFMT
fYBhw8jGUv8FgJ+WoAmwAdRYPUitxc3tzK/KBgkrH42weT6SANSGiFpFGsKPRciIlMUJXs9QsUbG
Q0ghoKfJa8TdS+UUSNAw/TWAdQROSEhFypTYDyoSmeiZNiyA7kYduR2BO+AUKgPYRBUGvJKOr/69
jJ3D1wCS0wnmial9I5x4vfTWzbayLsRJHwveBxtnQ0Hn+WltgmpcT3BXBjYxiEaJkGefeS9wkp5z
PY22ojf5ldXjvkLlkzhrATaHJ6wDv7dsAI1IYQU2luwhq+e8xgOtJFkLhfcPwdhroC+qS0TKxPbi
1sWOir96oUwz5DX6nhAmitKRK6by5fJVYpht03yWwhhw3/ux4mJRXSrZYDXSWdxg3opZMLIkWr+M
dc9DcjgznoTXqrm6gz/dR81lCp8uKfGjPGTfqeNwRdqdtwjqbhP0On4V+/9wK99NAi6OhARqDErN
775XwEBW/l9pEkNHG/9v8mrHPzvfcpXw0igykWCtKan2XHpkMdtVQkE2owMHUwR/DcjL05w7Y60C
gZ7Sl5sFR8ilppMgFQhe7Ufbo6wmU6k3lu9/mWct35vSUdyvb1U7aE0qQLEQbOAWQc7Lf6aakzK0
W66N09YBTpq6cIYP3PeFz4Iitd86+5A9VuUeUe5YZbIsB7eSzWFs7m/ZcDNa/DicnF9SnjCgIuQm
VmikB1zoJFLgWNxOaNwqJgI3tDrSqIXcoZNPPUfSaxzOlrZECcffj9YhCOJqJnmm3owIJUZ9xPxI
EEEjBk/UIP5kDs1GrpqiLarmrU9tADjbPwK4JdZx/LotYTl1twXuzD7C/aojWJcOcmc1lofhplHI
IRHv9117GpOHDKyh8qqRhnk0lysoS1dTrEfO5NP2IMhaf50H+Wiyh9LqkAfF5hocYrXo3xO5oxeY
5nJDzY8KqUlaOsXplNN27vv28R/8InJjefwFaKARMKXC1R3ZaymhdtTSE/WrZoYhZcV4n+9+PPjJ
qKs3kBjAghyl2Ugk3h6nChjYikQpPlhoImclAGdKVf3AY9dH92o51bLvojytKkIvdOjoTXvHQzKm
E25Bx8UoYT9BPk0OFO0T1kCtzN0l1yP+j9f8p8X0fRBgda+Mzg8sjp1M7Jmw3D0rUN+9TOjH7T0e
x63xw0LUurXbL6VUTLwbkLX+dV3YNzrafQxOh1GttBpIj9ZlL4pOprYTCqOnnd5GLqZgRZgQ8S8F
+g2Ei890KWOJNGeDaP7IsP8NsUs7ru9QjGNvDrAj1t+Gr/KnwqR32zdUfIHmVQhdzih/BWddJ4m5
0b0LmrIsIHyXY/L1a16o+alLuLufazx5yuHvo3xf4vAl3MI7lHn12kf4jQtWOZRng0yqTtMcPQ/T
g15YL2O+YEjaE3BEaHN4Q9Ds99Qz0U37pwZ9oVd+2bTnanTxFADChXghftpXp1lOBUeEVQDuyTU8
JLEokfRMK2lRPwRIEhDIYZdIFEhYRgRy9daVmlZnzIBX8JClDsxoyZwldh+x6qKxF+anVZU54mBi
vfVwqpCCzhgxDx2DhmnMaGrm/qo53MPl45cUJLxjrVCJM6XtKtHnbxqBK4J7IMHapGfzJgLmX9eq
WkI7ICrHpCMdo63FeUTqdWrFT5lWhnVO8OYoO1UbpUF90g42dtXpiI8FLaJgaLgz17tHpMPCdUfv
27Ogk3xblhr68mkYIF3bN4hyp3/q1CrmdCPejvTaZP25lJtOue44Cz8D9ZMUMwMQfwzOFnF9I8zK
/LI0Vc4eJfCU9zp9pC/K1QMhIe4eiM7GtxMzV5r4nptRJ7IT/3X8mABSGOiuhALVyNMEfoS8PmrT
w4sGsbBE3QQXF/cKMcKTLxdPFLBSop/kdW8mqWp+2ulGV1T6w47g2BcNNfFRLMVDpWttjBsI7eIL
VonLeMQKFZPMbc6yXTEpVjqLcVbBKVJ2zxEwfkXWsqxdjAzr8nFNZKaUdZ2HdchAnz/Q5g9dB7z2
FfnBz6dThTnvdo+T7mymcT3lt8DlJ/dUNAGco2B2d4WJKUsCfhWZQT6sH9Fr705olEyldYfujGFo
/d39baCv01bitMlajfCgdPFPZ78aZsfidtWRHjNM9bQVVlqxraRtQ/l9eCHrKLbodveEIqcVidLe
qxB+Lbb5H/p22U35v+JMGMOMleDtAxEkwXw+wkZ8+Uecq25WK0vcj130mfaOpeGQbOFzmgb+VaND
tU1WVSuNbjpZw4KbfSBiT6p47JJXGNJCSkpC4kJRoK6+fn6ROv/7K7SzSKM5/xAc3X4CBit8/kgT
wAFeksEhpMbB8iF/ixZoHz/gCWTnRWgMsICx9Vu+YLJEFBhPgwXCe+6BqhUidVmqBY0QvASDkeCX
QoWEkp9ZK3ITja18V/IFDzIgzA8/k7EIFXsfORt+z7522KEeIsziZ5v69HSwmjUkjhoThbwc5+9d
5EPXh25SShafpqBXkIn6hHJHIEmWfmwXXmRhYExAgcSDzBHoHgNihrLrb/GLe5vBbCoYiKZcNw+i
xucsGzaqRtBpl8eW46dm6fpZg4W2GtJlrY3oWNOhESqsHTpblhojF75I9gHkH5WvsuhGIu8yxShS
ZpDs9eV/bggmgfMPAEIHYXsXzJmLuF0RoS5cqnaq3Nk8wrCAPRAsJB3vMKZHr5RPbEgkNpU9CoRU
BLAXkVphp/jrj8/7fiea/J4lPRNLQsqHqjOEeQyXyquPgCIKhcJL6Xwrzk2jouCZcqycVeBgZA92
XD8A11pW8zCoiMnvgOEymAy7kNuQdce+07P6Irm7O5+tafzbf13BdgQdTLHoB6RTpFZ5LJPprVAM
r+YhWNeclNz5Yndp3zpP//dNm3zT0cZwY22Rr/eVOxWxwJI3RMrZwZNZmMIodpA30Cth3cKagXH+
9i2OMBiNpRIS6wrtHresArMyD+Xrt/goPWZ6vQVh/sqAi1agSi6kLDIKHAcxo6M+lgQhKZYzTIOR
+Dh0ZlCcLMfw1Cn7rQlUqy9uniABU50zWO3voWYfOnqLWGVJcVKx8LfeuDFpQ/TZ0of48CWW3gbK
/HRG6lAxIfp5WKuKtxEW/JNnLCl6a58BTiARQDk6PkspdmiCp4lc2tr3ID2id9DvjCtfIdowEfRt
+uljfxjwgMAvvF3e4wfV1G+y2HSuhr4o+CCyuQM/EXDVfDxC/Tum0aXYlJVyZGs7WOnpxViKL7Mc
XeT+4uC6DyRmR1TZ4YtrOEUs8UWcKH0NBU0Y65qkaf742St/bE+J0Yt1BYjJZaEE6clBvlEGZeIL
2Phk4T+dEQmeRqovm4HFSV4FZ26K09A/nQXzjvEobvZtxOseLvJypNZcCPfArj1MmgjLDUSZ//d3
keek6Vm6lnfODeO8I0EX9EwtuiNLRs9RgadPLemJUx0Bm+ASS6E4e4cPupzmqiS1TUm3LvZjouY6
UPgLjQ2k9i+JvWvqQHlKw7dr+K5IsqaqvHZoDznYm3b7Gs1e1FfAVhhs8X/+Dc7zRdxY7RlRc23Y
vT1kwZXpiYOpBN3tapcB9VXKGx/Tkg68SyHClKh9Ijwjm7OxpsachJbneiUvVicS5+j1uc8DjApz
6MInKT1Qp13uf/yB4X5e1lmZkH24LQbV/1WYpPUMBrN0tVNR1NFOWfqSugPh0xtGkju5ZAt626hq
lcSXRqdRIXyXJeecnOHQQuHlhnqUpBg27fxmTj2/0SrP8O2Zootbxw2M4KK8dClvj0wuaCKHV/hm
Jg5F/+IFRvz3wlFcV/9KqmXQxcYujOB/hGKomkCG4MnWdX1bCMhepZUKIiaM+KwAMVIy9i6YEAxM
HGSN2FOaNb5Z4NoWcOjUZhYESyBWJPywb4dZRz72SD0SFuZJ/HTM05v+lmCOcBaWTKOalaawb/QB
oK50IP19JCHIR/2OVlzPT50Jc73GN6b6bXJETvNvgXNyobkcitaHoI9Vij4rieMIJY9Md/GI301w
yn/Jd8zKqYRfuDy2lAzOIMUlX0rCk2hD5br8P06qtBPCinagufeMsD4hBI1rVUBH8RNth/6Xg4xj
ZPGYEXUUn3Ni6tF1p+pTHRo1nztSUJfDOM5Buk3fAnp/wqB4MLTeZ/EFmZs571O1Qni6ApzWgK0z
ztSBUh0QsJ1a1+VC1yY6DppIbFkAG4SsoZvH+CJAsAoTetDTLMBCWLsgvvIVEYtTNJrpY7ttUuqa
33S0LwVrcDvLajfddWYsFxOB2lEwMYVTmeaq4oMW2AcwdukmxyDWD5uj4qA+JKWDxKMcBF+h49UF
Xa/DsdRbyEao3jfvMmzinyBe7pdfbRb5bTmROSa7yOhf5NKTt7KjZj+6CYPO2I4hXaQLqLx/W//W
3535GOk55/9vXnU2QDFjcNMt/PrPB3kTVAGQsYxlYsU5Ei6iK73ZYJUWdCkebXyLptDmhdHSJv0j
WLW4Ot76e+QTqlLWdCav0GzbwXS/aLPTBaoWSKWqILv7SxzsSVKSCaQcSAhG85U8Y4eBNWgBVcw2
zfjDLU712ta5hOdFf5+OL8w9Xc3axFhAHSwgrypBvL8f/7Ivnv57ZlTYFZ8cbRrOY0R8XPxum+rd
oQDSCD4eFzonhSRfRffA133o/XiAYv8MwqmEeDwR/ig3l0l5pBD8rW8rwrO5qVI82ZQYDm3pGj/3
/M7+TBm35ZN88AYlwphL8LT/bR8Ar7mu2ScMkeAStI3ucGpssjk5CkxCTmAmVq09+xq8ol/31uKM
1c2qqrHqdkGSgV5cAS80nEnRMSC8hxRU23XMncjVuAZXD7JMETAEuaKJtqUT1F8YLblh6JT+PzG6
0e4uNEWB6NN+3pYzGnn8BlnTy20IRduPAfPfB04pI/otlSrlaoNBWh+I3cpDN1hFaWmxyjBg1eJn
ReIBkhvWjQQLL7B2yeow17wJOI9nyzXOuloJ+AydOyjftasabW6pvLlXJbOxWzLNviy4dmaUXjFR
pNW6EJUW8I+zYL35aXjHmtOrDM1EZ+9WJYeP3MgGhZIgv+WxUPZiz7ULpjmSNot8pQ94HO0/JAlN
gp/1Mt7LDYP1w1b9iYzpU4C6nFCLewgPtfUIvM423XonZ8ZAip+U7n866zKmhoWDmBYnpmBT61D8
0puqGTTsuRbn6FK8QUD+j1PeCIETgHr5RN0P1dvuiOgIxqdcwY0D2gx5YVFHxUzsfRkcSGrBS8Es
03V7Oqgws71LsYj4VM4v4qVGH2xRTD9q/Zn+mf9FSImfukzdHs5dwMVhGvbP23NoJFSa0YeMzmxj
hwkAwVboSqLOZXB+1VbLVFKrUUnSd0RuAQMmjJbebH1lcRfx1M/Z415nT0H9JVVi0dnO/2bnwq4l
J9On8oNwoF1f/uYdbYi843RGFkOmY0i92bcbxB0j6Z+U4KMJMo06u+3vxOAWK+MxLrfOM4jX355b
LCu+6NbDqnZiHl33rb61o3Vn1TQe/V8xkZGWfCEc7vo8SRBdtsy/XxUznwzbBLR3V8yjMN3VydAC
3ULAJviF5lQGzHPFtVGXlB+U1Nzjs4Hq/dCmZrdQ5dtjGHEwEI33DrIX8B4iARI59v4VlP3jUxK7
e0BiwqUcuBAGwVbFkBPOf/Je2rjhc3h+BNHX+KQfVFns+M3BeamjoexN7tNf5QD5htZRt61Vy27s
N3mtd0HqbLuBVSlJaBn1KFbco5GP/JrYP8k/eCfQ4dWKn8+tlwx3rGSuEcjUpPvzDjMN7v/mGGyN
z+0OoNTjdau6NHdwyRoUoA0VSi94hPd14A6d94MW/BeOHM+fjiCccMhvJMXXCz9UWJmvLA8j30dg
ZTkIc1AFJbKCzgm/9YfE54E0qT7DWYSASQyaC5MOS1yzWNcbXyiuPouZHjcHPOWkpB3iAJhD1Zy1
+a7yuyxc8O5kqiDsneoUjQzRRGPnNCm7PSBHw4zuJCWg5r6CsxAdiuw4kG1QZ6t0JM2TsbmB+Z5U
d5h7aOYUlMpgFjH/ED26aiZpcdlRHAZ9Vb0vzBlgbQDAFkN8qZkuwvgNrfWKbiqwz8QiPBzzxfaA
irgMmXYnsTQgNuLKDoq7EMmTd9YVwO6QBJ0Evy5nTXSQpDmltoi9R1AKNw447Q48OjW8JmLbUsF6
Venrqcoeip7b8VTFUDZU00GhuG6djC8qX738pRAmaL6t3PMqpjn90dD4M5vLTiRluBQsel97LGoV
iIYdDQU9aBkxi+YHaQe4ZwN0a0S93c42fQAI4GVcx2AOf6bTzUb3W1+SqZLD3PCELbpyGGaKLNKo
SizCVjB3wMGruzrtZCTstXSBhM5JeM2ZUHNXAW8WkK+qF0s2z8yv8XuvwCuN5FWWsYpFNpyijVot
LbkU3HApnnVZlwBvIgqLBhrSf5g67aFB4aSNAcbjaMPNUBNuJnBX30xnSS6jRh1Emji1V/oXzZ1c
wIEb1fBSeMKHB+oNhDBSo12vhNLs+V8hRG78AUD/EmTipuc7iMJTEimPOqG6zvQNT294FDfmeAxN
tg02U/r1gFhAoDWCGbGTGAANzKFeKfIxqdC58KKwIfRKWRYRWElTL8T5g9Gy8LCxtAf21c+8WWEF
M+McevSA0N7nZBobHPxtVf/dbPLLcTuR9iltnlUY5mWEPNeUxgcVkuiYcCUglCrlkzj9lcGYnt3q
acnI/hAHKvVrBOKCInYuMGXBDmM6Sqj/ZvW/Zhv13wmnLJeabDuL6Mz+ric5JTHA5wn5Ig5MXags
MtqpByFyWFuY/IxRp237ZTpS5XEqnqEn0T8VOidkk1cjv3yJL8v7Z879vD4AvLBR4HFhAanoRqHL
T5P1mPGbFy3ZJhJEa6ZpUZqhEc6VydvHKoPW4QAPkccBgrkAhBbU/hgDK50KWzDOljznZzx2cpvq
XqACxpuYq+qbq6YyVZTyU5SWtGC/YP9kdvKIl04copSC5DYdpysBaoQQ3QI0wyaJhbwLa/ehsynB
3ZytY9Xnol3P/QF9VLQmSLRmMHHB1SegshdPzWLV5JHQicJET9ZT/VhSJryUHNa7WwQU60nw7hGk
7CQ7zd7GT06+L6G8wgNIRvfpEGd83ftfSycOs0fwTTgb5Kkx0AV2tKQPNQp8lKkXAZiqM77UytjP
XVfC4xi+8WSon0mZB4Nut9JMQAmZeFi2EvAmHjCi87bCY5f4pwsoEPqLwNU/CxckSGFQcGCe1WQu
+ZmWTfPrnf/ywsru2k2OdMA8++DZYGeL8pEuNd5iE873wT0u6MEL2n5dPDMzeQyFtiaNIJ8oc2NF
GXDFio/7CZ+x4GM6Ds5TTJAZEFMDimmssTpCqNtabWUsprzfsa/1DIUX3PXwfx+AFkCjqPEegAaQ
Oh+VAMJDL3n8dbjHfscfT1+R+F3484hgNJqCIPq5O5p0iD9TBpveuiCIGWSKdW/lgF9TRddoPMSo
is37Zfu4+Ds0vYPf3llDnbzX1Q2Nuon1eMa+voDXtQbJQVY8kFGs3KVaQBljQciKlHArEfXi2uan
cMKpUIXueIaT7wFrGuJObuYOICRaxMZbOYuhN3eqb5DGfo5dqxl6qUkVBt0erHL2v3PApUv8ncyk
V/0yW2kA5hS6DJvkWKk73yRyc8zpgZr7CivP67T/fT0tZsRwDtIokRSiqTeOkiuuXU1mTkExr7ND
10EM0aaZa+A2mMvHtwISJifrTCBx6rMq3vs3QKzGZHeHSaVFLZGJJbabXwJgt26HEV4MvHdP/QEb
m+TpOEMBstG3N3bDcbmiqKYIum7jzhSZWXAn9hq/H2KJd6BWk5iImT2H0AKp9ZuffMgb5Cr0C1VL
dLG/otRDTfOggD2tST0wgEF4vErZn8Y74UevqoOA5bwm+yXYEEL4XJLxQmpHUmNSIey6qbNw/cgs
y0H/BYu5WrYEaSKS7QYOyPOueC38NPgNcQIXq0IlFqi6zxF2s8ZCimJxljcsOnAIo1G26JRIDVIC
I2L+uOGjkKqMEiC23T312MF0w3bWXPBkOMddf/mkQ7Oh3i7N/7junBMZLHOTe81jpR6Zwb7hf/ab
0NkhkxLrY9JlxcaTdaweu1p47zaWlGELns6HLGB9CX7oQsk4LUIIVE8Fb9niS5EotTlPxxdk3CFo
67B4W+kKj9nOmOtPqd5izBrmJCR4X2RNMdH68euDvdQTQAk8IT55sVfqtv+8AzgER9BDHluxl9rs
rhwIQ/Px1hCb6HoNH+5287esodAo00uI0CCyNqUS72t7ocrFdf59T3K7vuDs/iG2km1qRZSnlaTl
NCVoe3DRFn0GaaSkQy0XIuE0LyTPNjUN7PRtm02qAtDkrQvGbhsk3Zrt1bjYlZGPNLTj8bIkQVXh
FV/GseO0kPka5k3qgB1YRdjf5ED4qPR3xYTQY3RkAHYaIeSnZJR+pruf4dvHFsTevSo1fmQY+q6s
ZPWMgXawVwq1U6nYA5sAoacDw+DJKHzGEbuc+hfJPONqHwuPnNMHEbOowmUb9Ks5hGwGlu6QUEAz
xtvn39zD0PLrX3WenduPjZv9G9CbsPsaSuHJonFmZ+FDYUpEATXai+naHqSNeQE9SB+GD7wp74mz
hbXF3C8Ww7BZi9+GC61YK9W7wDmLNg+hc11G/blrBHgCMQBtsCNWnSdoWM9ufe/BpaKSV8dlvw1l
JqX/dGoDvEq6cJhm4zeXzIPveBVy/fC7uv52N3geblNr34HGYCdwKob4RoySTzmcdBqA0XAJAZH3
z58LlVxG+BUynRP3DDRIRYdEjkSMPqq9GA7MMDaZlahN4BloOPKlM+6z3eoeKd9An9puwMiw5niz
vdQdO6+AVeuP55qdR5fQR8daYZ+0/hh0aWEYElkLHWq2WInWcZ2+qWe6p+KVFMEYJy68FPqnh8XI
DVsjus9DYg7ZhWitpOvgOhGqeIa7GAzXQikk9mBOtyf6Pd5nK13UpYynM8jHl8fYTehR+ZpYMgV5
JawroIR8S4is9EFY2LjwXjKgp6IynoK+emvieSqywTdVZT/Wlj2EjCdctHBRqhdCLB4URBUh7Jig
Mllgy75s9BCU2Ms6OI10C85NrWjlKjM6RCNudoAx+YLYCIjoOF6p8UnVe6TRtrS/2OMgr5niVgtQ
PAbo/BJxO9mFDy9j7n95BaB140fnMLj/jo42r+fAZm/mBjFKTE/b2FQ1kul2ndsK6H6vcbWXdngJ
fBSGJN479vJkm1PPBJ/RGHAH2xDEnNxIAyny7SzFKBVF+3jpBOZm9xQ0APCXlz6sNX6scaKtQVMe
lntafLzoOOARZKEdt5kASyTzmlXWLVb7P39ctf9NWTsSfOShyh0xcSXPa5rnN7n9JA6qVe5m69bQ
0ldKM1+AiEtqYkUxVBFXXuaJ21r/VRV/lCe0mdST9V7Jln8KZeNT4VJOtglit9HEP9Xmj9FSvd9t
ybmY1jsk2NCB5qdxBKAa516NDDDZ1Z9LADlHLQPIN3OH1A5eJ97hR3vDadJJ6UNobgAx3qCVbpzH
/Oj+zhA4XxHNGZ6lOxX1jwNbEx95P0wX+ovvH5ZxulidIIOk2NPRKGuLVFEct6129uz9hquaPTaL
WV+PZ/ghdbsrtDFuM/ro1+0HJ7Mz/9hFu18YmD2NW7J5hJxlqx4cfw2JxAtUAUafNXveUAIH0dJ+
bxE0PQgrjCXoxqkYDSinTTwC6MtsXVN9q+Zk0SRj2wzfcZM0jeqoBN+S/kaYb96jyAw2Cua8zzlw
QR1DiAPJSXC0A4PzpmHalLf8GCjVIBY2uNbhHZbts5c1JA/DDGfX3sX8oiNZVvQaFABWGdQYmUbR
oGLFSwcqpu+3e80z/5HM9R4rnhrg2O8vOBMEFR5ORuOnWX92Oz0xsFtJhnNDNV/CA6MymCPSWjM+
AkAo+i/W1GDGMpdXSf47h2O9qqFHFKlyKN90GLNtbWXaX05QyiCxCy58VoXyUf8jEq3v9lzaWz01
BYDwh/zLU+5f016sLY9Tb2ZGixL1YoXhCJLFCWCrzLyfeWyGweBVNX/A1A7bQT5k9Li5XVChkwEO
INrOT0xj3KDSi4nV7IjFLcgp0iOjxkbo6NFFtJYXfMZVUj+OeJy44zENWd7Zwh/f3FAa+0C1CiTY
93aYoAOS5nKEI6LJ7b9CtO+k6t04O6hiLeDzwGNQY12BCbfYfV9gb8o7ewzGPwFQ9d2U8ZPWi+Qu
oiryIfJe5TvQBf2MvOq0G2KRti+BqM6mCE+43egkqlqwkvJEWhA4S075Oa9wtzydDzTF4JHW1H3k
Dgp0QAlWMwZrkXa5htIH0kb4gc8IVF1wh/OgHOrSSshNnseJ/jTftMsASXavwhEB9lrhzj0zLi2x
GmLXWZYdScAUCyOwCJk2Y4672Seru4Tb2hmGS/ydrgTu6Pxt7nsoATfnKpCU7i9iAQttlAHG5hyc
vy+KJahNKLP0yf9o7I2UFmuXs2gOVAv04zic7XaaOe+eeIxt6/EyA0xEYiHfymCTCNOKncieDrT3
jUxotDURET4FyZasszzq1Hgej0thVo2gxy1xRANPw4Ir/lo0ndUweV1NkjG0jyzO15xO40e1CyNg
a/wZkci+rbyD/SqkbMceABIhoYB6wXl4qogavN76cScTnj79KTpZPKQ+sw4ynHOuphujTe+33QQW
kIVKkJv3d+yZpYllprF61kkJLqus+pi12X2lQJO2kUfY8CDAIU1tPF5lfC2tP0rm0eRp/ous1vjH
BsCZQGU0+DW3HkkOMNfLgC8bcQzN93bbp+tmdY4OARUIrwCkAw8J/Z8jJ132txoklzzTWVm7xuc5
Wm91WybecZ4OknkSJKWvd58ez4GX/8+ZovbGfvfUY7sE3NMkv0paSomtlPgH8Q3hY4IVRXBKqQIo
H03YbIwefvmjuJRbjSR92LdvEof4m6eHKyCbgwARWFiMriwlSR4/BvVrMIhv8YgtzYivkitlVMiC
VYb9SA4lEesWQWZ6PqbjI9gDypFR43V+78uTpmYJu3YNDiD3t7FCNz5VIajSuD7VOJ6in82h+qRD
04bPeBQuKdSw7lPazBq1Xf+G1ZPQTmQvz+2m7EnisYbySL3dTpzvMGDXXiLCCqIn2nYPXHOgndft
nxAWGI6WAsgHsgR69GVxojo9CQu5+PLOKJVIDx3T8aN8hJF+JTdPqmhvmlCtBBJ6OBdnXHHdTROK
1A/97XI2Yy6jNJFlyj78aucm7PuS4/4LthHiaHM1EpcCROrZvKBe24zh2Pj2Gp3Br31d72TmIbkh
bVe9o9Mr82XsuZTy/RixeQ8iYxp/IKP0tsbVuK103M6ca4Hm7cY3SFrGG6VhJX4NVwbyRMJuZ3UK
Ucl/WpuBr12O0alofLHyJbIIE+q0QZ2jhES5rPGfiqJnaUUB8CurXjV0m5DiQHnvn8GB4n9K/n3z
hpOXAIaMDFwU+owOa9YsTKKP9HfvRBnLU0fG7R8wk9bFJQI4d2vz/InDicQoV6Zz22uEknkQDF33
G5WHneGb3e2clVSWOkZB8y+ZRP2iyVAW00YGo7Lb4LDdAIYWrwjzdXEdlqt2uJsFoncES72yUS16
0z6G1TA7n6UhGt8Lv56q437J5SZ4iZi6xKDRJ09C6J+fhDaMbk7c5g+yXujS7Sa+4WP2DPJ3i22R
uTAIy+yf4fN1LKI/bUU+YbcljleUgjbMe+E1xmi0P7xJ/OSk3UIELOGu3f93Fc9dPqC83TurFCGR
aL8zYhWloSwgPsWCeYseq7tL7jgcnMwN0VktHZpe+y71rJ3gh1glA1c/WHwqyv2khm5uzQaUk6TW
nSSIVIxoCY33d1srKBVCkKH2YR3pMEFWkQAwUvRAUZ5/GUm2bMQBlIBwfNXyOXNclybcy/Co/CcV
7/H6F+gh6V2vsFtG+AMOcnACyIirCObb54YCrGeLP9ORgf1qip2A5h4Q0xL1ouoelcUaijc73Jl8
m94u7IE1RqMuF87oM3YBuufRWL9TPfik3ckN3GKz6ZdbKbcpCdZ/xEJuySv+uZrXqUWTAVu3ppwQ
W7OQkIvyHlB/cKYXonp+BIik8iq4xFFzAsEgesUsMpWZBZEMGE6X8mNPiPnzbCTGHXmtTFms0avj
aQKgiueD3CJu/cUi2HdovIjQi348A+zIRHpJrZYuSCae8ni6L9cNnr8yWkF455+76SCMCip7c7te
q2Ee/7Q7bClll2NHlp/D4oMtJkHO0cRVmVyaNFXlea88/AHxPpNN34czV40xTWdpq9Nv8cBR3TdM
PirkG7s+084Gbj4mRDBWMx36z/ssqU/exTJZ4I43Plaw2hhSr3qKfq8EHImCunkwvZDfDTON8mu+
m/m4dxlGevqEB8/8E4dLwAEd6XqaR0m/K30xYtPhJqwiCDhzfukyTou8rIq4VCmHPf2G8RJr8HV5
+I96KkczRj9r1Iq8088TtvLD9lXoDeAPPi0fn02DT9HGldGruNk0CjyzoJpA91Fy7CxSdr69pjJG
pVtHz+ebY73bOlnJAL2Jo2bsLQBXCPiwbOlhL3f3R/X2TVmOQxg8AjxGgBWKbjgI5Td7AVDGPTkP
FGB4NW24HYJVXlZduNn0XD1S8qequbVt78CNiONML1sxcWT6xoN4aeUvfv1EY+bPwXdLyhvV1IBZ
6TcgfA2lJ8EhgJHUtgYinZu6duqCLlUHfK+mCSJnyTKcrwUiXVMj6r9NBvurkb9nla32ki3W2/zj
ttxKDR5ZTkWaZe8rwe1AOCyOBBF5QWWV0aTCiRLK0fsRuXJkSIjufePvY+t0bPzF0h2C6WiSNZ49
8lKOZtChO6jCZSGqS5DZG1trg/ZTFgwiin9MAWgX9ISZKJ8zbNRyEB8o9KOSTCqFhdZoKOy2wijx
lPBSy6w5pK2Ni1T4FyXkG+zFogTAKbOXfmkiKjKQxwUKQwqtKexeAjAUzBUdDiSKKmWmZyz9IOVw
JLMLeF1cnPGOeusAWQCICTWdSqQ3kF4YS9F2SPuaNWF6+EP2TcDnilPK70ec2WQCAj2YIZ+GhEb9
LEeOn1ROGeXmlORpmhxIW+uXZ900Oqy9gD2n7XJMHMd2TlvB2GOfKdDw/iI8XE3PXfAFqwQ6Y+x2
CZzIHMOBUFnYXd4a7f2lj+mZAbIHRR2fmz6WYlbdob8tL1ywJF+qJRef8t1FCfhur9WWfbSoLAYi
5Mp8R9ihN0gG73osakLdHCpBrI51xSfcWuYQyh5YPb77qdhCxVPANNku+Bl8ykIF4CsRCosSuB74
MSMf1ocwgh443sSZ+uBuN3hGMS5t92UauwtvebFe03CMysdmgukt0uasuvP+9A/e2L+YcYQ7YogS
Leg3uBOw1JjouqTnrd2z4o6gS4nfoaaheliR4s0njYbIftzpsg1GkYz/CTRQCpvDkXn0RJap57td
A2MqEj6H9z3HqPBLFPnDp+cI4uzb6lGdPTZNUCx3/IjLDBq/vgQeeAwHB41OzGXoRYz4x3EUqAlp
kFp2surJoZMHrUhBG5wGhGWqKWO/ECBTPzY6DEeIUa0QHbL7+ZhKOs+M2W0MPq4I7EbPdElgu0kQ
3Je7KiPZGvdnalcvQifQhmM09vMdvXRK93eKA+zD2n8L8OjlYGLPifp2t3qnfr4jCSd4MtAHmWI1
l1w67Sajw67noovEiumg5Ldh0eWAY4jM7vh9alxIHVuZ+CrfaT7sW5z2pK+qTo9PtCUO0Up4Rqz6
0z5ubAvo4ARDZ0OWlmuOTjUCHpv/WpklUrE60yCwypkIAKSNd1DCiYQra/M/YIEojix0hTTppOJ1
txKBKwrHeCssLF27Xx8rryDcrllRBgfuQ6/2tj8rFGO8scHPAznQomyWdKYCtagibXDaUG618u0w
7sfL8Ns9UZ2rZA+Ih+05UsUWurL6TqQY3tJbLQ3hqK0pTstN/nR2dvXU+cr8pOp4L+XqqdV1jvvM
eSGw5s5+HQ4TkHEDoNpeYUrTo/1TJaCeNUuK1rzN+wBX1jKgASWutTVpjbH1DdVX4h/l4zA+gdAz
eoUS0OyU+dHZUfoRdb3CeietxvjMdegvdDPCjOY1hQRYfsLeombnf+ldoylpaXzeQgWzEGbzbq6j
5BFKXTmnE4iI1Le8Fddt0FWiUOpBkzMpUPFy3FP4GQ99pS8HqbtAfieTvxwipq629RUbos+zGAAq
d/rjLojUHyx+eu1nDfieiS5hyEyuZ941iKwLfIn09N+vyXrMGS3cvVTyMbROO7VkkkKoZV+0gGjK
RZt3+bHTAjz6AKb/lsq8hV7sG7LTibDZpp/uw6HD2aLUCPMsoHSRhWJizhgDpl6ZrhDkzjr2hggb
X7N1QnciaCuqG8orsS0KRxmhvdGkHA4Q3OQDLfBBk5CQGuhNK9rfeFSs08juNe0UdgzAeM6tOdi3
ETwJnzAVPH2dBdAnd5gsJyA0D6VrAjXbnX/zPIQOMJw+gZsJ2tJajuDIVtPLz3736+z+SXz5cgjf
hyfdy0brr8FMe2m/dqw22BgUcsr6NoRLWZX7kSS2H7OETQ1VmLvutyzT2HoqXxWyZFCmxbrRj2Vj
0eP4kZ2KAvDH4y+gTr/rM4Y00OD1X8t/eEUBi00/x1aRT3eFIYnHb8so3M7gKFNx+WyXFn5rf8eu
VefZQyP9ShLTslX9yBd1hFx9PHvXphMWuz4o/y/g3naaKFEgeuH0cmgcVu+oAbcvmU/BOfccGUXu
O23ls+RjvuouYKvAmTWvkAk28OWRC9yxyd8z7z3dQ+8N0OXakJdMz5KMQ2yAeW4S3NyOABakuuWn
iCwubpZ0gCnLuvYDTzDwO9TSR5sjHMmC5a2vsyWz/0AYuO2oyZnlBcHB7dQYPzaqT3B3gwQJDqs+
PYEIiTVlsGPfUIlmBiEzI3zJcwuTfrUVoArKRfpZLeYbaur4QrorVkcgtu9hQEtc1OqlSaz79mrq
Q9DM51y/CeMArXXlzpXqRekcNLx1+TI3ew5+lR5ZydbdI4QvPVGrMse39qk13XZpuwG5gQRqmoY4
8qcgfcCkRhv3gy9B/YNC+8lW+fkloAWWne8vAWMdSi8GTIb/ESxBGLtL2waMAEHXqIV1DuMPX/2G
F5aKm77eohegkzZioZybnbJzQrX4GsOenZf/+K559Wd2HNRbziVTYgprFvHxWJop/dCJG9wW/Urj
eNlwljcvPgPsREjIrkp09tyiG8fzMW0h5w1ZIBewzZc4Xut4CLrUkC14KgyrdIxvzXXgMxwRrXvK
EvX/1Xx94ndNWm1lKfW9j3dtzyIclhBKS/EsloV5Q3Z02+xN/iOys/G7FxcH37Vt5pjk9A30SDiF
aK7f4HIJTe8j/GAxPrlY5uefDiRUILKoBsz796l/7/K64KVPLBXuQw0qjAoAZ5TdwDaBW7IIitsu
4cScmoBUzVODodEUNEFkUBJxVQqWgFwdfZWEuJdamDSuAuDHztoNvptUiEjMbYKaX4yTzAFIwSb+
tU1RQeKGlj/fxwo7cyQsTpH7ilEUyM7py0ipBXVf16IaLALXwlkMvKjb82fKmL0MKoIDPxkB1tQr
SE3E4b3TFES83obVTNZoZu/OA/+Z0jailodpQ2aasiR/e34oeyVdj28jyVGEvEoVpN6IHFpcdLXf
r+jQoiefta2OH1XaIfcskFcG0FwHKbbOqKhJLdMfzm3yM95gbAYAGD+Jo6zm3lgAPT9guw8vGxWu
3qJ+LtaYabQcq1XllVnBqoMaEroGAuz1NIl8bN5GUH6UwzP0//7VCN1AtDsVZHoPBDt9lKG7oE3J
WgU6KG0SXWtIXnej+eVXl9ym1oDKM5yOIYJF7tyE5k0dcoR8+5Lc/taNyaQi6I393KUQdrBZvto4
RbnOza5d8BsgySqPfLiXtniUvT4Ww0DhkCMOzTdN61LwUgBlexbBzHbOwAQeBPE68rdXqOMgMk8R
y6MDf6EOaEkQ9FPTbBRTWtTl14r9Nc4ssgy/pQCerLXaLDNaONI4cpqAI7PzXpcEx5mZkFs2l/3t
EITFU4mqWZLwq+ybQH+Hkp5CUynhto6DDUgCrGx3fJ8hIcx+45LYdkvC8G4j8zJUKikRZvlDbMDP
GKFZAfoZEStVgVN1LCmL4+7OXT6wcEr+m/bgQ18Tyf+KzLQLu92NzB4qqqML1pAzv9SvXP/6JbtF
yoWyVQiksl97iN7BZQgbHLQisRDbutZN+PHyfgIn9xQgglSPAGXRrsiF4rzHcpglEuBXW56nH6cp
tAd6owmZW21HJa3CuabknUgVpVWqWznhwJPUgLv0rHAr5VCBrX62L49+3DodsodpVj8rJsujMU/r
7C9V0lAnZggcQTog0COyxJJnSoJPtMrGrKwwYQGEneztOCNBX4PtEqvHBaw15IvSXxHgYYhDsxT7
K5nUaNz8RiJBH8U0js8EfwqwyAb3Mf3DiYkXbumxjjcuynE8RHtF3An8Aznxys4sVThFdMY0Oioe
W78PEbmuWpzloUFlz3rgscsn+TgolKKNLzy4zCI9K0eU2IkuzE6iXXmsL8aE+opjaIrk1RzP9D/Q
rNjdi0UaYHagYNB0JaSaCP+wUsFrw1FmWM/AMJi5AFzReXo5e0XyO46t50nteRruODfZUBjVGFcD
zJzsUXfze8gTvkMpb3GJCv9OrPzsVBbk5zENm2EX6MQaynHJLV7IAqLTxawSW0xW0+7ZJMzD4shW
cu2nuRImO1sP3BRvaHuPJgsr7jBB86aihRjkwkZ5VxPMyxsH5BPCfGVyj1ufK3bOxWIsDvES5rfU
g1EZuX4v6eqw3Mx9tETHb9GyQfR8gULFq4RKR6nja4euvdQRuI5YVQhjE2ap3Lx2BYwVKYEo2IhO
eNEcD9bAdqYf9/BNfmCfKMqpCNN7zrHa1cmqlM2wHd0Mox6QAdltfM687X6m4QIC0x1ha3PC
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
