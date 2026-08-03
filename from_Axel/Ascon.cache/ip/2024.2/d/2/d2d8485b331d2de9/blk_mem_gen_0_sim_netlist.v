// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Wed Mar 11 13:36:10 2026
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
    clkb,
    enb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [4:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [4:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [63:0]doutb;

  wire [4:0]addra;
  wire [4:0]addrb;
  wire clka;
  wire clkb;
  wire [63:0]dina;
  wire [63:0]doutb;
  wire ena;
  wire enb;
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
  wire [63:0]NLW_U0_douta_UNCONNECTED;
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     6.966099 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
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
  (* C_MEM_TYPE = "1" *) 
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
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[63:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 31024)
`pragma protect data_block
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
8G+jL7OjxoTC3dvPvOlOzw==
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
