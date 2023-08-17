// -----------------------------------------------------------------------------
//  Title      : Top level of core logic
//  Project    : FIR
// -----------------------------------------------------------------------------
//  File       : core.v
//  Author     : Simon Southwell
//  Created    : 2023-08-16
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the project specific core logic top level, as instantiated
//  in QSYS.
// -----------------------------------------------------------------------------
//  Copyright (c) 2023 Simon Southwell
// -----------------------------------------------------------------------------
//
//  This is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  It is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this code. If not, see <http://www.gnu.org/licenses/>.
//
// -----------------------------------------------------------------------------

`timescale 1ns / 10ps

module core
#(parameter CLK_FREQ_MHZ               = 100,
            SMPL_BITS                  = 12,
            TAPS                       = 127
)
(
    input            clk,
    input            clk_x2,
    input            clk_div2,
    input            reset_n,

    // ADC
    output           adc_convst,
    output           adc_sck,
    output           adc_sdi,
    input            adc_sdo,

    // ARDUINO
    output [15:0]    arduino_io_out,
    output [15:0]    arduino_io_oe,
    input  [15:0]    arduino_io_in,
    input            arduino_reset_n,

    // HDMI
    input            hdmi_i2c_sda_in,
    output           hdmi_i2c_sda_out,
    output           hdmi_i2c_sda_oe,
    output           hdmi_i2c_scl,
    output           hdmi_i2s,
    output           hdmi_lrclk,
    output           hdmi_mclk,
    output           hdmi_sclk,
    output           hdmi_tx_clk,
    output [23:0]    hdmi_tx_d,
    output           hdmi_tx_de,
    output           hdmi_tx_hs,
    output           hdmi_tx_vs,
    input            hdmi_tx_int,

    // GPIO
    input  [71:0]    gpio_in,
    output [71:0]    gpio_out,
    output [71:0]    gpio_oe,

    // Key
    input   [1:0]    key,

    // LED
    output  [7:0]    led,

    // Switch
    input   [3:0]    sw,

    // Avalon CSR slave interface
    input  [17:0]    avs_csr_address,
    input            avs_csr_write,
    input  [31:0]    avs_csr_writedata,
    input            avs_csr_read,
    output [31:0]    avs_csr_readdata,

    // Avalon Master burst read interface for FPGA configuration block
    input            avm_rx_waitrequest,
    output [11:0]    avm_rx_burstcount,
    output [31:0]    avm_rx_address,
    output           avm_rx_read,
    input  [31:0]    avm_rx_readdata,
    input            avm_rx_readdatavalid,

    // Avalon Master burst write interface for FPGA configuration block
    input            avm_tx_waitrequest,
    output [11:0]    avm_tx_burstcount,
    output [31:0]    avm_tx_address,
    output           avm_tx_write,
    output [31:0]    avm_tx_writedata,

    output [31:0]    debug_out
);

wire opvalid;

// ---------------------------------------------------------
// Local parameters
// ---------------------------------------------------------


// ---------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------

reg   [26:0] count;
reg          reset;

// ---------------------------------------------------------
// Tie off unused signals and ports
// ---------------------------------------------------------

assign avm_rx_burstcount               = 12'h0;
assign avm_rx_address                  = 32'h0;
assign avm_rx_read                     =  1'b0;

assign avm_tx_burstcount               = 12'h0;
assign avm_tx_address                  = 32'h0;
assign avm_tx_write                    =  1'b0;
assign avm_tx_writedata                = 32'h0;

assign adc_convst                      =  1'b0;
assign adc_sck                         =  1'b0;
assign adc_sdi                         =  1'b0;

assign arduino_io_out                  = 16'h0;
assign arduino_io_oe                   = 16'h0;

assign hdmi_i2c_sda_out                =  1'b0;
assign hdmi_i2c_sda_oe                 =  1'b0;
assign hdmi_i2c_scl                    =  1'b0;
assign hdmi_i2s                        =  1'b0;
assign hdmi_lrclk                      =  1'b0;
assign hdmi_mclk                       =  1'b0;
assign hdmi_sclk                       =  1'b0;
assign hdmi_tx_clk                     =  1'b0;
assign hdmi_tx_d                       = 23'h0;
assign hdmi_tx_de                      =  1'b0;
assign hdmi_tx_hs                      =  1'b0;
assign hdmi_tx_vs                      =  1'b0;

// Note that gpio[32:20] are used as outputs in the logic for this design
assign gpio_out[19:0]                  = 20'h0;
assign gpio_out[71:33]                 = 39'h0;
assign gpio_oe[19:13]                  =  7'h0;
assign gpio_oe[71:33]                  = 39'h0;

assign debug_out                       = 32'h0;

// ---------------------------------------------------------
// Combinatorial Logic
// ---------------------------------------------------------

// Flash the LEDs to visually check programming
assign led                             = {6'h0, ~count[26], count[26]};

assign gpio_oe[32:20]                  = {13{1'b1}};
assign gpio_oe[12:0]                   = {13{1'b0}};

// ---------------------------------------------------------
// Address decode
// ---------------------------------------------------------

wire write_fir_tap = ~avs_csr_address[12] & avs_csr_write;
wire write_reset   =  avs_csr_address[12] & avs_csr_write;


// ---------------------------------------------------------
// Local Synchronous Logic
// ---------------------------------------------------------

always @ (posedge clk)
begin
  if (~reset_n)
  begin
    count                              <= 0;
    reset                              <= 1'b0;
  end
  else
  begin
    count                              <= count + 27'd1;
    
    if (write_reset)
    begin
      reset                            <= avs_csr_writedata[0];
    end
  end
end

// ---------------------------------------------------------
// FIR
// ---------------------------------------------------------
  fir
  #(.SMPL_BITS                 (SMPL_BITS),
    .TAPS                      (TAPS)
  )
  fir_i
  (
    .clk                       (clk),
    .nreset                    (reset_n),
    
    .reset                     (reset),

    .write                     (write_fir_tap),
    .addr                      (avs_csr_address[$clog2(TAPS/2+1)-1:0]),
    .wdata                     (avs_csr_writedata),
    .rdata                     (avs_csr_readdata),

    .smplvalid                 (gpio_in[12]),
    .sample                    (gpio_in[11:0]),

    .opvalid                   (gpio_out[32]),
    .out                       (gpio_out[31:20])
  );

endmodule