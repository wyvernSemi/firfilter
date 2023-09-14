// -----------------------------------------------------------------------------
//  Title      : FIR test bench
//  Project    : fir
// -----------------------------------------------------------------------------
//  File       : fir.v
//  Author     : Simon Southwell
//  Created    : 2023-08-14
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//    This block defines top level test bench for the FIR
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
//  User definable parameters:
//
//     CLK_FREQ_MHZ:        system clock frequency in MHz (real)
//     SMPL_RATE_KHZ:       Sample frequency in KHz (real)
//     IP_FREQ_KHZ:         Input signal sine wave frequency. Impulse when 0.0. (real)
//     IP_PK_PK:            Input sign peak-to-peak magnitude (integer)
//     SMPL_BITS:           Inputs sample bits, Q (integer)
//     TAPS:                Number of FIR tap coefficients (integer)
//     ENDCOUNT:            Number of clock cycles until end of test (integer)
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Time scale of test bench. Must have ps scale for accuracy.
// -----------------------------------------------------------------------------

`timescale 1 ps / 1 ps

// -----------------------------------------------------------------------------
// Defines
// -----------------------------------------------------------------------------
`ifndef TAPSFNAME
`define TAPSFNAME "tap127x12.hex"
`endif

// =============================================================================
// Test bench
// =============================================================================

module tb
#(parameter
   CLK_FREQ_MHZ                = 96.0,
   SMPL_RATE_KHZ               = 192.0,
   IP_FREQ_KHZ                 = 15.0,
   IP_PK_PK                    = 2048,
   SMPL_BITS                   = 12,
   TAPS                        = 127,
   ENDCOUNT                    = 70000
)
();

// -----------------------------------------------------------------------------
// Local parameters
// -----------------------------------------------------------------------------

// 2 * pi

localparam TWOPI               = 2.0*3.14159265358979323;

// Calculate the clock period in picoseconds
localparam CLK_PERIOD_PS       = (1000000/CLK_FREQ_MHZ);

// Calculate the input sinewave's period in clock periods (real)
localparam PERIODCLKS          = (1000.0 * CLK_FREQ_MHZ)/SMPL_RATE_KHZ;

// -----------------------------------------------------------------------------
// State declarations
// -----------------------------------------------------------------------------

reg                            clk;

integer                        count;
real                           sinewave;
real                           sinewave_smpl;
real                           sineperiodclks;
integer                        int_ip_period;
integer                        int_smpl_period;
reg                            smplvalid;

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

wire                           nreset;
wire                           nextsmplvalid;
wire [SMPL_BITS-1:0]           sample;
wire                           opvalid;
wire [SMPL_BITS-1:0]           out;

// -----------------------------------------------------------------------------
// Combinatorial logic
// -----------------------------------------------------------------------------

// Generate a reset for 10 cycles
assign nreset                  = (count  < 10) ? 1'b0 : 1'b1;

// The next samplevaid pulse is ever int_smpl_period clocks (when not resetting)
assign nextsmplvalid           = (count % int_smpl_period == 0) ? nreset : 1'b0;

// The sample input signal is either an impulse (if IP_FREQ_KHZ is 0) or 
// the generated and sample sine wave
assign sample                  = (IP_FREQ_KHZ == 0.0) ? (smplvalid && count < 1000 ? 12'h7ff : 12'h000) :
                                 sinewave_smpl;

// -----------------------------------------------------------------------------
// Initial process
// -----------------------------------------------------------------------------
initial
begin
  clk                          = 1;
  count                        = 0;
  
  // Sine wave period in clock cycles (real)
  if (IP_FREQ_KHZ != 0.0)
    sineperiodclks             = $ceil(1.0/(1000.0 * IP_FREQ_KHZ * CLK_PERIOD_PS * 1E-12));

  
  // Convert sineperiodclks to an integer value
  int_ip_period                = sineperiodclks;
  
  // Convert smaple period real parameter to an integer
  int_smpl_period              = PERIODCLKS;
  
  // Load the impulse crespone coefficient to tap LUT
  $readmemh(`TAPSFNAME, fir_i.taps);
  
  // Generate the clock
  forever #(CLK_PERIOD_PS/2) clk = ~clk;
end

// -----------------------------------------------------------------------------
// Synchronous process
// -----------------------------------------------------------------------------

always @(posedge clk)
begin
  count                        <= count + 1;
  smplvalid                    <= nextsmplvalid;

  // Generate a sine wave (when not a delta function selected).
  if (IP_FREQ_KHZ != 0.0)
    sinewave                   <= IP_PK_PK/2.0 * $sin(TWOPI * (count%int_ip_period) / sineperiodclks);

  // Sample the sine wave
  if (nextsmplvalid)
  begin
    sinewave_smpl              <= sinewave;
  end

  if (count == ENDCOUNT)
  begin
    $stop;
  end
end

// -------------------------------------------------------
// UUT
// -------------------------------------------------------

  fir
  #(.SMPL_BITS                 (SMPL_BITS),
    .TAPS                      (TAPS)
  )
  fir_i
  (
    .clk                       (clk),
    .nreset                    (nreset),

    .reset                     (1'b0),

    .write                     (1'b0),
    .addr                      ({$clog2(TAPS/2+1){1'b0}}),
    .wdata                     (32'h0),
    .rdata                     (),

    .smplvalid                 (smplvalid),
    .sample                    (sample),

    .opvalid                   (opvalid),
    .out                       (out)
  );

endmodule