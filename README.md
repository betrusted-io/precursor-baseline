# Precursor Baseline

A SoC that has just the features necessary to drive the hardware on the board,
and nothing else (such as hardware accelerators for crypto). Removing the
crypto accelerators brings the design from about 80% utilization down to 20%.

Mainline development happens on
[betrusted-soc](https://github.com/betrusted-io/betrusted-soc). This
is a stripped-down derivate of the design.  Please refer to the
betrusted-soc repository for instructions on how to install and build
toolchains.

It's also a good idea to check betrusted-soc for any bug fixes or updates
that have yet to percolate into the Precursor Baseline template.

