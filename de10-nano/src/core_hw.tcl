# TCL File Generated by Component Editor 18.1
# Fri Sep 17 13:24:56 BST 2021
# DO NOT MODIFY


# 
# core "core" v0.0
#  2021.09.17.13:24:56
# Top Level Verilog FPGA logic
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module core
# 
set_module_property DESCRIPTION "Top Level Verilog FPGA logic"
set_module_property NAME core
set_module_property VERSION 0.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME core
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL core
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file fir.v VERILOG PATH ../../src/fir.v
add_fileset_file core.v VERILOG PATH core.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter CLK_FREQ_MHZ INTEGER 100 "Must match pll_0's outclk0 frequency"
set_parameter_property CLK_FREQ_MHZ DEFAULT_VALUE 100
set_parameter_property CLK_FREQ_MHZ DISPLAY_NAME CLK_FREQ_MHZ
set_parameter_property CLK_FREQ_MHZ TYPE INTEGER
set_parameter_property CLK_FREQ_MHZ UNITS None
set_parameter_property CLK_FREQ_MHZ ALLOWED_RANGES -2147483648:2147483647
set_parameter_property CLK_FREQ_MHZ DESCRIPTION "Must match pll_0's outclk0 frequency"
set_parameter_property CLK_FREQ_MHZ HDL_PARAMETER true
add_parameter SMPL_BITS INTEGER 12 "Number of bits per input sample"
set_parameter_property SMPL_BITS DEFAULT_VALUE 12
set_parameter_property SMPL_BITS DISPLAY_NAME SMPL_BITS
set_parameter_property SMPL_BITS TYPE INTEGER
set_parameter_property SMPL_BITS UNITS None
set_parameter_property SMPL_BITS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SMPL_BITS DESCRIPTION "Number of bits per input sample"
set_parameter_property SMPL_BITS HDL_PARAMETER true
add_parameter TAPS INTEGER 127 "Number of taps in FIR"
set_parameter_property TAPS DEFAULT_VALUE 127
set_parameter_property TAPS DISPLAY_NAME TAPS
set_parameter_property TAPS TYPE INTEGER
set_parameter_property TAPS UNITS None
set_parameter_property TAPS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property TAPS DESCRIPTION "Number of taps in FIR"
set_parameter_property TAPS HDL_PARAMETER true

# 
# display items
# 
add_display_item TIMING CLK_FREQ_MHZ PARAMETER ""
add_display_item PARAMS SMPL_BITS PARAMETER ""
add_display_item PARAMS TAPS PARAMETER ""

# 
# connection point csr
# 
add_interface csr avalon end
set_interface_property csr addressUnits WORDS
set_interface_property csr associatedClock clk
set_interface_property csr associatedReset reset
set_interface_property csr bitsPerSymbol 8
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr burstcountUnits WORDS
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr maximumPendingWriteTransactions 0
set_interface_property csr readLatency 0
set_interface_property csr readWaitTime 1
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0
set_interface_property csr ENABLED true
set_interface_property csr EXPORT_OF ""
set_interface_property csr PORT_NAME_MAP ""
set_interface_property csr CMSIS_SVD_VARIABLES ""
set_interface_property csr SVD_ADDRESS_GROUP ""

add_interface_port csr avs_csr_address address Input 18
add_interface_port csr avs_csr_write write Input 1
add_interface_port csr avs_csr_writedata writedata Input 32
add_interface_port csr avs_csr_read read Input 1
add_interface_port csr avs_csr_readdata readdata Output 32
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0


# 
# connection point rx
# 
add_interface rx avalon start
set_interface_property rx addressUnits SYMBOLS
set_interface_property rx associatedClock clk
set_interface_property rx associatedReset reset
set_interface_property rx bitsPerSymbol 8
set_interface_property rx burstOnBurstBoundariesOnly false
set_interface_property rx burstcountUnits WORDS
set_interface_property rx doStreamReads false
set_interface_property rx doStreamWrites false
set_interface_property rx holdTime 0
set_interface_property rx linewrapBursts false
set_interface_property rx maximumPendingReadTransactions 0
set_interface_property rx maximumPendingWriteTransactions 0
set_interface_property rx readLatency 0
set_interface_property rx readWaitTime 1
set_interface_property rx setupTime 0
set_interface_property rx timingUnits Cycles
set_interface_property rx writeWaitTime 0
set_interface_property rx ENABLED true
set_interface_property rx EXPORT_OF ""
set_interface_property rx PORT_NAME_MAP ""
set_interface_property rx CMSIS_SVD_VARIABLES ""
set_interface_property rx SVD_ADDRESS_GROUP ""

