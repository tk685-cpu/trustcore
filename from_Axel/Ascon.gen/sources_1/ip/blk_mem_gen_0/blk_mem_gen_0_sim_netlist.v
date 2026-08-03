// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Wed Mar 11 14:48:02 2026
// Host        : GCP-E101-12 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/eleves/Desktop/Ascon/Ascon.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
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
  blk_mem_gen_0_blk_mem_gen_v8_4_9 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 29792)
`pragma protect data_block
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
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
