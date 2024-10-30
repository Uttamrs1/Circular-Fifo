`timescale 1ns / 1ps

module fifo_mem(
    data_out,
    fifo_full,
    fifo_empty,
    fifo_threshold,
    fifo_overflow,
    fifo_underflow,
    clk,
    rst_n,
    wr,
    rd,
    data_in
);  
    input wr, rd, clk, rst_n;
    input [7:0] data_in;
    output [7:0] data_out;
    output fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow;

    wire [4:0] wptr, rptr;
    wire fifo_we, fifo_rd;

    write_pointer top1(
        .wptr(wptr), 
        .fifo_we(fifo_we), 
        .wr(wr), 
        .fifo_full(fifo_full), 
        .clk(clk), 
        .rst_n(rst_n)
    );

    read_pointer top2(
        .rptr(rptr), 
        .fifo_rd(fifo_rd), 
        .rd(rd), 
        .fifo_empty(fifo_empty), 
        .clk(clk), 
        .rst_n(rst_n)
    );

    memory_array top3(
        .data_out(data_out), 
        .data_in(data_in), 
        .clk(clk), 
        .fifo_we(fifo_we), 
        .wptr(wptr), 
        .rptr(rptr)
    );

    status_signal top4(
        .fifo_full(fifo_full), 
        .fifo_empty(fifo_empty), 
        .fifo_threshold(fifo_threshold), 
        .fifo_overflow(fifo_overflow), 
        .fifo_underflow(fifo_underflow), 
        .wr(wr), 
        .rd(rd), 
        .fifo_we(fifo_we), 
        .fifo_rd(fifo_rd), 
        .wptr(wptr), 
        .rptr(rptr), 
        .clk(clk), 
        .rst_n(rst_n)
    );

endmodule

module memory_array(
    data_out,
    data_in,
    clk,
    fifo_we,
    wptr,
    rptr
);  
    input [7:0] data_in;
    input clk, fifo_we;
    input [4:0] wptr, rptr;
    output [7:0] data_out;

    reg [7:0] data_out2[15:0];

    always @(posedge clk) begin
        if (fifo_we)   
            data_out2[wptr[3:0]] <= data_in;
    end  

    assign data_out = data_out2[rptr[3:0]];  
endmodule

module read_pointer(
    rptr,
    fifo_rd,
    rd,
    fifo_empty,
    clk,
    rst_n
);  
    input rd, fifo_empty, clk, rst_n;
    output [4:0] rptr;
    output fifo_rd;
    reg [4:0] rptr;

    assign fifo_rd = (~fifo_empty) & rd;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            rptr <= 5'b00000;
        else if (fifo_rd)
            rptr <= rptr + 5'b00001;
    end  
endmodule

module status_signal(
    fifo_full,
    fifo_empty,
    fifo_threshold,
    fifo_overflow,
    fifo_underflow,
    wr,
    rd,
    fifo_we,
    fifo_rd,
    wptr,
    rptr,
    clk,
    rst_n
);  
    input wr, rd, fifo_we, fifo_rd, clk, rst_n;
    input [4:0] wptr, rptr;
    output fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow;

    wire fbit_comp, overflow_set, underflow_set;
    wire pointer_equal;
    wire [4:0] pointer_result;

    reg fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow;

    assign fbit_comp = wptr[4] ^ rptr[4];
    assign pointer_equal = (wptr[3:0] == rptr[3:0]);
    assign pointer_result = wptr - rptr;
    assign overflow_set = fifo_full & wr;
    assign underflow_set = fifo_empty & rd;

    always @(*) begin
        fifo_full = fbit_comp & pointer_equal;
        fifo_empty = (~fbit_comp) & pointer_equal;
        fifo_threshold = (pointer_result[4] || pointer_result[3]) ? 1 : 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            fifo_overflow <= 0;
        else if (overflow_set && !fifo_rd)
            fifo_overflow <= 1;
        else if (fifo_rd)
            fifo_overflow <= 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            fifo_underflow <= 0;
        else if (underflow_set && !fifo_we)
            fifo_underflow <= 1;
        else if (fifo_we)
            fifo_underflow <= 0;
    end
endmodule

module write_pointer(
    wptr,
    fifo_we,
    wr,
    fifo_full,
    clk,
    rst_n
);  
    input wr, fifo_full, clk, rst_n;
    output [4:0] wptr;
    output fifo_we;
    reg [4:0] wptr;

    assign fifo_we = (~fifo_full) & wr;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            wptr <= 5'b00000;
        else if (fifo_we)
            wptr <= wptr + 5'b00001;
    end  
endmodule