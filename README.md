FIFO Memory Module in Verilog
This module implements a First-In First-Out (FIFO) Memory Module in Verilog HDL. This module is designed to manage data flow in digital systems where data needs to be processed in the order it was received.
The FIFO memory uses separate read and write pointers, overflow/underflow handling, and status indicators to support data integrity and efficient data handling.
# FIFO Memory Design in Verilog

## Overview
This project implements a First-In-First-Out (FIFO) memory structure in Verilog. The FIFO allows for efficient data handling in applications where order of processing is crucial.

## Features
- 8-bit wide data input and output
- Status flags for full, empty, overflow, and underflow
- Modular design with clear separation of concerns
- Supports active low reset functionality

## Modules
### `fifo_mem`
The top-level module that integrates the various submodules to form a complete FIFO memory system.

### `memory_array`
Handles data storage and retrieval from the FIFO memory.

### `write_pointer`
Manages the write pointer to ensure data is written correctly.

### `read_pointer`
Handles the read pointer logic and ensures data integrity during reads.

### `status_signal`
Tracks and updates the status of the FIFO.

FIFO Full (fifo_full)
Description: Indicates that the FIFO has reached its maximum capacity and cannot accept any more data until some is read out.
Condition: This signal is asserted (set to high) when the write pointer (wptr) and the read pointer (rptr) are in the same state for the most significant bit (MSB) while the lower bits of the pointers are equal.

FIFO Empty (fifo_empty)
Description: Indicates that the FIFO contains no data and cannot be read.
Condition: This signal is asserted when the MSB of the write pointer (wptr) and the read pointer (rptr) are the same, and the lower bits of the pointers are equal.
Implication: When fifo_empty is high, any read operation will return an undefined value or an error, and the system must wait until data is written to the FIFO.

FIFO Threshold (fifo_threshold)
Description: Indicates that the number of elements in the FIFO has reached a predefined threshold, which can be useful for flow control in systems that use the FIFO.
Condition: This signal is set based on the difference between the write and read pointers. If the difference exceeds a specific limit (like half the FIFO size), fifo_threshold can be asserted.
Implication: When fifo_threshold is high, the system can take preemptive actions, such as slowing down the data input rate or generating alerts.

FIFO Overflow (fifo_overflow)
Description: Indicates that an attempt to write data into the FIFO was made when it was already full, leading to data loss or corruption.
Condition: This signal is asserted when a write request is made while fifo_full is already high.
Implication: When fifo_overflow is high, it typically indicates a design error or an unexpected condition in the data flow, and corrective measures need to be taken (like discarding the new data).

FIFO Underflow (fifo_underflow)
Description: Indicates that an attempt to read data from the FIFO was made when it was empty, which can also lead to errors in data handling.
Condition: This signal is asserted when a read request is made while fifo_empty is high.
Implication: When fifo_underflow is high, it suggests that there may be an issue with the timing or flow of data, and the system should ensure that data is available before attempting to read.