add_interface_port rx avm_rx_waitrequest waitrequest Input 1
add_interface_port rx avm_rx_burstcount burstcount Output 12
add_interface_port rx avm_rx_address address Output 32
add_interface_port rx avm_rx_read read Output 1
add_interface_port rx avm_rx_readdata readdata Input 32
add_interface_port rx avm_rx_readdatavalid readdatavalid Input 1


# 
# connection point tx
# 
add_interface tx avalon start
set_interface_property tx addressUnits SYMBOLS
set_interface_property tx associatedClock clk
set_interface_property tx associatedReset reset
set_interface_property tx bitsPerSymbol 8
set_interface_property tx burstOnBurstBoundariesOnly false
set_interface_property tx burstcountUnits WORDS
set_interface_property tx doStreamReads false
set_interface_property tx doStreamWrites false
set_interface_property tx holdTime 0
set_interface_property tx linewrapBursts false
set_interface_property tx maximumPendingReadTransactions 0
set_interface_property tx maximumPendingWriteTransactions 0
set_interface_property tx readLatency 0
set_interface_property tx readWaitTime 1
set_interface_property tx setupTime 0
set_interface_property tx timingUnits Cycles
set_interface_property tx writeWaitTime 0
set_interface_property tx ENABLED true
set_interface_property tx EXPORT_OF ""
set_interface_property tx PORT_NAME_MAP ""
set_interface_property tx CMSIS_SVD_VARIABLES ""
set_interface_property tx SVD_ADDRESS_GROUP ""

add_interface_port tx avm_tx_burstcount burstcount Output 12
add_interface_port tx avm_tx_address address Output 32
add_interface_port tx avm_tx_write write Output 1
add_interface_port tx avm_tx_writedata writedata Output 32
add_interface_port tx avm_tx_waitrequest waitrequest Input 1


# 
# connection point debug_out_1
# 
add_interface debug_out_1 conduit end
set_interface_property debug_out_1 associatedClock clk
set_interface_property debug_out_1 associatedReset reset
set_interface_property debug_out_1 ENABLED true
set_interface_property debug_out_1 EXPORT_OF ""
set_interface_property debug_out_1 PORT_NAME_MAP ""
set_interface_property debug_out_1 CMSIS_SVD_VARIABLES ""
set_interface_property debug_out_1 SVD_ADDRESS_GROUP ""

add_interface_port debug_out_1 debug_out debug_out Output 32


# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 100000000
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point clk_x2
# 
add_interface clk_x2 clock end
set_interface_property clk_x2 clockRate 200000000
set_interface_property clk_x2 ENABLED true
set_interface_property clk_x2 EXPORT_OF ""
set_interface_property clk_x2 PORT_NAME_MAP ""
set_interface_property clk_x2 CMSIS_SVD_VARIABLES ""
set_interface_property clk_x2 SVD_ADDRESS_GROUP ""

add_interface_port clk_x2 clk_x2 clk Input 1


# 
# connection point clk_div2
# 
add_interface clk_div2 clock end
set_interface_property clk_div2 clockRate 50000000
set_interface_property clk_div2 ENABLED true
set_interface_property clk_div2 EXPORT_OF ""
set_interface_property clk_div2 PORT_NAME_MAP ""
set_interface_property clk_div2 CMSIS_SVD_VARIABLES ""
set_interface_property clk_div2 SVD_ADDRESS_GROUP ""

add_interface_port clk_div2 clk_div2 clk Input 1


# 
# connection point hdmi
# 
add_interface hdmi conduit end
set_interface_property hdmi associatedClock clk
set_interface_property hdmi associatedReset reset
set_interface_property hdmi ENABLED true
set_interface_property hdmi EXPORT_OF ""
set_interface_property hdmi PORT_NAME_MAP ""
set_interface_property hdmi CMSIS_SVD_VARIABLES ""
set_interface_property hdmi SVD_ADDRESS_GROUP ""

