# firfilter

## Verilog Finite Impulse Response Filter

HDL for a configurable FIR, with definable number of tap coefficients and input number of bits. The parameters are:

* <tt>TAPS</tt> : number of taps
* <tt>SMPL_BITS</tt> : Number of bits of input and output data

The FIR module has the following form:

![](http://www.anita-simulators.org.uk/wyvernsemi/articles/images/fir_block.png)

The logic uses a single multiply and accumulate fucnction, iterated once per clock when a new input sample arrives, giving a calculation time of <tt>TAPS</tt>+3 clock cycles. The module has an active high sychronous reset input (in addition to power-on-reset, <tt>nreset</tt>). A memory mapped style port allows the internal tap coefficient to be updated. Only half the taps coeffcients are stored and these are indexed by <tt>addr</tt> from <tt>0</tt> to <tt>TAPS/2 - ~TAPS[0]</tt>, with the center tap at the highest index.

### Test Bench

A simple test bench is provided (in <tt>test/</tt>) which can generate an impulse or a sinewave. This test bench has the following user configurable parameters:


* <tt>CLK_FREQ_MHZ</tt>:        system clock frequency in MHz (real)
* <tt>SMPL_RATE_KHZ</tt>:       Sample frequency in KHz (real)
* <tt>IP_FREQ_KHZ</tt>:         Input signal sine wave frequency. Impulse when 0.0. (real)
* <tt>IP_PK_PK</tt>:            Input sign peak-to-peak magnitude (integer)
* <tt>SMPL_BITS</tt>:           Inputs sample bits, Q (integer)
* <tt>TAPS</tt>:                Number of FIR tap coefficients (integer)
* <tt>ENDCOUNT</tt>:            Number of clock cycles until end of test (integer)

The diagram below shows the general layout of the test bench:

![](http://www.anita-simulators.org.uk/wyvernsemi/articles/images/fir_tb.png)

### Synthesis

Synthesis scripts are also provided for reference (in <tt>de10-nano</tt>), with the <tt>build</tt> sub-directory containing a <tt>makefile</tt> to do the synthesis. This targets an Intel Cyclone V device ofr the de10-nano board using the Quartus tools. At a 100MHz clock frequency the module used 620 ALMs, with 1 DSP block and 2 M10K memory blocks.