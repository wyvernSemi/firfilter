# Create clean libraries
foreach lib [list work] {
  file delete -force -- $lib
  vlib $lib
}

# Compile the code into the appropriate libraries
do compile.do

# Run the tests
vsim -quiet tb -l sim.log
do wave.do
run -all

# Exit the simulations
#quit
