# PULPino_src
The source(rtl and tb) files are clone from the https://github.com/pulp-platform/pulpino with a little modification.

There is a spi_stim.txt file in the sumulation folder. Using the text file, we can run the "Hello_World!!!!! " behavior simulation on Vivado.
Text file can replaced with other programs which compiled with riscv-toolchain compiler (refer the pulpino github to know more).

There is a little bug in uart module when print the RX string, so I print the each uart character to observe the running result.
