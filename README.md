FIFO Memory Module in Verilog
This module implements a First-In First-Out (FIFO) Memory Module in Verilog HDL. This module is designed to manage data flow in digital systems where data needs to be processed in the order it was received.
The FIFO memory uses separate read and write pointers, overflow/underflow handling, and status indicators to support data integrity and efficient data handling.

Features
8-bit data width with configurable 16-entry depth
FIFO Status Flags: full, empty, threshold, overflow, underflow
Write and Read Pointers: Separate read and write pointers to track data flow
Parameterized Design: Supports expansion for various data widths and depths
Status Signal Module: Indicates FIFO conditions (full, empty, threshold)

Module Descriptions
fifo_mem: Top-level module integrating all submodules.
memory_array: Stores 8-bit data in a 16-entry memory block.
write_pointer: Manages write pointer and controls write enable.
read_pointer: Manages read pointer and controls read enable.
status_signal: Manages FIFO flags (full, empty, threshold, overflow, underflow).

I/O Signals
Inputs:

clk: Clock signal
rst_n: Active-low reset
wr: Write enable
rd: Read enable
data_in: 8-bit data input
Outputs:

data_out: 8-bit data output
fifo_full: Flag indicating FIFO is full
fifo_empty: Flag indicating FIFO is empty
fifo_threshold: Indicates FIFO has reached a set threshold
fifo_overflow: Indicates write attempt when FIFO is full
fifo_underflow: Indicates read attempt when FIFO is empty