add_interface_port hdmi hdmi_i2c_sda_in sda_in Input 1
add_interface_port hdmi hdmi_i2c_sda_out sda_out Output 1
add_interface_port hdmi hdmi_i2c_sda_oe sda_oe Output 1
add_interface_port hdmi hdmi_i2c_scl i2c_scl Output 1
add_interface_port hdmi hdmi_i2s i2s Output 1
add_interface_port hdmi hdmi_lrclk lrck Output 1
add_interface_port hdmi hdmi_mclk mclk Output 1
add_interface_port hdmi hdmi_sclk sclk Output 1
add_interface_port hdmi hdmi_tx_clk tx_clk Output 1
add_interface_port hdmi hdmi_tx_d tx_d Output 24
add_interface_port hdmi hdmi_tx_de tx_de Output 1
add_interface_port hdmi hdmi_tx_hs tx_hs Output 1
add_interface_port hdmi hdmi_tx_vs tx_vs Output 1
add_interface_port hdmi hdmi_tx_int tx_int Input 1


# 
# connection point adc
# 
add_interface adc conduit end
set_interface_property adc associatedClock clk
set_interface_property adc associatedReset reset
set_interface_property adc ENABLED true
set_interface_property adc EXPORT_OF ""
set_interface_property adc PORT_NAME_MAP ""
set_interface_property adc CMSIS_SVD_VARIABLES ""
set_interface_property adc SVD_ADDRESS_GROUP ""

add_interface_port adc adc_convst convst Output 1
add_interface_port adc adc_sck sck Output 1
add_interface_port adc adc_sdo sdo Input 1
add_interface_port adc adc_sdi sdi Output 1


# 
# connection point arduino
# 
add_interface arduino conduit end
set_interface_property arduino associatedClock clk
set_interface_property arduino associatedReset reset
set_interface_property arduino ENABLED true
set_interface_property arduino EXPORT_OF ""
set_interface_property arduino PORT_NAME_MAP ""
set_interface_property arduino CMSIS_SVD_VARIABLES ""
set_interface_property arduino SVD_ADDRESS_GROUP ""

add_interface_port arduino arduino_io_out io_out Output 16
add_interface_port arduino arduino_io_oe io_oe Output 16
add_interface_port arduino arduino_io_in io_in Input 16
add_interface_port arduino arduino_reset_n reset_n Input 1


# 
# connection point gpio
# 
add_interface gpio conduit end
set_interface_property gpio associatedClock clk
set_interface_property gpio associatedReset reset
set_interface_property gpio ENABLED true
set_interface_property gpio EXPORT_OF ""
set_interface_property gpio PORT_NAME_MAP ""
set_interface_property gpio CMSIS_SVD_VARIABLES ""
set_interface_property gpio SVD_ADDRESS_GROUP ""

add_interface_port gpio gpio_in in Input 72
add_interface_port gpio gpio_out out Output 72
add_interface_port gpio gpio_oe oe Output 72


# 
# connection point key
# 
add_interface key conduit end
set_interface_property key associatedClock clk
set_interface_property key associatedReset reset
set_interface_property key ENABLED true
set_interface_property key EXPORT_OF ""
set_interface_property key PORT_NAME_MAP ""
set_interface_property key CMSIS_SVD_VARIABLES ""
set_interface_property key SVD_ADDRESS_GROUP ""

add_interface_port key key in Input 2


# 
# connection point led
# 
add_interface led conduit end
set_interface_property led associatedClock clk
set_interface_property led associatedReset reset
set_interface_property led ENABLED true
set_interface_property led EXPORT_OF ""
set_interface_property led PORT_NAME_MAP ""
set_interface_property led CMSIS_SVD_VARIABLES ""
set_interface_property led SVD_ADDRESS_GROUP ""

add_interface_port led led out Output 8


# 
# connection point sw
# 
add_interface sw conduit end
set_interface_property sw associatedClock clk
set_interface_property sw associatedReset reset
set_interface_property sw ENABLED true
set_interface_property sw EXPORT_OF ""
set_interface_property sw PORT_NAME_MAP ""
set_interface_property sw CMSIS_SVD_VARIABLES ""
set_interface_property sw SVD_ADDRESS_GROUP ""

add_interface_port sw sw in Input 4

