// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Mar 12 14:36:24 2026
// Host        : GCP-E103-08 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_1_sim_netlist.v
// Design      : blk_mem_gen_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_1,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
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
lAVF2xgIkEbQ/FP4uIyWeC4SyTyn2LqkdxLgDY99QhXxpO6srqVVV1aA04IOB1Ag4OB5Wcc0tIJw
FMIkEdGQJswilyiHPHJgB8XDm+LF+BpS2XIe3CWB05PwOpCK80RhJ3I+rDyR4rHg+EWA5NBxjQAD
2RhztB+IjZ/xjnivpojIzd6xz1lnAa1u00XsD3vTRqhY39vXYjWNevoHh7l7Qed3DpQcZavrfn/s
g60Q1It+2A0ReaE0JaK6gQKRENqIq7X+HViVvHUq3aMb5N+je814wfQ+s4VpXMvXT4k9xtHoAGzY
nKwHgpWSPFde/xHRnoSFNCoDLmbaXl4aonH3XwfV5LgUKVI9Vm5KZsPYBVDD22qj0BV4aWZ4yhkF
Hqa9YpVcu28ZLCmm5W9EedXVXCXmi88yrcDkbN6QyV0gzGSJ1jPwk3Flqiznu2xNfWcdc43q315c
UI68nc2aqaHA3v1ngyVFnal1eDiykmTMJjayX28LhFK3KmwccgJYaBq2CdbHBH5tdGsqp+/ir5nt
4jKKKcJPndm1iK17iE8cJ0hJxy0L0ev17qBW+fQPucWJaS10FR1P3sVz2u0t5IwVXFw30CVDwH4m
iKnJNT6Mh1ILGXR7TG+6I8mIi4GzMglOv6Bo9CvLkCQqexrkWq1T5PwAc7P1EfCNG+OSpWXHFJIH
Ii7olekmBr0BjJjjwgcczw9O2y0tCWujmsiSJ9J+To4/FWXLrMWLMZxn7xC+99KCP/EqhRKqKoBJ
FZ6F/6Lx/QjSpMeCoHGehCPDRNT5gUNdJv/wcQfahEo6SuUI5bs00x6ncfDyTTfczXIBpXiTYcL7
BnhZ6Ba7plN92UU07chyoQFQqTs88sCfiwVAmE7Q7GSQf9AcX8GEcmoTipULQjz9exMlOnIBHuW0
s6OLp0PqfojJcPfANtMRFCAlkYUIaQsfZBv7o7xwBqtM1AOQ/QzD+qMtYwJUK4SiWoEbNiwnn3Qa
c1J3OxCZZXJmzfkTC7c/Qschb9odYbwGbCOKkM1GIJIUAtoJZupm+riT/KkzkA38/A2O5nYdykH5
hvBVRQv1y5ycNu8WFNgBjNMknBBEUY8+SzldxMQ/3UIwY/vxBgFisdNiUn1sp43Io1oN8kVB50b8
vKSyoH9j9wEulf2QNrn2vqDIBNBFXu92eDB+5+TjtLOUTPUFOSmLL8MmlgbV3O7TOwm431qz/SxQ
opANEYPPTrHnrS5lmBTvMtRWvZN/Ni9cu2eCj9d+wuoUby+6uvYeNEmEUW3qcqBj8HDwNT4zYPIt
/K6Fwcf5fK54M98tqBDkNtH+vzxi1ectbZ7WwT85ZgiVviM0Z8ZDkLVWTP0ZOnQ4or2gjJ9v7hVX
5XqDva0zmY3ANobJd5JcsmVHAJfBWkv5skE60S4a+cBrkFVObnG/ZyaRHrzWE6l7QxTugoPG2N/p
iHL11Azl09x5lJMLKJ9taV8hX8HeLL+3mPeSlb+nBhOFITsx3RrCxatElgG0RwC5jE+mRksoviQ7
lo1oN7TAcfX42syLG/ba/HBFAikypRXhkLI5Jf0rxMERjtIjVNJSuSsJRIGeX1e33w2q0mMgm+1z
HubbGrCMDWBnJLzdVVkT0YerY99uawEiHkn7v7Wos0lbGo6vFnWUdM/DvHIfGetMN4Gl8H0Od2fi
VTY2KdCxAh3KBOA2e4ux/tpCjp9Kz+64cois+jprjqEte8L8xjCz2LcYL5MK9ZkPyiTMHGyWSKk8
5W2upPL+Gy+WrT2zicYoO7WkimddFiTbAq0IMm58sERI4dQRo2F1ogYUjxjUWCFWqQYy7oS3P1rO
/QNIkT6o7ioquZ0W+BvSpG5sfNq/y7GekN6fS/WXOE7/ghbbXgP4xRpZ3vZJJkuWwJaqGYARlTAh
0LYdRNm+sHr3pjgXb5j5ZorruJIZL6MbuTZ96k5GSwZKzKJJJJqst948RFAZzDg4n0JNEdS1WDJN
iU+PcKPXZbAUf6EOuiQlrl2CbykiC8R/DiQhn96QcgZkCPf7FYNNd0MGSTx+juEBocgvJW+swo+o
lszFBkU1aEu+WrJS+WutRNtAF8ECNTkqumQn/YFXeHO6hxavC3hqPPBF96DZk+6eYdL505xxL4g+
LOCX3klguI1FueBFoSMjXTldXQ9zOE8lOy2Wlz+DcXMO7AXhguBC4FiUwGxEPYfOEF1nPJt4oURP
vtIOLAF1S7N3jyFIYJJhSqtVNhHfzs1teMLtakFQzjcQ+8xu1yVAuAuQVDaCSwuIaWenIQBrRldA
lJnmnDwxe7kiYcoNAJyhC+lDu0HgxN6VOChX0luOaIapC3iYsjg6I0bYfja0T8PLG/AK+edb9RpA
Eq5hEVym03acdKS9V1ibLFAHIYC7ElMCxhGwkjH82DqQhDDMlXhAJq1qnT/U9jaLibmpvST9aBgz
XhwrO5gleh0tAk9KMFepQaJRyijPfnXq2O8TvlKMhVNheodlEI3c2ZqiVXfkSq1Q5ybyuVjoYenJ
r5IH0rDqcKAyqU+H8vyy3maBZDjT52D1SwdQ0jXBAmy2vZImf0AKWxsEGaNo+TggGwf/Le2mlchY
f3DsNpkFq0tpgaUB1RamYkbRi1kK2jfa69SCDhbfI1pARpUNG/2RjcionbDToqoC2KqjMgXhdMlV
bxIklXkFzKSs6vS4Zh0B04n2p/AeHE3AMrLqBBpKxY5ce0uTc3UiaFgF6yRhXZW5RYbgZjRtkspB
bzLKj94dgFLUiQlTx8lrTBFHnYz6dkCLckjZz1Vz1+Ul8z/fXBO3XNwJ6r1jKre2f2RLIQqoPR6v
D90WCRsXPrN3MM5mIHv4f6LvBs4DmQE9WqM7mrm+wZ8eGPXK+POOfI5fqM8DRiOUgd0IGTtpgu5T
BX3QAzZFQRh0i0rPUODgb4Ra7nfiKbHRyVCwHfsPdatb3OLHOYt1mbezL0OkPHWSvGAKWM94HgIp
1AP+IFwpiSHrrt5W823a+qO5V/13jgi5H+/2Fx4Jzq4e0lLOg5C6oX5m63oX/KUolIsJ6cTjxnOn
DllmZ3k69DK5i1UWQ+LODSka6tN+c0m63zJkhUB6aXpHgUvtdvVHERCr2U5DI2qOwvrnnnQNmhCv
5FaUwbgsa5UaXt5lRxZERDGZwlz2nbn/rfm/Lj9l3dh2CVcpMHhTK9vG6zhrvZxCMkiJ1ECUCQwn
RDp9Kdf4POqSYZbz1XW+xAM58Z9MH27F6sAwIQ92JU3iQbIN/0bywxbbdNdoWjMWYWo/KDwtDuWJ
evh6rdUzPEdFNOFoexYcpDRPv8UiNikbup/teZxDzBjuZItJHo2jqTgw43Ibe4i2ob/UbmgfDuTd
n4GMeGJCe5O6Y4vyA3RLI/xHrKbWTj8h7R7o1c/RAUq4dxN8QjzUmFCsO4GYZCrlo8iTS/etLsGO
8ygt3wwbBx55ZsTJf8C7P4cQ05sE7tr/4ynga3fSQzx3N+u1FuC7CIpDjlqtB/yuxxZRldCcPd2f
aEN1mIvbLNJV7E+6YLiY4FOE9n2hMcovSl3r4voQww3nRtOdutFw+9m302ZUebcSi9+5IqpOLQxT
caYN0G75BCsu+iQe98rEGufVzp9MszMpsivU6PoZA4dgOZye7eZgO/ZPkX0Bbo1He+Ul2+8fJskt
60D9iLXHS2YiXTdxDKMewIOVrgeHldfRceuKhbfxW4UHijaJc3Dm2a853keqQqQoPIIX4wAEozyf
vBmIyiTrfI54H1MirZ7q0BivtZ2M3wahfCsAkEeXXvEMcKtCpvasbafmu6j0JUyEOQ48frXYxeme
377Lk8Q/s7UUqbz1IRVD1ow9fUkquwQm1CEO6TxIhlbCVPj4W/1r+Hl5v+1yQT+9m0sRAMnO2KKC
Q/VakcHY1evQcP43Ohk8pvd8RStNibfDuPDFOV1yXPYpfsYpYT5zKaaLPb8DaiGR8H3ZH7eMwNO/
DsEc8s7AH/4c+VdoylyzSbE+32tKfCb2DwNyEItbRClJjc40JLkDONSGVg61jtqVWey820TlVgbc
bbmCaPAEb13TKe1GAI3iPkUY5ty8VykJO5h3AkeBXVXk4VS96SBzkKo+9/41lVmlCvhgxL/DC816
niT1A59ked4ldqiKpCKC+kkC4J/vFCbYzoTl8MvKhr6XCPYUtzipiHY4ia+PSm1MJxNNFrXAHdmO
cCQ44pNeC5nlR4JYxHu6oqmzS6on2lGdOKtTk1JQgSMrXSflnGO3vrGgfsh+kRlQBKpVTmiOAmlH
evTzDKehHz5+lUkC9C3sztSsCeNv0EBF7z9bOzVFlZkrJXSS0LHGRD9PskkN+DQh+X/LbV3Q1cIM
6xCHNk72b521Qm5/DlvNGCyOC2truxtwbyAddKtMT4sLUpKGMtFmQS/mV687wH+cxLFJtbXXxPGA
p3almf3rMkWG3HOEQBl2y8hNswYSAGwegw3x+flIge9rksFxHoQj1/SRiTbKYZkAD78URQaR8LXb
I1RVCGx5P9hR2YHjn4r+YoKu5YaC1j5b3BbQLOpYTtf6A0yh3vpkROhIvBITH8VX3IcrSJ/0N7/l
Lamkz5aPoLIkR4UxbwmVNUq8nSKRFCGgNEod7udSiHroi+nOniaEeOT77qh2mVNe2SwMXNMQGAVL
KF5slFCHAFygFeE7m0FMrnl2cPd8q3QCwDRH+UuDdhN6FZMpQ60LCUXgHRazIHxlIU1J6eewdIew
eF2YNNl6AiR0ChRe7C60RGZ3WgOVkhwnFyAYBkjhwvQzq9pWqt9x1rUn+93y9EVntbDQOniBdDL6
Doc2bKF6F0W4xdGHxVY+CouWQfo2WOZKcz3TCDjxzjf4Bxn43BrphPN4cKUDt8lBWz+ndGqiUO/k
7Q01znbVyYeLwqts2bPA2dSfajN8IkrTTct22Ee3mK7GVHzzp0C40Rp+k6JYD2qyj7Yb6cv8CtdW
+rXCkxbcyJbb192Yju89cD0BSXa8GUOmgv2ZMOLDn0JGl/Rvftp/r7ACXsR8C2x9o90BOUXPnth2
JQ58t+r22Lmr6ZGrxV/mcs3cJ3/4pJML7X8ZXAsv8A6NBk2G+bJ5ELTByQwsW7gIr3v0fJLWLpDM
YkMHWzVCyAk2sTfi9WGF1/t9JDl0l+3QQNvROWi/ZUYflNLw58mF54qhhbM22oGhfO7JfoKca5lb
xK0EhxyeqfAjWgzKS00QhHiud4+QvlARzpwbQGwL88hBKy8lwJYtFq84GwWQuKj7XhLgYgrYDT26
43q3YlcF1EbE9X6kqAd4DhGyW/6OZdodz6k/ybFocDmvYWN0/uWAWoAeyildgJeXZa+xqQRrVfoD
ulJa+oCYrHDm/LKxucb9BYoUlvfAiMKvxWM8/W3ECow8vwewrB8hgVTVKSEoJEUBkzbTbA+79+D3
c+07Rp5MbU7TW81ba04ytoQ91T6yUCpLwNL9gOfV17XwUJzCpeazuA6tqkv9ywcPljHYZEis5xQm
DShf/c6jgAwznfC8V5aOrC1klMvgT3wmp/cuRo20sKolIqPTOshlBK2AqTNa84kC302lriicj2ux
bk+nbK8/FJAW+B95BNW4MB50GkZSoTT+EYjVOqdFuDGCtb1qZ/Nuz9SSpIjW5hbjg0bjw28Q1yxS
iP+zRz6uZtietBY5/gqHOseOvQ6ZYSLE/D9EIYkHXwaNFueH1cVoRqDnMzIP4zS1B90WTG6Zga8z
9bFx8yFL2XOBUNbEUzwcEIDo4mINOHXr1S4gxDCEZbaRUCqU+VM1SZVO3la0uIWDetg8fcrNN+Te
hOE8Uy3S1OubTCjKJzpgiVj9UkKpcM9R1NFfxVtDKRWx5SI9eVMoS+bXfqN1dGRw3iaZ1y2NarZH
enqAi/3GsELDea+PyB+i7Qm0Emhu2R4wLVOa0xQ0Gmz54UGbrTEfkcuodCN+XEpRg1Wb9ToGgXmU
HkVjiFGU/SwvDGNN7+tKRiyASV7n0WzZPvTwH9uHZhxLzDd0tTfxMxVT8b+5hBtC39cXWP1Xkaas
Ni0EsAIMRHqTVkj/CguyO7CrGCus1UiF1a/SP5T2kSCHxiCjGaF5DyHKGNptJFbO35JqLu6hpnEp
UbB4XI5IERpc85nyAzNiam3Tn/LLNvaIAr9u1j7bksFyRJgyXZrv9gzsFCG0FgiwExDomOQgjoal
yqga4XBjyoDYoNd5YMmyA/OOdJOoAnW7cZPwRi2I3p+0P7QGYfZtQte8xW25dHcrcfy7XReFW+Ar
KBIPsz3s7yjdpwHIJAFnhioW+327xHR8G7oqyWJ2iKjVZ792TREHcVo9v41ALQ5TjDt07MXKkslt
psGoyinV18kq2b2EvRChTruxi8UPb82RuO4W82/qzrp4lXgAamTejj67nhuRoUpFLGZscImR0MSe
U/ssvQhfwaK2u4oPdgVMN6kGmeT86jKccfAeypgCBTQFZSlRyhZX5IEtfTZqZneVEZG/og2p4gY7
/bYo4sh+kWSTB5+83HZwlASsTYGIVQyWVqD+QSleP+Sf9inDXLAsWg8GjdzZ4yneosDNzI4PtIr0
08bK51FhJ8FAH7fbwVxUEL+eDytvbHSeWQE1DiFLL+mhz+gfM9Vzw8RgXWfXoO4EP3jODQGBFdDE
6ujNHBRRqc/X1NV64UEZTBL5+kFDkZmOHbxQfPZ0pHGy+MAiI1M/8MNpddmf6JHZPcUPPmhYvKV/
E9kSTOqGYchGs1gkH6xpNZ0pxP3bUMM92xi5Ow4tgEX2YafC2Ry9vyNQHB0eDYHmi2jB+hteXmz7
dWR5nynQ+PFHhisRPpS4+e8Cw48Di3brqh1nMBmSzYvaa+UCIIZ4ujFfgjT9iDgbonYxOATcI4a8
b3rX3kdtHNCmwBxb8i7DHPmrp14QauI+KosIGrkEKpKDD1WJ8gQZ7Ihb/JYM+reUci1hN1ThpYHJ
CpHmJ6ExT0FgcfqR8x9CpUNuIbjQjlA5iA59Ezm3DrFM1zKAypMP5ucWpvSrORKQHAKQazeM2SGq
dBIfStl/wSq8kA7XFHuFLfcUPTmccwzVOYy5d26o38Ef3j8sDbrWD8wLcgsScnNB4NsALmv2z/gs
+ObYJLM7HeA8oGo5W76aruudTQj/IcWXCigcRRhehCZH1uddGl3qFbqGf41yV4Ffz0h8NBfJXN+T
6ylmRq+5fqbrQweLhNkxhXZGALoCuAGOLn+CIzOLF4a0GHmzng72HaWl/O6FSbvs5Z+bp0+RCX1C
O38AZBC1JhD2NqNrtBRrHc18bgRSsJckXWKBtorJJEI1oCzg99PPzcUdEPvG/4M9frLK64GAwCTq
oS4ORyiSg5mQXyvhJbOYz953Gibn7YtL7tDvMElxeQSDJkRhwahfMrkGaBcy8/VKu3nsOkUsntFB
+QS5KSGt+BML/PuuaEkdIrALKjOfwgHOIRyxue2tkjdwgQ0ANqT/Hb9Mda9uHJWqk0Zeti3oXp7t
qgNwFTCyJ0otTgzK9qlYNcLjtWcnTY1kDqxiQ1xCKkGm6y4OCSl73ZdUaTGJO1V2AKGYS+e4jMyk
aSSaInMY1cuJVx9stvCreAE7BqIJQjfeQxtWeLCv+m36KpgxHaI2hYoIhsZCVFktk3M3UvhoxtnM
IbwyX+ZvXYGjk8pBpcfEmYfwo2I1PHE9JCy40SifHytvdPBMgl4WsB+2lmFAeyRKHYfKV8eT8Be2
57aodsbNZAs6wn41r8o0ta3/d4nU1fUsw5xHKV18DDTci1LktR3s/9qU39qvboUG8OiYWJKZlens
Bsbft18pM5EjDdqd5Sv1vv6sd/TGDfN6Qkj/u24gzPS4aPmvfNb8sqMQGTKc4hbvsppWxhEiDYH+
IXVlPs8szL5Wza97WS1WCe/E9QMmlWYMIcJan0w4WeYBTUWpGPckozyyKmuQNujpP5gxjw2foJyB
/WmDF1AEgYIgXD5GqGMrhYn5XAs5CP6f3C/ua60rzkpVYwBqkFK7MGOSKJozOQrizVADhJo3mEaF
p2Y9L6g4AXEw6dK+xfIpk36d5Uq4V1Z4jQ3yPqoVthqDqYNyd+nJ1GVtVQDdZU6OA9GX4mAtQ2df
6Be0044oFLTBkGVrKEdpNM4uCmPGtNcP3PEXLBhTD+0P/eRbuMmpBqOvROHYU4Sb0Sfg4rqo+ESL
+TqcgRG/WDpiinLimLWjvnlG8RNR9Hf2lT+W/Ucnm47vC/jZQbkhjcZQqUXTY2KJy6V8mJ41yxad
ppAGyHRgDXz+2RCMabRowpUI+vxYKxJz4C53IBVhSpI8VFrx2qYFt1G5lLUMfBEmnS9K2MfLRxM6
R02iewPnq2Cze3ru73mhiPxvXZI2qi0FMmw3Ii5cNgQ/stQMl9vk6Bt1/MCGVGLc4tQQHDXxclvN
PmXPjDTHk9wVNvlPUVBnkkBUISLeEfnPgJ0p5iHvTzJYmE6CDuyV9UVlwNy7Lm6MaJOo+0qFJYXk
bv3RX1/sPvDigtkR3PMMKGB8AnlwTjTVUuCDoCQ//ob/9sPeYP/7l9zd7IJtIwCl3g016YOHPAxC
LOQkXHJP9iHiZ4hpU7XD9fFgWdEnCSMPKD1TiulGBItgwv42dt+PmI9kIUbrXaJ8CplRkePg7NyN
IO8EgoKKSZCD7+b5AJncztyROCjt+PKr3OX+XUmiU11MT8It4cQv6yzcmTlDw1LlsM0dTsdVlk2P
U0wkv7/hR1YTKqoXwPETUE9OyBhHd0k+k5APOR8aqs/MQwASzpCR+ARA7sB8W8BEELpaq2vXcuci
E9UenH0qkbDUvMQHLMBIlB15TqKK8Zb4UgIXN2m3Xgk3ba79rBtJah1t3EcpdyO+AKeGdQ3UUkIq
sa9OttP/8dYt1F7Lthn/K4lAVk0N6/vdH7MAMYqbw9K7FE4Kw11x0qnyPDjtJt6fjxnHUcrzBx7O
kY024dhKo5ZKOKpcuMggifKkbPD49u29yB9QAkyoAS0kOvMkO8FyJC+vQwxfTeG/GODO2lqiHVD6
mpQ6a4dDTpfGmTtcgCsBIEHGoUXDVDg90VA2c8nkfvkzUIOg8X0j/mEK7TIz2DFpav/O/QWW4Q+t
39E8HThnpItOQiyOMihnYio2jezPHkNGPuKtHkNX0NstAeH6L4M0kP3D3L7LzoLM8gn1AzJ94Kxw
EHNj1Fond0npC6+WvlpNBiGaRZnOBXnY41f6W57aQ6UrujcyGxFZyri6KZInAiQCiOni6TCZd/iM
hVnpJ8L6zkVYhEan5r0GuCVk73Tdo/L2QUIB7olybHUjMm159/4Rn4XOJs/QF1RoBrLvpd6KehO1
I8B+RmCTv591WQ6sTp5VLndZ1SE+lpcmyM9+1Lkdod0I1rPJvbJ0p+Kg7OyvRRdslRMA3VWe4e5z
U7qfQ+ad/5TtZZ15pN1xikUZfWQpzHBl0bmjn9hKwbyHUli2AKL5UyJcanJv9ZDcnJpQ9Cbgh4DU
Rixr8DJwefpLSwLqgkwud2D8r5RkbWv7eZPj2oKcmvGfMKcyalgGjZDqSgyPcBCo1bsMDkqy2agO
lh0n18KaPxcrN4s6F1fp9mhwQel7ENHFVtM8XRZarvtqXl4waarW0Y7FcX6W2frsQMXg5olSmigk
VK/5eNcwpMaaVFMQWxWmeweehQLZ37zpYufJBrL2gkaqWylBHs5VoxCfNQKLLdnLVFWvnFxtz4G5
qw+406KnUi7lygLCwIKNDkLCTtJp1Cm5RFLbsR6Fu+ChS1naVl23Ri/7gEhfBufv+Vdhgomf661K
rDYOK2ioWb3dk9k50zsaheL7mRg2466AIwnTNH4q0O02A4zl3lL4SM0hs0QWnhFRBWBhDBCj0qo1
lpLOMcKDimYJomUXpK8Ad0yVFenf/Oxo7wVa0yAu96QgRvC/uny/N95g/ecE8yVZQEhCEOBebvfd
/tXyBzoE6cY6fFVxokNArj2oF+ripTsyQlaATBwi9MAMo1yw9s79HV4do5/oH4xbOmHcSv9N0RDi
K46s7/4BdiYo/5aerzmslwWC/R4FK9U6tgYdhB2ky46A89GtttWagXL8HMKoa+z/FLK052/07UWT
R6H8JxXt+Z+gNeKGecJrqpytqu7Dzjd8p8xW8WrRYIjybDK23T1t9t4IYscWFEITN/ndLoQQQVKg
cOt30wGIh+eosXJY2xDoQUgCvLMSMqnJlvRpOePC5gb1twFTeX0ubSpOcVziQZ+LtOjZFlPaAliJ
B2fgol8DqOjoY8sLks7kADb57ZQ22qkiR+EkX6mb4OXVR+/fMDvmqEeU4XDOj1GKTzQNuITgfZ/Y
6oSLMZ0He0zsaghXcLizJ3QC6BZakI5yKTgXWroxUwRlLqcSHuXjc+0Fhsj2RMaBtwLO7EqXlHp0
gEF+qROtDu1X0+S95+NnlLkAfJ/bT8raArbP3u5GfblkpV5AtT4JN8dj9Msn/kxAWicBebRWqRUc
UNs9HVaEHQi9DmLsI+XaCrOJ0PdL1b183A8mJgYK+uE3iEkerxEnKsmypyKbMKrPqC5S8UszkOXv
lx/1ZU7GYzSZcR2Jpxmg1pBPovCB7ae9d2WXOPpk1jrvL9SHyitRYDdkOCJnYcMCABUtCwtNQRqY
/nNrnjSqqW9BxxN2/QpyK5FJrbR5EnCN11JieczYbAIsxEMleQGFzJ+7KvzSbjLczXsrIlUM97nV
jwvxgMVKms++sBdcxojbkYwSGBSttSzWEHHwhPF1V/ITmC6KWmSKcDglZREZ218J1FJqQ1H2a2rH
TAhiUI7xbuUPpG0I6vETmcMmsWcILz9mYvp93Mg9max8VX5oRGrorTeCz2qCXP+qoJMcKh0xu71w
CN04ZealJVjWUu7g4gouKqjZ+p1cVcMaMaSqJtah6OpEtuyQM9voQC8vK3Mkhi0sytw36oHwu2XV
mRO8KvD145agB4JXXOGHGCvOxpORW0aJieurKaSxSdP0Y7WelMJDQvX0mvOFcPWkpo5P1QNMezVv
BXFCkRRrjpRXigMDH2C0H4KFzCPzIk/mdX2GyN/214GAGxKj/+G4m+A5IM9SnEQhifuxkJ0iMBBJ
+qy7/loUbAb+zV++UMZwcsF+QZxaqSHrUp806yLcBpKEhALL64fn4PTFY23EnaAViu+WagiJiNEY
yQVN8NookqzuB43OnlE4wFSS0PiLG4QAa68A+pmSkVI0Gt5g/hNSduZxlsyPSIXTwVzl3fTgV3mc
+txazKcmyuSVNod1bEriA4olmFVqi9s2I/H7Stoud87FuwtoLAS9u7/AKusUWa/UQZxdbYEty9Ox
i6OsEemYysLDA/oK2Ok2Pi+0vf8amBw7Vjl+T6MaZ5DWL1o4AGITzWt7kF7xPghJVG8M0wVZn079
NwadkhwY0kup3d5BzwgocutZZqNvZ37zmILMax6UThxT20Sjebbkwv1zUXI/SC1VxAWjWIEpNhWu
+JWOHvcW4XCd6sLTEnFa29UfKLIjdajPcAbYXHmW01t1MYtpw40dTWRopupIEVBacuWyAyVrmP7A
YJN+3Hh/qXvkGDJZ2e04VGXreyQV03TY/nKuuMy6U0Ulz11V7sIp5FDZ6e+datoO/kl24uaXm/Pq
XEPYlnHzgUNvhTEo+/ac7TqgPc8/ZRlKxGIuLEkwPZvxKotsY5FMtEcWdKS5rlkyAWBKwYtkP1Tw
LZB5fFJSsQd+OqCrDCRbzbWSTObEfKByEQKk80SOnoUyAH3JUiSWebwLNOhGEtbX/gQAtPjZXnjZ
YdbsoGuJ/72cC9jDhLl7/cQv9OjdcEMHLkBDo74Dcyhua5V1zMdDYO2XAoKcpQEZFzct2lTeeyBp
O6UYobBpjISub6TS3aZ0MRqsdxMDHUDWY1w77mPSSaoscOVpfOWytXHhuOpQVGvYMK58UU+78uwN
qz5mUTlGYXrJLhVoo8rUbuxQXFiC+u31MSWt2Am0uPrN5lI4YdxGdZtFsEx3n8nWbSDYZV/vYLc5
rq1mij3tZJ7nBn9/gxPC+IkgVVkJeFc0lHxi6kQTMer/Gf1Y3SBsZL7Gg2buXa8hfRZxkO6CRNBf
1yavxnzG2qp1tWBI8fbxeNmzebQla7jPWTrOHEAsyNKE8UfXwIDwdO4q8krRCh9gTLrKP2a3TEOm
ul+FRuhxNCoesvqG5OPDzPAXd6n8eEbCDmm7n9L8jfb/vbMSUUUui0Qw+7hoMzG9kSleZ04ooiwW
tG5I2CPmIzyEZgx+gwixSK0IG5vQIC+q2fYMJsOICUqo8MH4piDsYmzI/WbbOaYADmTX7/kvecqC
iu0GT4BrrogqsWAISWp4NIifPWcfDCq/Nb5h05ocaA5lTloqLvj+Ek6HIbdUjM5XFk3TlK02Ajgh
tunvObDt30RX1SFtpnM3cqftsNdux+K0VfcCtcfigiE+BmbybY95rm+DATw57UtODQl//qrtd8a3
I6ZPByhzhOjJhhd2gEeH15iXkjokOigkOFrQPs1YVqpGtfqKQXgmxrPqq4mHg3tRnx1+KZvtHJZ/
B6XohATWxwbrx/TtP/BKDeil8KAnotk3OVvC9/hQO4OJ/cQcHVm5qpKIbuF6yJ/TLz0goeOiJxyR
BBoIEdDTsNlT35dm5UdMVI3nyjlp7OATgTEDy6gWFiuSD1vjKJkMUNNb6aCjjaZsH55okadI+9MB
6kXZbPt0FTIb8Ii+Wfp+PZ5mI75rqvsT6X1UY8rTPO/C0f8GBIbxWwcfAaDrHwe08J7seER+qdWL
Y+07DBkSsC29GB3sySKHNKs0/QNMCW09MQIoVXxh6Ul5+Qk/YGVFP37MV5F1ynvIuiqtD7cqg+kX
m3fdnpNbIysuSd3nGvw0Cjf4hTR5YriQXJ+oANW2XslIGgRx6exRFNmAw5W8IYhNQZDNfcGh/huY
+rSsker4dXCozlNqC51Zdz7+gZb2frzj2azImz6/GHjv463wJF38EO1swIbS5CuD1jxjUY0IJxZ1
4jl0LbvxRBpm+6KYUAgHCS9hiPbBnu58N/yxxQKKTsjvbK04KI4sqN3RkvEatHwscG0SKbS9Qoou
NGsE/6td4XUTs7RPwiSIN/aJxtFYYb+mzCg4fn+FyOIeneQMYU94kTYwW8l9SCvZKzM8M/bZ1rzQ
xzMgB9A0pE4JHt/fnLHHDSO3Fuxj2cbaCcba2yjCNc5vYkWytWlRLdeZ3fMK/+31uwMQl1YhBGa7
BBxylUA3/J/R3lTjUkMqCRq+5O+2DEL6em5X6l5j4IuV4+QusL5UuKbQ3odl2kg7YK3VoM3a2Vzi
fsqr30YEWIqGLr92XAmDmhjoh+sJ3VodbbInMyag0Uw6b+E7bbcpv+SsysKq4w8ohVsadxCOZyoH
FiFqr3NaJqmH20+j1G9VbFyozbP+WUkcy9/Y5w4Et5mkIZqzJoKvDgqqNqUaiaQ5bOg98Fv/L4/L
/gW3yWPGZJL6pl1L7htOXt8X2DvDrFsEPL65qAox1Yni/jmYlC09k5nppIO0iasuEm8Gbe4jhEqk
vqtRbn/Y+jMQB/t71NFK5LM0h3d+4zUF94uZiTBbatGsSI4aVqDyGkxi1+7URj4mF9MN2jVo/Taw
5Nn5ygaBd85q17q0QevqA/WSErEnZ2sjQt77YLmOeu1+Y0/Gfqdkt7yJUeAUGwgxp9higKWIBeQL
1CcZuAgVqVX0vKe6U5h5EMPV+2Y4ifTlwGQQsWj62AoidbKP71je4Yor5rkyPXU4zd2V4sleVjmG
ryqOGspCCOmaNpVqATZNOAgrZIhJhFfcXwxmjZWKceK2toY9ueg+Fmhn6BLhXSGLWpq95FZs7axB
XiywJYafuD+46wuoMh8B24OOpCoBtkaN+eOwJQi0BcapWe/Gm6KdHne3gcS2KZ1FQ9F7Clv3pmmE
vSUdEozyCMxLRragrJ488E4/TnO3Lm1vfZeu92d6YgwKfpkf/NARK/7uKFS55Szch4VaNOKzFH+1
ZSXBR5zx/IqUYka9GBM7/daDoNvWEyaaQ2XSW2XDZNDcibMnSWSNc4x7za4M/mnAYfP7f4fSPCkJ
cvmRnO2JjGp87UfhUA04dKIK2vobUJaqoazAT/I8VuhmJRoa646sE1R5zLVFpRtrzD3l+qUQxTx6
5LVyhWnPw98eQZ/PI1YlnClTD0MLrO+wKeK+yQVC7Jy5OS4pKMtrpMJuwDaJaJAV069khmd32Fmz
F2GQl8AdEUdJiPtFwU+RJt2E6oqkWZ9hYCHynhyTZMfrEUy/6+8gY9MpSVaiN98WZp1U5NpZVJdE
Rza7fKcoTtfDJrOAfKVulAET60gmWzuO9XBMRIwNWwtw9E7hnpVyVmAvwNmiXIFrDZL8lqV4Kf9D
PG8ajaiC7tzP/LCyr5w0o5Tq1jUIjjsbG4bIjjkuAh3qmXkxcNGBby4b84Vv8vJRVreG55HK2D3K
azvWt7NA8e3C36XHEnCQgsVYcyXdO45uPZRWYAO7a0pieUFb8ReuZslPneX0DCFrocD7rksTAHtB
dSzwikveoeqo0JAZHm/+NH6sdI3wM4NhDK8bF5hBFfVVaHEDAlATm+zBlyfJRZ/kev6whomJ3+tX
sSbFG1b6sH1CvHUcBKU6wMMuBk9fnTD/AeSoT4oZ+NIl4RJb9UMeNlxgFqPHaaQhCUULzvc1tW8S
slZrvJsf7MTzKiHNXD15Fdf+Z8euJkJp8zMNtKZQp7XY00qQC5PW/xq+b87Thr9Xuq9uJXv5S6z6
fR77KFd/tRP9/swpeKb2LtivQHRQ0/S0Ly3guTx/mXB0kVTEFia37uuQWW6jHvP7M5Zq/1ZqmVkT
lVDZw1iMsJIRQ6IjTpm/ce6IN2c2+wtPQfxZB9ZiBUo7eYTy9wTC88nOLcbJEOod7odLAag2+YjJ
15S4AcYyFBbChaznCiYzApVP1nnF5LeLF7AqAnEgMCEDwWpWYpuuAGPd5dBZCNlBvdTAYElYTt4c
xsrzXMh5FDpk4so7NQ6E9biDpcYbHGeluqS7cTTVYoD/LSJCy8DrvZgJLOeEaHT8vW/Te7Y3UoER
Bxl55tr+KEiuRa1FhPy4sz053wDhkoHQDpB5Hk3Y38cFyckMpLvetch/9nuJ/YQ0BmQea5XQ3j3l
jsM6FlcJFDij+g/jMmKOk2LTNifupiv84R6AtFxbUesCx2bDNtw5i9F+6Q9sFpD7eFQn8e4UFFdy
ay0bUIGq345lf9Y6xN4J7USIs9W02iZbSB14Uj4ZiviZt3IUNuWBgqbF+2GUOD08WjcqGl8FhV9+
wsT4Fxdu8g8F21ejj6X9jyJqjfLBABjJzemsXQT0PTAI536lquyqSYwY+lEfGw2xkiZEhGSVORSP
bCPvmeEDTXtgG8E8sqWz2MaoyXo3Jb771CToMygTWxQtRojmAEyHGnr6Yn/ub0NLEV0Ypjb5bqBe
amnnecvK3bp982wBOJSwaNIEcDOj3OZ+O0MgYcI477WUV6DZGlaTcoJ8HuaGX5lKExeNiFpLqUdl
3nBo6AhdJ5x9fwd0lKyfavDMVnZl3uAsA/G+96fRFKnZfjKGxZd3V4CCrKmaBmtdyacHQ5vggH7u
sOOSd3WMmms3Aw/uHNCWeQ/5KtpFT1PUbHT3TnV7yRM4knZq1DaQjc6CGLiaHzgFuqHyBB6oOB/e
jbHlZP6VuPNKuhCNG7XslVoeo1UG9qkcrGyQPJ8mfOvS2YV5dQmxhY1Jd4KZMndKQ5Jw32aKp1E1
jIXOQCigR62MEQcGNMcOhwW8AD2b9YE7HE/As9CIBOZgBxsl123tiJ4vCBdOtT7hjdC+HKDtcfAb
BCTFd43HG5WgCmHiXLcmSE2xNyIN4TI6dzmhuGJi7nzIovu7yQ7w0WmC7z5xtfdYYQY0AFhbf/oa
NkDuq/PFr0hriMz6vOvzfreSrRqedXo4d0Xqb03vrjNzSfCxkMUmMoJSOQvFfFr7MavDptLk3ajz
eqDlsX4OnfT6xiLfjbic59Pxt8Xm6HZp3VvfCvYDAPtdtvrFWrcKWroDiQJ+785LB4RjwjPm+cNM
XD7PhIy+7shQMpfI7PAioT+CdM1o/lHJZU6lNjXtPTVTgKTfz5O5TlkkYmi6XTjAJk085Sqj1rbO
H4o7L1hxCaG5+Ib3iU2EzSWEV9LHE026wwwWhw6xlxwIZSFNkO35Hh1qjFDQLUAO2Yttt4NZUK7V
aiibvBuLee/9QXERx08MF/xXN+gvAwkLVW8y8EPE/a0Z1dvoc3MLh900fVjDTlpOP7xoDfXOB1Hi
Z1bv24aUZN5ENU92lAibeh8Ms5EXoETMsTsvfGfsun91iPyy+wltlPAyWVcAqa3arq7lH20G2BOt
GDYEWJUZgr/vJbtgn18iQ7osfBaFqaHCN2xBnk4WPBFFHIACBtezL9pFGArJ0+QOJsDKymyQKLZF
UbVQ2T6rWfUFxfbHldRBgnhLnC9Xw023vB3aIl+OE/Ms8zwciqhinM5CEQcRH9wP2OiMEiN/1xrU
nIdaGQPWqBvxGoWxEClis+BKXm2a2jUgnxFUd/JGwhS3X5XrGfckSdv220uJ9/pA2zkL7sUioO+S
vACtLMCpF1WigFBaKxSMevSdLLEvcUZyB+LTFMVz+jJ9V6TRq3PuKnyOQmJ16Vu91t73q9UO19A9
cdbjVcsvKPIW4zhJcWYs1OmahoGAmVAP1FFix+eYhhrl26yCPXkj0alVSERsRACB2acK9S0VfJFd
gfFKSlcg6chNqK5cYYG8VUnUsG6KifnStp9i+V3D+q3r218u33BLsxx3znttTd4+QNRUE3tTkJfi
52TJ59F0Q+LDZAZ93AxurRlIx3AaO7wGL2ACbZMgK+61eOUpfB/2O+ph+oemlLYT1XBUld6FsEWI
mQOK2IO4B9iF/fGdSBr2dEdZfuOD/MRRIBnlRlqIzSJzV7lATsgGYtt4Bcud4rP7DncOwtxTEm+p
eg/hhSi6FoyeBG1Gc0X3IGsA2eVGAsjtHmmqZbRkLdMVjrhR03DFBjiAJweRIHsInGh1IM+Aa4KN
IDGHkN+BDgdONNRpbKV8jEW7RkYMkRwOeq2YYlD1VOcfCARkK6SQHDHfFJCIV7PnOCo4ZohAbm8d
G/05qFtAxGBRJ0Gfp9+ArBX9E2ESUuNaLRbshwPwczPFH+RPANCS8GtK0Mp1mfexaN9sLM/xE4kw
EHws1LTy3Tcr0CcYfI/E8UcbXKRbmXbexM4jMH5TJIELWeA6WFsSi52ycfdsJHe+uSKANyclgbmj
Si/m8K/4FDXCLDSuZo5M++DDzMTHRPbSHx7hyuiU7vs+J4dRDq7YseH6TlyCVRgHiI/msiRoUDga
hsK8IMd3U82N7XZzA4C50mwYtr6jAUhHvbhSqPeVlWJ8Ke2YAJOnvj+AWTwRgVvDDMi0YzyAsRXt
aAqita2bMR6+dS/6lMLhhookYto1JFQkfOxINvZaCdCxDe4hawus+lCjgdg3oX8Ovu3nSZGTezRH
uEg6SsgOM7Fjeck0QrkKkIzoKfTtfERv3IC+JF76EmoLn6/yFwfWlcO8UTysOe19TYnL0js4Z4E2
UQ9czupt1E7bbcCNLwhPD2sPt/TA9WcO2iAb4JpbHyKbIaLqnOCzTXZYnkauvltaLgMObhqujTMS
vkTm213wSWTn0XfYZsQqIx77UhC51ssQuob0RMQXedS2RPbx7Kd4P8etBUITxRFvgpVxzu2Hw+78
L8JRcQ+6IUBHnYYxqte8jJIaLodviA0YzvET2Ny0Q/q9LwgYyxut9zVqTb8jPsTinsUnP7H3pley
5bbZWGXSUxAjsVqNYc831TL09Df9kG8e3IFHUzJg4MB0ePMwHt5VZjPvHrUwlWCDcXbgGxyA0Xle
n8jA/qQuTLnFvS1/a8rGkQhg38DZ2amAvYkornPLLAEDawoDoYNBh38ywmdEkoBu0NhitHqusXuf
aEkA8/R7E0iWkKgz3xOhFIJBLK6/gI24D26eQmm7SmJIFbBlXn5T4iv2ZHVTOOU6sVEcWjiTLCTK
chyfVTZ4QZZNqzcybDXTzhaOhX9GsEdb73/zEazi/Hibg1A6v19nQnzlv/BUX3qBJI7RBDEvcuuF
VFwk/UYFzcCg8XKH65RLDcp+xmRUfz9exvQi2Tgdh0ZRJUgUB0qIrgixrx9RT8r2PGtXZCJrtQ+7
aDLjI541V77xBcq3eR5k3o0epIPv/1+UQ3SKVtzYCQpR3e5WcIaQpj93OvRs62eiNk9qEDbS+reM
fiXDO/eOm5ZHaYHrtfIA2CIIRCcmDFdDnOvfeUli6ap3ae7EhCFEbP+IPVkocRNnmHGXIWQdZNzP
m2jQn9Me7eRShRB2RmX8pIlGWTydLxZ/6JhHyaabZ9F6Ww8wRbHLVaJigyQ1aRzywkrCxcJzzC1g
nBgDQEJFoMEETznNjQ3CE4LqJ9yatLXB9XcyQZwuOMUf4xklurNGBqhLZVKG3HydFuARwlGKrIj1
63kJ3EEdJkgApD6U+V3FK09BMS16GnGmgyN3JHdmuyx6fSIrYcnr3frkcZ0intjAjVpMs2qr6HEm
GLs+jCq6uXYN/ASnJfYGvddHQwhCPFLNrc7O1k4ZuklOyi/q8OKoy+pwfU+GYldXRmoE8smV9HzM
+uQ8EOBBqfvJRU11olp4LVl7L2R3U4ATKfCwGE4Zrb2l+Jni6BDuHyZzEIKWlk6xiYPuvdyhcGKO
Gaec8UUfHqzAMQe3Vm918XHhx+BnP4OCR/lBHQoZQDLYv0cmENLV7LRuts7+l0FNruZqgjQEDfG/
Jn2nxyF2RDvJDu2QCOLsPV3PSjI5/RBTVy3glf8tH9LFYr6ji4MGieAExmyLGK2+h3YfUEcpMZ0S
urFLoWokcJAoz+bAleDWpAjY44EYTe97qQev892Iff3y/CCxQmLBcZiR5i0tB0YxW82zk9XmhOgT
4a8UE7eiu8jZj4/t8xyZk7c9h2zyNchKmwkkRHWnRjQjacrr7y2uffEqyiIyRc7HscMvVbG0C6Zg
bDnf7KQ6eITukEwxxi/4B2n93smiJUu+C5Wnrm3ZyeoZ8/X8V0l1s+QHGjTnkdsiX4d/4zObmGZg
z8KnNKe9/+SS/HFKz7l1sJFNrgpQFqZEG4Cqhy5yIJzqT4TWVOjNjMLAnXhLFw0QiAZjFtkC6lQD
cFz+rQkczmvGd8QjAjAZz8nKSNjwCcOZDFXuCb2ipHSK5n9Ami+jF4DhH0IB81TTwhPy+VP+HBGK
H3H5o3Wlki/G1gGIUEZoHp1Bpyr3Y5mT7pwNDHBSwpg/zOMaXzxhyftYShLnPnmE4AlSnh6kyGtC
5PSL3OF8bC44MF/3sUkmK8GckHbV9EhDOiUnlTtYSPDla3iNbKUlbR3RcCoRkmuhnzhUk+wtLOu2
bTkT/6a5LGEfy98k5zTg9tLvquP6hP2V1YjLlwWCXwK96OoH4OjLPJvJl9C5lHdHx7zPVldb6m5n
BAn51aFuO5USZGxsUAoBSCAPCEKqO7FQS11a84kTI9IaEVRP7FUIoWa03iDRgiprqBDylzgdrBM5
lZDe4coy8g+RAhAcHZg8t5lFLGQLMSWRa+RNWLcdlELwrfAO9n4dSdAnEW0LPZ2O+deafbzoJz1m
R1CGIJtE/VNlOwMGF+emEbK/d3sVKej6170P+ki7tDz06tKoLOdQZ6YKvtwwHvNMZKN0MaM5fdi3
SL6NViZyiNu81uszfsnpEAFKrJKOFFWUV24GoooOi9epTwdepoUcGvNpfTbjAJitU03lORm/vVr+
PpuAopK2RaG7IMz0+tlglPZV9tgetgcvnaZF5wECUBztjb/5ahU0nZcqQP2wCHZ25Uv2w7cvJKlq
8WQfXG6emcVymgeBXjk97wLst9hVAEbJFVGGt/6RO/u2Y/5oPA0riArZ3XE8OkrPzN19iJQU9FV3
zmachu8xsd0JnA6Qyb4YwO6v5ccMQ9maB+yHYcISu26MoxKKAZmet07ZNsbMdB9Q4APHdviD5x5v
3YyRElmfgeC4K42xc94t6njH4ZmRWAbB86UMN1D+KLP0aCCPabOYFuVnVEOdWGL24+gHiCRi7gGd
+nVKW3xtVaxniHVsQFv8cKZs8nlcv6tIcX1hfALvHTe4hq2TZfV5fsZfS6DmARo0C2qZZQFpWaOB
dmjNe+nUQABcO3OHcLnIc2LaNIwalrz6v0dH28d0WSFMdvhBMk5jSmum++tnKwg52rN5XTExOD9W
EaaZB9c9Kba7zVIYXT8zIXs2dKPJ1LjNI3kpHa1IawNfp0YgbwrJe/DmOCoJtEVbjW5EcT/sb123
qgfGNDbVa73hZSJTs3lKrUH21KnGkc51gI0zLaFo0MMDO0GJu7azt6mbX2DD7MRAGiOtSxOeuUNT
9yJrADwNOqKDcVQccH8oAOliYrMQsQwO+ju4RI6aYyXo5Xi9wE9xSBtyqej1V9PvcbpIWlsG5sLE
Bt1s/DvE7OQpAsubUnu4lKofaFjZZ7T5XP5tC7f+mj9wg+z+4/CK56K2wM/7ydFzrEepLP6ZvErP
pn7spm0n0gjaxxV7R5Oe/rgRBxs75rYm+M6OBqk2Tp4EV1JKoah6ZMNZojGWmQYwNfePIge5XIDs
KZQNLzW1n60AoX2ic0qR3iOvI4KjVvi5nGUo5WE372LV/1GY49+f+WWAtUkc/1HkQVGB54gVFkQq
nITX15V58MwbTPZ/H8s5W8QozHddlNmuGibZ+iRqGiXS3WMayXRysUT+qGZx4viCaN5se6lKYpOu
MRIQTtnQ1dseOo+W9R9N47Zz0WTVgu7JbTSqwxM1g6iYaI07d7HWd6efKyp52MPKAJUR49idsujP
k6WfMHb9woCtVe3ieD6BXqneQc2xTkSdcGN+IJY62teEvAqx1GviIZDbzemRBA8tv2+qQdZWafEM
LK9/hFKC5ieXjjeh3+N4Jic8PU06nAUGWg6gtQxYXuYG0egtI+DLUVbjPChGBxRjQpBKnvMJ+gZE
UA+r94jMG6YwNEZN2PA2+O4kj9UUG8jT8mD7liWBE9MtpZb2oPN1YKHS9OlSD7a7WPi616SDR+hB
u6Zz8WAsA5vpbXq0ZF+l/M4kJ5Fz/2TfpH7Clm6QeHoKzutMj70g73FLXzG3LHBQ5j0PqILJQoyx
oPANE70TCl+4zItR/NT/gp6N+XQPxWDmae0CE8sQxEPQ3aAZRpCQKHon9weWdIc+hf85JgR+ib8Y
QFdTVob6F94tuWlr7xIj0/HG4WvS0y9AWnXyWjCm2YX8GHozLQIK/6hh4wARKj5cbFb+zxSmxBiL
zjXtkdiKJEuQt6/uPlI2JIRocOoxvXy8QEG0IvZnK/Gl23i1WTaNRm/bwxoA7FBPZCt+gogeRf/g
5RPuYT3Gxst1BcZ2KIzNTSI4+3H5FUMMayszAcVl6r4S8vCov6Re2VPu6fiGylj1/a0IEEAwlUm3
tCajOZluK382fhhelNnGv3eBXToUUp/i/o9PegE4AEVQz1dI83UUGc9i46DyW7yuRvq50YoenaA+
ggkK2TE4rs7SLs8o9xVmoL+kjQBrctkG8VfPsaZLM9LNuAebUkANvomxnZb01hnZIB2v58ECCI4v
V3E2k01BXE+Eaef1dbX7EOz+qnhBJkw5woK1C3AuieLnXtP5WLQzSmjIyO48kxqApq6KozIvyqsA
TsM/zCPMCxRNcJkg+FfRrS/jablI086+XX171wKrYVZEbo3vDGFIW2r7n2ZX2RL4GwH2v5RiC+Xw
eWaB9IF21TTflzHqSIkfM09t991cAyDvkeBN6DjBTbjga5S+pURxUR+So1yuNVGnHKyMBNGjyzR6
05QKjx6RZ+yZh3/fdgfil57rNXIi2FVcm2BYy3Fx8GzfsxEdno43waQhHR/kcDxontFaCjBdsk4/
iI2UV1Bb8IwdcG+XPnskQJIwahD2airKAMvGz0l6ll9yZ9oW+w81L5KYQTKJyaZd61t9F+AzHZox
fWlzi+4I9+miwaQSFnSFTuatOnVYnj9Sd5Q+SJVb2CRAR6iouedbo/fGEqkEwKALiDHg2a922BcM
wrdgJvcQnSVfoSyIVvlHymwod1P/KmywjNdoLnv5Al1phu2F0TnGpBRi8RQzbSe3bbWm9lIqGLMF
LKWH4U4Eaezp8e6CMd6/aiGoZ4ESPctrQrHTkNft+ivsZoLn9mZs3fH9+T0S2/WFb1EdQH6eZpRL
ICbG/mT3sEehgzHT2kPNeo3A5x757GtoJ5JOVCB1SFNcXZjrd3VC1nCRRT3L5GUTnc8/PQ9NPmja
4w+TopZ4C4ffKRQbVmZD8hrz2VONi4Nkai9TP/Ma4ojPQ+MthB2lCBVxMGEINrSHRhBNu+aoJIKz
67vN12s7J+cWVF4U/EZierxcrBjTsfHTaHLPRSnimk0QcKXxYTyTUbbmySKQY6rWi936xRe5ELiw
h+bTFPImz75L2EEMuA2u4YZHRpGJ1yUKQimB1GE1WqqRVGAwgv1Dgipr1bFsbYjiaAs7dIRsDpv3
vJ8IVYo4DW7zb/+MgW+m6oRNff+Y6iUQoJnQICNhya6jSOZB9VcSDhCXDTXxxssG4cAZrCjYhbEz
RA/FgfalU9mTJ2c3Ba2sl9BkB2zsUNK5Hb5GJtDraXsYO/4ShzVGkaL03AvMz+dTzplsjilRNoaA
IsrpNwOzi3krpQZ6/dKkS/ecQWcQccTNyt3VhRkiNP+wMpoUFy2BHFTVLLl+d/OQ6W1w9+sEG/cl
JhVgQBFEQFz/WPhg2BO9mKwT7665aDWuE2pw3J8pgdaf3H6MRR7+P5BCnpcDM2CVqVWNqUP1koM6
imO0PwbqF1YDuolpbcInOazzaV8vtUn5EkcErmpshxgnOk1FLeR+w2d5XMOBR+m9dLPzdeyOnSGn
NKKyVG9A0RDgV7pPW5hOkxt/lPg8nL7s7edW+OzP9cKpp8iVUAxLQd46KBj1IufGeeBpMQaGO1Vu
w4IYaaPEsAvGCW2UYWJNLaTzThAc0sK8vfdMKCE/B1dVd7tAE4lPmhWgP0r9Wz4WK45U22sOB9q2
TBjZRTVp4fG5Bbe5Ctn43ymOVaTCElWSPIhnT/GNqzFuXvCD83fzG7oSVKSi2kj11A0X3RzTdawH
/Py//HCBjzkizAfiv7qs+sFKXfF/A4Jdlyyzrl0ldCEeHv5fh+fiEUrWU/gLh29LuVPnKG32hIzu
WoNsAstvwyxYRA5+Z2RKsRL67s+KKDCCInXe6I3Nnsw5yNrbw+oa38xPSlMDHIaqB8ISUPqK8W8l
5AtRUFcj5N8crILvviTmxcSnssv+kHM6kXYN1R6OUGeFXHuLAjjSoDnHF6O/YvtZNqbbqGBg6X7V
tg6JYk0mBV0v31fuOJPi4UhmjJYqBAkaLGRjs6IRPpAIYAMEU8KTmrTOHPF4VAE/cWF9tGBFfHxi
Br2udH5TK2ONO+rBlBGzs/MDOG7PURZ1Zoty2MvXnk6lcqJ2DPNdRFQMSd2AiAUo0zInI74xxug4
YM2bnLyqSO0RvgB8tTdYliyEom1+1t35FcoaMYUDbHAjOsFiTbmkEZMz1sPk/jOZQ7LoMBoAOUcz
/bNBIa1TdBtwKiWC7TDCH6aT4AcTO/gdEg/IHmLAck9AXGqiHX5Zp8+H55AZc4wvIaGqnuGcVIQd
F80gx83H6QL/vplWBjBZx+9VnCQxv50IXJt2TLei7zxhn0GlXnnhmZmLnTGFXmjrAH2gwR37ioQz
Xk7NjHv0xlKqbcWQV8LKBoYzCEIS3DBgKCR5Zn8VEFh1rRso9liUkmHrhDyjTEK2jnCnwD2q4HOE
eNEqPj2+0kTNCQbVHU5oV5BzM6pKRu3Ufe/97FlxM/mVYmv/kTenTj0oE5wZDTSR6MLhNrvO0LZc
GZST2rkHUbgFQRDKPBT0tZBD8lf6GRDZ8kBfyeG7rRrynnfuopS5oIysZ69tflqemYrcEFepupth
mshkmz65xtcjDYptcp+TBgN7OtuZueFBzQ2ueuHHB2D17pYC3+cYJyZJxUJVY35OgN9mGaXB9dUK
Vv5YEhr3ieQAiDl2+KxkVkk2zaRE1QOcyyXcGpcxQR3ropTDfdie39yMAzC0pNs7G/oZQa9padac
JWnV7oKFEx7QdAzLBDzJ90WlJyOj0/61yzZIKtvxfqTEsit4qfXkiare4oSZ7ZrI/cbmJNWQNTa2
xsZ4ESe/s8Rh8SZT1/bENPt2vjPy5nVWHGvI1zsQedON/EpwRsM6+/m6hcimn4Uqv3fxeRC7K0di
Ry8BA7kvgF1nVRsY4cW5CpVHCfuu0CccITGJUJFhCXVWYRAYOvUoq4tDA87fJi3JCg7FT9bqa7by
igOw+lG9hpjb2dTgSWKH5rBr8P86/VcdLCdSYqrk+WNRm0Gk2QLSDcSNfWfJEmzahFj706j7kFdV
3fohAiYdihZ8V3efHBLhxq1khzAs21LXmHz7suNBRErkNdgFTvWkuGxqUjSxZonGuAdhxOWfkrHe
zb4re9h+SddmWNBrNDDQatxWUgimfBWr3fkY2nYU9o4/BXbgn9e9D0JnMlZg+O+XEQdS0lTTT6lm
0UxtlXLIjbrpVPsvqyESq73QA7MmkTBHHMO1SfXAG5ZwJWKvYHl7kM8Rx11HZ83VS7NfE27pb3c8
vulq0N1/sNFnH8bxNoB2m4UvhYy4SJ3p0ySenSHk5+SHamEdnR/GFzYlnQ10Qc+1Q7AgMSLjM6mf
CgqUkT0bB0ttg14HOElSziT1LMZTbH0dSNsMHZHq1Tqmd6X6XvJniY29HivDXyZ3hE5rBasUTAhu
NeGbPmmr/HB9R8C9Dqcr2FhXqbayRVKMB6YNI9Wmg59KKOntIWdAbRl5hFq6J5w8egILZul3g7oz
KPrk3TBcwf57v1tlLHzLwPEg+ZiTWqbhe7Nr0jgoi3kx868f9xxZOi4h1371RZw7WYm5ZebnjVBX
92/ZEVdxCbdkMPsJ1YCpuvsPkU7jUtyKL24fjj0lTCWRwuLybUidP+bTMnN5GdWIGvzXmyS2N/CV
KdhIgc9oQ7gaDbDEGXIbNj5tBInWb1pMzG0HdMDFclkuiAV2bjPQXCO9rkdEWZbAmxn+Yh5dYpCS
1kfU5SnysspbKDlRqlxaSiCKpw2WiPe3Ywg/AuHPvvU7QbqJ+kEzggN4xvHOnni1po34Y48a54I1
m6/7Q5AaY7zCgwV++vsJiTvDsJ/U7i1Iv+woXaA6Y5AAM4r0Md6ZWKgIgMCdgoemztV0ffxvscNz
hQPWUB4a/ezHC6wu/GvCn6ldkgA+mmIIEZyTpDg9TJqIZ69IYAIzWj9IOLFbPMNpixthj2mk9f6p
9axZW1InbKkSjb99kjpZkdaaiaQsZwB38WPFUIiSlmXCTQHTlFi3TBoTBmrjSos/sVDfG+GFlr6O
N1PfwpKqL/1cTq7Ej3vaY6YGhGU1YsYnrsDk9q3B7V2HDx2lJoSCVsqQJPB2VvEenOYx1z/Ie8OS
b10cDba1tu9dmHvTEf1Eqvy/UiHarAbi8POeIYxbSysKNwKKrfBvnu3AqyOu6+Sdn3f86fHJx1/C
0d2wbqAaJUplIBuXt7lRm/KTOzxTDN9o4eUiNghLh9xU5j6RNDDQ0qAw74q83MhzTL98x69dOVq+
zWt8w+F3XwkySMxQqfAGs8jLvNi3es8c7oU0jCXlX9EZG53Lm1W00O/sf+q/rijsZRif61ljwe4t
Hjar6uC7iE5n11FK7V4SFYfMSA7XMbG0KwqaTb4p3LNR8qkgFlJFM7GTqjCDlH8b47GjXQZgltDU
YMBEUs7srFcw/p3Q4bmolSuWxil1ecvxETQRZ9BXxYihqr+3Y202xNXYlDvvzyoo1/n4/x59r2iE
2MKB4o7jjVuNMaWFU0EHMuLi7fo6IM/kffY5/gksev8BhA/VJy4qdG5Ao2AcT28OEMfBqwhvn9dh
DAR6wnUWnhQnABhu2KBgCEnWo455d4NriNegubJq6si9Gtd7PxaHs/XjSjh3GZ/9yi9CpChrDQDs
HFLpu+i6R6KA09ZiQEC+u/t3DeHFe8hZOuYhES8etvY8hBMFJKd/BgznT3LprvIWxObcg+GFNj/C
bkFHn1/gcnq6MC8CFOWyZnXZR9r9Pf20Zpy45eEKUvULiLfBlMPkIAiMirF6vsWxkIoKZeW0tSFe
WEkgqhXokFrcC5Yu9OHtpIQzEl3d+TI8RGTdn6HAZfuzRS9R+DoVUOZMdB4cU8eb5+0UE3CFgG/j
DdHA4Hb+4/nQGMLKwvyi+8XQmVMCkO6R+svgYLdrqdG2PT12YP/iZ7y0VKj402IB5gkxRJ2kWidv
hPJF7oz/Xe0Z5Pjd3vHttOtWdaa84yyG0Sk45QnJGaPdfrv4Ac9dYLpZaIKUJo+QYQuhDKATVcho
9E2DNKxWqEyUFAhEh2oOWwiysb8DPoIismWqdfrTv+uuw85HB/1LG2mnTlY3X2Fv0B/nhFn6MObl
bqdM+d5xVCzO83N/HM71gHH2OuA0HhwYZ/tVAidmoiW4G/U2q+iciYHwpx9Pp2reQc1eDuSeXI71
l6hTCLg7P6dR8ji1eXYJ3FbiAxO98DOslT4HD33nFmuOuW25mFSHS5i7KBhYUhkLH6/Rn5Vz5yLP
p7S5mLeyypAyy+XKm6P1uXrTXaZO4L+ZYienbRyjLwHmdMJCZJBDjdnhtU3zM0IWgHJ0XlqcBbO3
Lh7nGpmdQB7nXgH7derKteFMsBkpE5AEh2oixvAu5ZPe3zCVDuQ7k4EZHd+94bBR+ZgSnJuQ2GPu
2aC1uY5EOSEgfkWhgbmwzHOJ4rLNtMscP7fDTG3oI/VcTa18UWDRSDPUljBd2VDvxsNfTUqJiu6R
t3GJ5oX89y2npgEGiu75C4XKAeTPUz2TmDBMfOX9YbKBvSiwX8hlshoJEAtnu6zCdTAlEIajc9bz
1gOAhAI8564oEnts65yPNrpB2Lkfqfa/6MZdO1J2KZEmKdSbtSMimOahAAO17ISLdToxg0eZmBsC
vpEtElpN7f10rgb5Fr6NNGIEkJ74OFGNMTNFa9Lprwwk5NPP49roFZdi+do/+hSicr7iWn8OAA7L
LU3gfPIrQSGTGvSvpha4S57QUPLhcgt6SLjEdmOri1UNoUm7i3MAyQUwA5rFvv0Tm1Fc8XkO+v2I
EzzOE15xMap2btNQofXQQ3tZmIKQV3yCQU8FSEj7Xmo+yA0V/Ke5DgnTn8GgL2ssD/RZRgc8ebVD
rsLA2ZGXBerxo14ltMOQLleDkfMi3XFGo+Zjit/CWAW5KMWy3m5rgxDDvCuTOCvgjhk1f+RvAHv2
o4GOlEJk8MTkba2RUTNND1sCSqVOFvelxCIxO68Avhq6K/rPP1MSnXAuEkqGfoYE4BobjapmrGKk
qdasOsJlhZj/dFaAWx67bJR7B+7PHDjQE/kcnwbuvYtDs+L6XlSfqs1MiDWxEPIdpJwq69lGrw01
Q9imqBMxHTzkgz20D9XJbsCx49rsP5ATZvLUV26cSQwVi4hHUQ1ye3mLBP1sBwJJTFZJgIOlL9oS
5gFYLqpZlKd5YQ1dwiTPhfYnoSr/es17/Js4Sn20po4TQQ3NbLHJM7DVecH0YGgAegbBy1+y3KEm
zy171T8tFolNNZKO9PzZdDXBsNwKn0jU02Op65zZO4PuxvG5M+vN6l/MrGSQtYPE2M/6dBJSuzNR
bJUo1AV8FFj4qL8kkozslCT6z9tjD3Q2Bmf9SSyyzJ27UDc3Rx0BIWEoTBkLdC517QEZYfotDg8P
uOiOnq+6WW6zbTZKRq6aO5vzwfilyLrfKP0/sITljJua0uNLoIYHeoKxVftS+p0h0AHmJ7sgLMx3
k8FxzDeyurSZD/lzlHr2hrk3Tor+UL9DW34TwqIDMUjwqV4auh1N1AJ5y6TJH1FO9PPoQR9U4vjR
R0yX+jS+w91zCcIQsZjiDaGb8mXeP2MPdsa8inKb6UpxF4s/pGZkMRKcRuxgQKZ7ziRXnJGfTHED
BUMn+X9zw96jwt+g+URE1duwbWc8VUYPkdZSEzfuNLPGEd9KAqi2jSi3paBINVpTveAzRhNRoUSX
0yNkqAMWgTPQvczSFVVGtRz7ekGO36QZwifyFHmw6maxmSgM6jGR9z0rJPGreT8vC9cAFp9E8t+T
xKZfoiC6tgLHGTvL6L/rqKKqshcea8jHnNcZqXfbNwZbL5Umgc4tnzHj95wx2hvdVLE38D0nYDo9
u59BwJovPVZ/PEStwGtPfVPsy6r236BEmkomfc+kJfbihuphaZs19KjQ4poezCX2sn2JxHuc2tIo
bDBzp1tVjyVektY9igfyI9IDibLL5KuUtaQo8/iy5OtaQqVpagefDhlLsE6D140pKmoTh4RsVKoh
75uZMdV+7RuAqrOgRSVen5RX7l7YvE5b8+4aMN5cgLnZa4PVgZunnVfevvzz89cG8CUCQe6CU/JR
R8Mf10Muj8wf9/fEvS25yW2ZOV8drTa6ued+qgR1T20QC9+t4dzY1KrQoWkvV55gQkhVTFsiwJRO
oJWqL910wL4hLE1kZUrGKJ7oic2gmVuvZWf1X0FBLtClVvkNksayy2T1XXA80jP7cYGxywzUp6GI
Gmr7qfi7GLrHP2TMAB8TTyq6haVD+cdf1ZWlhU+EBYNocsTxZpCa/ZmCfe7gAtuWuATCA+jyZH16
kBTWvQeQ06AJRBaFt5D37fuT6ypDzL3BE42jl9aV3sVpjuT+zLwnyjZH3wcTyKEQxOuBAdF5XSfx
40bAdWwpp8B1V7RAfKam2M9fnsOzMLFqRnwMQyfezYz50ty2hA97i0ZrXVNQpis9xtw6ws/KGXzA
GBrRwk6LeOCSeHKd5UHXIL4aHGg9KoHkMnNucSAfxnjScUw/wWT8wrEgLUX1zqbStPspEiRgvEd9
Dz73sPa/nI9T6lYlI0UqpxByZYcQUk7KF9XU5fhWXgg6ku+KPSKxCBFr27qYRxMmts4qVT5bDoWK
8Vx4qk2JY8cozITbXhiMygmASjfrDzx+9mqWMrviWhC06Z4o0y2y06/HvyGGdnJIbv1VmgQMXbKb
WbxckOzanCSWyi7fwQ5TShPm44CO3F/RiIuJlJsUvz+yZlzbxzOdEjcUbmLGPUt8CC6Vodi8wSmP
mAUDqeEyG/YN9IkTLaPaQZSXXgg6+Q1rjBXOKL9Fj8hVoCFRnZnvlHFrtPvg2pf2vpjn/ZexlDY+
HgffGHRIg+2TPbmcuMCCFwQ1oz8IJSSS+5klJ5JxJRQqhbKvKGW1ztexL6q2LOMA79pNrgiuk7eN
iVg8nPcBDRr2dV0pqhLiEaH3k4jz1C6HwUou7sEHDRNBJgVN+XzJgEpQeTX3aLE7u8/K+R4NRoYX
wD2CeM//NEnRgw+vqXkgaNrurnAXmswSTXPXclTOOR0vYQy3Kp+ia/EDkaOcQmY9NLaSkQnKP2iH
eWXLl1i/iFqkS+azvAm0bQFXUtx1MGCeoOg9eFv62C8YROvQQ1nXHyq1aX7cFsszHRHwMtNo/89j
uFCKgtSY47AzVp/JLkixrhRH/LY7Q9leKTnywcnYvgA87cvO5qUP2tfpyEJFKcjIsZb6dBpFmdYj
rg/xlLS4ov4p+hRWFPTl77BTCkzF10AJgrR+iJJDKQCaFreKQlnERqZ9uYAt7nBhx0qhIy2kcUUz
TryCwNo+V/4e1q6EfcB8oxLDpfpl57GGCc/BKYQyQ+VnjvwsNUXhEcizugwYYIDgWz8BpqU6R+67
i/ftBUvyQ0lW5XGXxoIwjEPO6AudUdLQaGkY1QOKng5THU+yxigfl0uL3u2SCYQ6az3y8rf3ePll
C7f/lFRd83Wk/SrSILTpIgHhOL0orhyUqOK54Viq4/lkZO/dPHZ0rZcaejGHt3bhbJoW/5fuircn
AuNF2QTHJJcyw8ifzLozz+oaGJTZVizzeD0WjMJ7pwIp1V9yOPe1G6DB42OG3epiNH9C7IA3Hdiw
VptviviISNtyTkJ5nLzEI4Zw7ExTVuFYUos/GcSaRx3eVkRZbzz7cjEmCdzaZZVMJQ2oF9fQ3tfA
5bLDXBl/IbmV1C3Y8PNKuzU8Oijg3Isvoiq/AART4TWdqOnbJrPhJfnDHLmBM9PDQrEQpe525YNE
XF1rJ5mhEgAfGJRsRSrPpI0GKY1tKM/1hhmDshYvCMeF9IRQqISYUzbZJPGobJ01mHFcm+7VIWhM
2j11drUgLwSoehT+IbPQenFque+ZuUQjt5ZPKzm7wVjVwMzsBlUIAkuAtyv1gfqyXkP6TWSCcolM
R3Z/zoQM1wJkqbMAbogKgbzQQpYocK9Nb2z/Kxi21ea2d7liz3RrWRL+RakBSaaiGW/56T2M+Hxu
r67rXbxZXxtOowL1AMi59OK/JCUV1vLHDIDd/DMbK/h1o9MgqyOPVSnsZ/NRE2zM+C2EalHpvlqk
YvdFt/ylHkUhw5CO128IWbshF7IaapntnOSu/LehiUw8Sukr08LW5rN/+a91NtNurc1AJL+E2fFb
0l6H76mb7uvKdVYscOXhsTC44ISsx45vB8ox7PC7U5+jbDt6jmAnl7fSDzriqmp8xzoFUgptw4kk
s/PyLYvk9lBHrbGnoYWOgqWwtC9npzVPsdEPcNRDBMRZDyooXjuV8FDqrPHRe7F7p0oW+CyLckVg
XOXBhWBoN5IA8gW/iI0OfKaILZlYBhoMvks8dfllntSStMDNdZRrbheK8lPNCYxiUlcY6RRml4Eu
1Vy7IZCi8VjIK/a9IODqHILyZHC2GxslzCziknuKe0pyNZt9fgHVisKM6Cf01kTzEItn4S2nKaFq
hO2bMfFw1qm3/+ay71ZQCbM62c8b4CoR4rUVJZCBiCHsk2clpePT1hctvIIRW6Du35UoGFaHt3Dp
5kxLVZzSJXTeyJUW/1tkldvUVZtfu8/oTuWJWd5RYYb/kQzMnpRmB4jnax6b5gPCG+rIArYKDEEC
tYZ0zEv5zAPDcMId1BRNC4SpHAidDP7s/3VabDZjXhgZjNDw1n6LKlmUNMaf6nWyOIhY+eLda7k7
KwQXomrWMS98lxSH6n78LlEuGBoRPQ5swA59LjEe0h+vCFsh1NLLHjwY5+v/5OmyIu99VjW2Qsdk
20szWaK/k68tgyRPoXujj4p+YOxU0H1Pgaj5zVOCmiKO/OkVkHNCNDmMIVlnUUvjQnN6gA2Y3cI0
PGP8gFsgadyHSFd/UtAnq0uNOHULU/t3ZakjbFWcx8pGcZ9miGBxpWRtaMsguagzUtTemPQUjs+4
SAsRX2LqABJB7wsdoLKMEbNDS3ZVqwg/XgBvQU12I+V2UYWytxheqx1wn7f5DqKZx/4/Gypih/6W
0bSSWNR8dAQwYWYr2ZKuEa8fxm6scA5nC4/l7NeK+YeObX2gjKTrAfLMrrZsrdu8nuuD2BMQCGbg
ehtDATZjnFXf0kgxRrdlQJ/ThQtzAVLCELYNmiWO11MEwNEdxegmvATM/A8FcVCk8P0RrTAaQo0A
ffmwzlwKs6RnkPYqbStp/CmHJzs+YBGohGYK+8X2FdGaOpFPmbCyo3TD8zHIqmVCBuIk5g/JUdQv
RkmkXQp/6ZH+mwZmgyBDYlxX9fojxNhl5AZgrq6Nka93GC4nuRoVzKf5ElOoLKAlEnbiFqTvCmEK
0frPp2s3js8SshvwRGaoiiOU14kZ741/4sG9fzUjY5jkKk/5dXZiAj1MH/dkomNqcRyJ9FFHcceX
YYtdi3w9I2qVuEQmMGkRRz02xmEQDbxtU4ihX/WJptEGcaYYqZ4c8ge+TwG1foLy2w2LnNDL+XSP
RUOxRZzi56ZN1CPiUKxs/LHmAASsuigXWTCTBLgHB011ABTEsducjV+KLyAPPlpRpuN9IbnszUGb
jnMIDRq3VjxVeDzCfWNMM+t0QArIGDpjC73HX7klhXtNkkAN+LQ6hK37oh9DF4MnS1wSTTR05MiI
ygdd8BuFnu0TKEMTLHaHvfIml0MD7GiuURWdUpO2+tooE+jg0oZcahZ42EGLVqHZJ85O5m/mqHk7
6Ua65/dOVEety79HJtyxbP0dLTDXZPoQW3ctjAWBui3wDC/i5q2sp6dQ98drg5WvzxQHvf27EDNI
Wgx6/+7CIi3CEdpdJ/dWqTa0BQzXOjeCg8CDbYxlLgVHP0G/YlxVXXfZ3EH1aaPfFDWLSl2ng5+d
WJ3162UTZSwE12rZdqO4dAN25AFTzwOD2ta5E1HIo9BCMF8GWGw+DhG6fbOV7IwY0w0P1ZpRZidp
9VzIucA2gpds7pCIGTOmU8xSkjLvmZaaV42lez9D9ws0hSVnC4fXhq2HBbRkNTWFZATDD2LQX7ln
1JG7gnDpMtxinpaAIytksSWKRnqSc5gmrisN5mm7GtY3D7TO03McKxrLC7o0o2OSEmTjS7u/0DLf
xrtwNc/NZwWgoGLuIyLGkHiQzF0CVU+D2ywVyscKmea6fF3hV35tlghhK3rzSab9BpSG2+nRhFv1
OkFZBUla9QHXOpLydr/PB1OQRKBH1WxesazdnKFZLS4TCpGlkf432MMUn00C9yux9Vghj8nQlzEE
BHb/bb7eN4s/AJqwTZZDQ2borzDeCYJSLSGYjB5AA7dBYc217bBY+JTjq3Cdl8NS9dFRotR9OiFD
xaezbVeYW6FVWx+xUnH57Wx00B6LbjdshZKkZW0ilgYTbnjOfgJldDizQpHMwLE5A+GlXTOy0C1b
rv+ZO/xN8mGu8KyukxpBXbUtTVty0WfjRG/q0CIc1Ga+V1VU5kyomcV9Rp+btiIYBDXXKROH2gTJ
UR0FZryqo2ok99Xx59wIpaiafC0X+kYfPRgrLxD0V1bqR55aCRUHNnZUAUDcZkS/BIJbGeHLLk0E
gkD88t+PQkQex4jvv/KUwq6SHntIlKkHi7Z30eSIznCU/me9aL8cZ8J6wCRm9pu3xcBPprvh2/wV
jaTQ4zCzv4TyNPZxa6xJ0uk9Y81D3J9u8CVTlon5fHqpmRbsgtNMNYzlnxE3zU0QP5yU2lLWi/KH
rsb9ssvZRXnbDr8V4jvBmHpA1qTyUmEuvGS7ACk8rxNX09xoghkAv5YirYKLzr12iq4oks+FQ6/D
dFfx73B/ueCUV4rpiPN/1DpTdfBnSbYfTAJEf9VfW9wQDp2auSzu3s3fBUoSWVpZqJLCB2bRlajm
cRuBJTYjwAY0W/IE2/plH/Q/cc0J3q0hazLI/XPQr8//NRU3j5qE95MRgmvV8d9Kf2xOR5LoZHeP
XK55y54a3aPzgiTYcXA2XVdnQL4izauLzesfxg7ze+6OtOuQQed/H+bXwOWIubBSs3pHKzuwjjBk
0E7sdR+2HRWxREljmBRid/YIJB5Wswwy6WXB9D8hzlZ0ardvtDjfqveBzHL6c6jGU0z0SOBejDO+
DRxfKwJvXVAJKv6/PedTmyx5RH3vLAMIVX4wC51k+Sq5Vcq2jUYO0cBZ7BOl0+nMTduZYSk0gl59
1V/nA24FtWn8wGbO6xTcNTVXRj7q739/fcrZlIYYhqvieGy3HvzMN5mBOt0fHh1kfco6zEMgakN3
t3pbAy7ahiyaVuIosCspVGV9zTHagaFtbkM7GXaB3C0ZLxuTEUaCVy+NE1rvouJS6tcvA8bktPLh
wnyboGto8vv39lYrgtIjpY8OPBuKkg4hi3ewgk63sETkq/tHgyL1c88haYP2kA2Ofa2ZW3onWEPY
fFEpcZTFZGRHbsJmi/EU7gSGYqTdZ3ND81/0W6iLl2uxWA9CJkDh0FtXxw9yMJRWSKNsxNeCHZki
YSrrOok+cpDVdJ0+Uid6Oph91zGfNdlzPrIwZytvcPOyy3/lowhf68A5sJ41LjymqJ2fXY1cq9Jt
e5nm9H3KpKFNr1PkKOwQoBTQQ89XcKuFNVsvckMMivCR7RIkJgqki54XzdGfV6ZqOqKvuXdT5H7E
iTAUCZn3IPD+4OdqMEBp8+Ekx7AubxkIctCjzeRzNeB4d+EL5mVVl6UHi0mYrcIe+UOHM7UtVbk6
agI6EPSZK+08bP0U6Gr6mfY7aKozGqaC/mi7X0aaUnYaON47Wf6gA6w/MhwJqzGSL2S45eBACm1f
pOggZA+RFpFLgqflMp7OYxYHAygEr/TTnY4wvB5Ftk2dDY0iKssrCNpdVBGbn+fJ4oQfBnChAmeV
husqZ4kkhEWm7EEpQFm27MtsJfiuI8LivTVPiNxZnRYgZwJ6MSvdgL0J3yjwxa2BVmy3gxUGbh5C
qRAQg40bei/qX999yx0EsBtLqZNiSGzcJygI4aVrbtAxxty+u5V3hDhRsDwqFt+JMXeePYhRWBDj
EByHBtqbwfDYDjOcTQE39VUAs4ON/DAo9qUgj8JL6LOpkF10YpY6J0DakC79cCw5OhN7waSGuTsA
JI11BROQTs/BkoakNSqkj7G4hpPRprFAoFCV60GaJGN0/hnKxJ7qcCePk5NlKoVLPFLjRd+lKbbT
Y3SCXT3NjB0iu62ysNWw7ggPYt02QZeaupj9W2kJ4DnSd4ni+mPrlO1dPTol9Z9gh9PDm5V5SELA
X778iOJgVKzv+Xp2Ec/WbGB4wfXkR71HrssITssU3pEhXwhKAxyb/xi8ko/U5IG65kltCdc+WMd4
0Z55aizCi+kLrpsc/ZXbniPq522EmdYN2jQRuSkEMs0bYkLXMRCQRbyj0B8KexcZ17fpPT3iuL60
mgB34JQGeUOcAw99uAjf/cn47bR5dO/xJjMpVl9U9t56nKMm/baIlkXagagweQqBtw/n10CGsgcY
uCe+wrh5eKBuPdC6lLFdCWVwlsbvE1j6mtqW7Jy+NJ5ofF/EYUlCBDvBWY6Pg9Tei9cj3c1F6R28
//z4bym+hjPHmMvfbzDKVPeGrxJqDLXCxJIiGssW+p91mwJ2N9oNmC5OhFxmA4FArG8bJb2NeD9+
0XvgkWaH9zjI62lUw7T7brMTT7vlFzLnMb52ug3yz7Zfqvxx1ULCimOzwxEFkPn7J1fzfNzlJ9+2
fTBZiDNB5u19lXrQ4zcEZLQR/3RKcQGg5I8s/0i5etXOSfS/gS1xCftye06nD+smeI+0XK0Hk8Lf
VkfCc3LuCEtzFzkwcLGNHXaiLJzZLYNQfXQjIRGqLwDh29vHTVVtNHBq87M6rpSywjql2wRx9+wc
qjQxw7iDIGi/VFt3dsWfl8XT7Pg7lZXQ7azBD+o3FmVjAJO2myUEN7G7KkiyaAlC7zH1ZR+2zy+y
e01LrgOeglnZXhyCXujIWR18UM8UXYLeMoCBIOLmnoP5eeQFG1lEMKhdAhrE5LJ/5jbL2jVG4kcj
ayfZUMVig7dDms6+5lWWSLA5gFQ5B58mcVTIo4dpq4X48den7HGabAFdpG0GOBDNo68npvCrNJ4X
I5EROLq2EbQ4JTfIRCjlk72K5p6gNiyacqbya6BBM5cktejtWNBV4BFcSQx+bedJqTZzWOOFBFLV
a//KpD4ncTMODd+D4FIZzGwT6nd0YMwS1mdXyNgGVeKzoFq9NIUCIjjz1HmRVm515QxojdbfqHlJ
7nX1nZ10LbL4phqNzUrxuMTyQwh5XfpefKFNmrz7nAhcP+3YNBQ6rf7M4GIfxzE4mB8XOSl1K0E5
yRc55+6eC4gr5St76qkPAE/PAZLzw7IOts5fyXLVH9jhWeMc7UYjFk6+a+xnRIC24xKFmMMxI/pM
Mel1W9v7+lkazspryciy2pVQ8lTqviOSSgIC1dBeCrWER9fZmMg48+GQtdTBRa88JbH8iuXfvvDt
4zeOvbsvfuthwFvIIilA4/i+PjeB8yY1VTtToCCZEnOZ5bI6xXrER95WNu+TJxqCl9dZSRCUk1Zj
FjD/IDxnz411eKZX7loACXxfXL7KgiKA//eBnXcfQb3VPaZvxY1OFSrw6NQZWk4Nv7baZ7V2T+Ml
euVY9si2T23lzWhFAk1oCutqPc4tDBn3uZZ6quVYkPv4nYwJfNHWDEcmBRJUZmyChHvVOhJEbow9
Av0sMbRjQgJPhacePMBazIZiqG9QMAKFSnjljpUoRBxl8ibnvfcix+CO8DTRPk551XVeo3Vc8NCq
sdyaF5y+yN+zMkQbD5X2E2wejfyeqtGQNJ1jR9ZNdytd9v9igrMk7YbZR4zDk94fScVBBz7clGd+
RzC5XIC2hw1fYMI9oq64IaBS9prAVbtqgelUIfM7/1QTG9oec8JhKAXWifeislcDburbrREtthyq
JOwKRKcjhZLIaJVgMAIvHn4cvdNL8QV4v6MHwAUBQHyEADsVb2tKwcmMJ9LI+oubA9Myk8R8Xb8W
S0lYOAznSshpvfwVyhIgaXZvVRNIGTKvET26iPBCHJSc9392scssrCe1XPpKq1o+ZDWtl0iAU7y1
NTFnL/s1qGhm4CjLczB7GbkWpnzRXRyOM9FaVZ3TmWOX02aH3yIHTNaqYPj4HwKDk6Zs49dsb0ga
H1Rtf2yqJbvSxIxWMcEeDjtL0d+7Z+hXAqQ5/tsiZkq2Q03VThtwvUNQR37clcRW7mscjYrlxGGp
jKERPDhbgIwKa+B1ig/P29Gzq11H7Z8jy+SMLqvgYufAYb38yetQfmJA0Szq8hlI9BAfhdNtMna2
rdnWToU3gusBgIXU/7ywlZ/sdWN+v8dq24VX9BaUuHuOkuEMfPQ39J70sdIQaYAchFC4GVmlPyEU
d/HWD1ISJ0NNeaidCF6BWWyEUOMUvkQrznq4fpK5FWMln8CbYePUixcsxzDQGFN/mgbUHyiut7G4
wXKbFR4VpczajgDhBCN2JWYVfWdqbdo9+werPWCWuCTq5Ppj3Ikxe6X3GdeTnuVIqw41ugc7Il+T
jqwBIeBrEASMCO1kjHPUkK9BxTRM+xXLOH03CbJW/mlmlKNS9ZXJGcRHx8iDSQw9tiomep1/xr/U
ZirDa9YSfZyGymUUG5GLGZd4u7Be4OAOgRSkjmvisiPMa6xQFS725SzfGaIi4CvbeZz/AdTmuVuc
Ly6XhP93g7qkwJ38jLi1zSOIW6it8zrEeOK20yRBhgJyCzQW9wCLBgGiq/bvhIBKMjNVTG69GTcP
8pX629r0YR4oNXlzQ3+7ALlzNZfAGxy/d4RWvX9sZPfnuO3MBTMu9utldOGZmoPh9LCuPNtOwBlz
/ltfEh9464Cb2jA4O1nUdn9iRhwXCDrCluykWIAy4dtN0ZsEvkBADRBn7HIhNy1h0KesY02NsUBi
A1uG7O0dvR31Iq2y4fK4NRiUnRKsVRBJjzlLADfSgPe6hQeh6+x+FJRxrqN1NBvX7eSHI5n3+uZO
Ls9XFmHABGCgFWkm+gkDFJNh6EQm8UVGpiUhr/lZYE7f4grNRlaYzGRpeZOFxr2zqyyGvPI10Mn+
WKzcD466/FME/BsyD3idBLiyGL/8S7A9yKZB/sLM+foSurfrQAJz3wSoDkpOu3jYvMR2L7pV1dtW
reN+QQXj2TKWzQqBlcUDi928X0OagOvBsTMc91EazyFxUnxLCZLrPJL1wNoYjqr4q/tb+63RlXrJ
UEZI31FMvueIwbYo1Q3dC56M/+nE2nLJlJyW8O5Ux+suk01X2SDBnCNGcoPOelzZeGL+RdxK+EoU
7+yVMAzTkohPvkOUC+//VVS8i5MjxOqDzcpJM9GyFs4swVfTFGJm0bbNNcOMIbKTQegQVuViMv1D
ijrA9AVUKb1XsWjsgX0DNAZm0MZnuyz7lhvgUvGMftrUUZgFKz00cSklfym+pF43CbF5dRRb7YB3
4oDZ0/riURCrTAV2nU+C5wVWpLUSV+xlrOJjolGGUOz+YMglBDz78YRlsltBiZDoj7ZMVePtnf7Q
p+gYaoVtD7E8X2K9PF30qtuj3ohAWloI/MEZPrpASpTdNYUOFW38GJ07n/mXu1v6/F003kIn3dj2
ecwgBDQ8XOkYVcpms/DC84iZ0naFEbQT5FlIgVZZxTknqFTC9htJEZl91mJSG0rkPqTLR2DZfgpw
hd3fSWzSiEFK1sWSKWUi+jyFptWoUysSLV6hyk1uK9R3sW157TTR7eJP1k1pwJwFD7oy5JbYPydk
gR+GhPlGmebmafsB9OIIRuZsxavYZSGFHGD2YrTLxHH7ORpGcdXeHo1pUiJ8j907ypeOTLEYvcuD
9t5GouWyzeKwsITQ0MwetypfxMc5Ix7YCKINWuo9R8P6avaYMQaF6adCUaHrYtk8bMtQZPk7Ex9a
BepRpnSy0Sl2+TZEpAOuOdgbiRVEsMJn9vmmQf4/1rm5zBPlkihdxGZkz6M6Hqs5KKoLefj2v+ty
lWplw0pKqgtdVxfTtxScpBTzds5U4x0RESQu7sUH54/9Fo6URG1nPrta2egY5uuzrxoLrFUUCBL1
ri8sN4H/VMoSdcQuTaZuI1G79sSsg2ijlUvFAA7NnxaOftFUVRxj6SJfsaQwjJHvdir+hb8sNbnn
7or30PnU0LpLqp7c44eWFruriVA8OIknEIggr4Z8/P78jputzoQPP4+qA+1nXbHu8zhyeIkdlPEn
PDONS0jb6zkNuIplNZwwakgMbTQ6vrbLwoJJKKxedP7Q3cQaz5wcWchfruppKeEQgTIWKQLlV/Oh
fdW/EF3wfBf/kY76aYWkumkEwru3NXvYDwjXXkx/V1/mZ2OK1vX0EC3zym2l8YVXG+0fb2qn2/Dc
gfKgUVsNJMU5xLJb/FQ3yPqJe5s9KXaP0kRT15Stv7FqGeExMTdbOYcvG1ta39MyXXzpOVbg3+6b
1bR+bnjKl+nZn6JCHW2TD53ShShyEyCECUV6Wf4v0mEiuaDkCOu2BOyltLpzGy2x+Cd9w0t9UHVb
1irBICAAgqx5UF2B9uim2c8H5XpT+lrYklh8xvTaSJkNrr20E6zCm3BLt1Z/ijkZxFcDKXEa4JLY
9rYFXsJTh+bMeLZgT+WOdCA483D/8GhkCKFsW0E8QmpEa9nyFzgYgdiuiifbMfDYz7Re8/3AiIbb
yIibQUaXnj10gkTXpMHG5mIE/ZMeOtw0NxZA+SUX7tFsFyI2dotGGN94bHn4wMDussYM9Xk6Mt3D
Q8z+TmMG4OKmhFsgV0JfTPDNzDbwYPiyYp8hAxHYpfkacLitincluhdzgDT8XbEg3/qGKKd2NA8T
OfBjJYHYM++kIjHn4jprpiqsbCfAghjteg19cIqLigFCGPFyC0bUHShgXWOrwqCRiOMq40FtGcEz
eS2hzpx4uRGsEGgSCOCEJ9sPlsWBvlyUUiiL8fUcLcYcg3KshNVYwEfGf7Q1h89+5YGi9oURP93N
Gdn31h6/+qUpyFfZUpInmiLdkb6J2UV/4v6JOVJpHdqoWqfM3Kx6hkmTxIgsOj2j6H4k0kZZWrb4
UYsVWTwYKV3vULgjV7lnse8HvX6PXNP+ErMTYX1iMiSRJbXTGyj1QHN0yA3zmBjAYj6JWLei3MIu
XjeQ8zxJ6dTpUl0ShSx65xX29e7e9i8JP1ZjrgZ/nxQYZvOD0YPgQWXRefqa+j5agpfwOrWTOL4X
ZW5QIVk58J2K5aPlCdo2y1puikuyXlnPY8ReNvtQVJLjYELLN+GjggFL5eYzh4KMOCtpOt6VMJga
uv0ad+NGjmhBnCBSnlovkXqeAqr2Rhn0RO4w+g4Im08b3WZ3NUmNkyptvmutMeHxFRAjOZs/mhan
hQe+g1xndwJ6d63ucjjPtkgbdqOTMaMGGobSF14S360TJXDLkW46plH5z6sHLlYYPxSWBCY5ePeh
RkioaU2KTVNYFT0iJHeSdoeoPqnNWR+vGRr3AMe1cKulVvgkMrlv5J+GixVI8T/VhaKjh5KxQuaI
M6AkYZt1cakPp4tPdQfbNSEfOO9F/CLGbBnXVSIWTDHgBL6/lXGQkyBgAhvoFkrCrc3X8Ujk8Axv
j8ttalO8MIF+UJBYEA==
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
