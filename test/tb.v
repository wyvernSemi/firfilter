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

`timescale 1 ns / 1 ps

`define CLK_PERIOD_NS 10
`define SMPL_BITS     12
`define TAPS          127

`define ENDCOUNT      20000

`define PERIOD        150

module tb();

reg     clk;
wire    nreset;

integer count;

wire                     smplvalid;
wire    [`SMPL_BITS-1:0] sample;
wire                     opvalid;
wire    [`SMPL_BITS-1:0] out;

initial
begin
  clk                          = 1;
  count                        = 0;
  forever #(`CLK_PERIOD_NS/2) clk = ~clk;
end

always @(posedge clk)
begin
  count                        <= count + 1;
  
  $readmemh("tap127x12.hex", fir_i.taps);
  if (count == `ENDCOUNT)
  begin
    $stop;
  end
end

assign nreset                  = (count  < 10) ? 1'b0 : 1'b1;
assign smplvalid               = (count % `PERIOD == 16) ? 1'b1 : 1'b0;
assign sample                  = (count == 16) ? 12'h7ff : 12'h000;

  // -------------------------------------------------------
  // UUT
  // -------------------------------------------------------

  fir
  #(.SMPL_BITS                 (`SMPL_BITS),
    .TAPS                      (`TAPS)
  )
  fir_i
  (
    .clk                       (clk),
    .nreset                    (nreset),
    
    .reset                     (1'b0),

    .write                     (1'b0),
    .addr                      ({$clog2(`TAPS/2+1){1'b0}}),
    .wdata                     (32'h0),
    .rdata                     (),

    .smplvalid                 (smplvalid),
    .sample                    (sample),

    .opvalid                   (opvalid),
    .out                       (out)
  );

endmodule