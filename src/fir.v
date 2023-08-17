// -----------------------------------------------------------------------------
//  Title      : Finite Impulse Response Filter
//  Project    : fir
// -----------------------------------------------------------------------------
//  File       : fir.v
//  Author     : Simon Southwell
//  Created    : 2023-08-14
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines an M bit by N tap FIR implementation using a single
//  multiply accumulate function. Each convolution takes N + 4 clock cycles,
//  so, for example, a 127 tap FIR at 100MHz clock has a max rate of 763Ksps.
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

`timescale 1 ns/1 ps

module fir
#(parameter
   SMPL_BITS                   = 12,
   TAPS                        = 127
)
(
  input                        clk,
  input                        nreset,

  // External synchronous reset
  input                        reset,

  // Memory mapped bus subordinate interface
  input                        write,
  input  [$clog2(TAPS/2+1)-1:0]addr,
  input  [31:0]                wdata,
  output reg [31:0]            rdata,

  // Input data
  input                        smplvalid,
  input  [SMPL_BITS-1:0]       sample,

  // Output data
  output reg                   opvalid,
  output reg [SMPL_BITS-1:0]   out

);

reg         [TAPS-1:0]         smplsvalid;
reg signed  [SMPL_BITS-1:0]    smpls [0:TAPS-1];
reg signed  [SMPL_BITS:0]      taps  [0:((TAPS+1)/2)-1];
reg         [$clog2(TAPS)-1:0] count;
reg         [$clog2(TAPS)-1:0] countdlyd;
reg                            rdtap;
reg                            lastcycle;

// The extracted TAP value
reg signed  [SMPL_BITS:0]      tapval;

// Extracted validated sample, non-zero only when reading a tap and sample buffer entry valid
reg signed  [SMPL_BITS-1:0]    validsample;

// Accumulated result
reg signed  [SMPL_BITS*2-1:0]  accum;

integer                        idx;

// TAP index to go from 0 to TAPS/2 and back down again so only half the
// impluse repsonse need be stored, as it's symmetrical
wire        [$clog2(TAPS)-1:0] tapidx = (countdlyd > (TAPS+1)/2-1) ? ~countdlyd : count[$clog2(TAPS)-2:0];

// -----------------------------------------------------------------------------
// Synchronous process
// -----------------------------------------------------------------------------

always @(posedge clk)
begin

  // Reset state at POR or if requested externally.
  if (nreset == 1'b0 || reset == 1'b1)
  begin
    smplsvalid                 <= {TAPS{1'b0}};
    count                      <= 0;
    countdlyd                  <= 0;
    rdtap                      <= 1'b0;
    lastcycle                   <= 1'b0;
    accum                      <= 0;
  end
  else
  begin
    // Default is that output is not valid
    opvalid                    <= 1'b0;
    rdata                      <= 32'h0;
    lastcycle                  <= (countdlyd == 1);

    // Update tap values over bus
    if (write)
    begin
      taps[addr]               <= wdata[SMPL_BITS:0];
    end

    // Return TAP values
    rdata[SMPL_BITS:0]         <= taps[addr];

    // New input sample arrived
    if (smplvalid == 1'b1)
    begin
      // Initialise count and accumulator ready to convolve samples across taps
      count                    <= TAPS;
      accum                    <= 0;

      // Mark sample entry as valid
      smplsvalid               <= {1'b1, smplsvalid[TAPS-1:1]};

      // Add new sample to sample shift register and shift all other values
      // down one place
      smpls[TAPS-1]            <= sample;
      for (idx = TAPS-1; idx > 0; idx = idx - 1)
      begin
        smpls[idx-1]           <= smpls[idx];
      end
    end

    // Generate a delayed version of the count for timing
    // alignment and save on an adder
    countdlyd                  <= count;

    // Mark tap values valid when count is active
    rdtap                      <= |count;

    // Whilst count active (non-zero), decrement it and save register
    // multiply-accumulatoin value
    if (count)
    begin
      count                    <= count - 1;
    end

    // Extract indexed tap value
    tapval                     <= taps[tapidx];

    // Extract validated sample, non-zero only when reading a tap and sample buffer entry valid
    validsample                <= (rdtap & smplsvalid[count]) ? smpls[count] : 0;

    // Whilst convolution active, accumulate the tap x input sample values
    if(countdlyd)
    begin
      // Multiply and accumulate function
      accum                    <= (tapval * validsample) + accum;
    end

    // When last cycle (delayed) update output and set valid signal.
    if (lastcycle)
    begin
      // Rescale output using accum top bits, rounded
      out                      <= accum[SMPL_BITS*2-1:SMPL_BITS-1] + accum[SMPL_BITS-2];
      opvalid                  <= 1'b1;
    end
  end
end

endmodule