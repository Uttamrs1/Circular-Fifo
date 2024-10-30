`timescale 1ns / 1ps 

`define DELAY 10  

module fifo_tb;  
parameter ENDTIME = 40000;  

reg clk;                  
reg rst_n;                
reg wr;                   
reg rd;                   
reg [7:0] data_in;       

wire [7:0] data_out;     
wire fifo_empty;         
wire fifo_full;          
wire fifo_threshold;     
wire fifo_overflow;      
wire fifo_underflow;     
integer i;               

fifo_mem dut(/*AUTOARG*/  
    data_out, fifo_full, fifo_empty, fifo_threshold, fifo_overflow,   
    fifo_underflow,   
    clk, rst_n, wr, rd, data_in  
);  

initial begin  
    clk = 1'b0;  
    rst_n = 1'b0;  
    wr = 1'b0;  
    rd = 1'b0;  
    data_in = 8'd0;  
end  

initial begin  
    main;  
end  

task main;  
    fork  
        clock_generator;   
        reset_generator;   
        operation_process; 
        debug_fifo;        
        endsimulation;     
    join  
endtask  

task clock_generator;  
    begin  
        forever #`DELAY clk = !clk;  
    end  
endtask  

task reset_generator;  
    begin  
        #(`DELAY * 2)      
        rst_n = 1'b1;      
        #7.9  
        rst_n = 1'b0;      
        #7.09  
        rst_n = 1'b1;      
    end  
endtask  

task operation_process;  
    begin  
        for (i = 0; i < 17; i = i + 1) begin: WRE  
            #(`DELAY * 5)  
            wr = 1'b1;      
            data_in = data_in + 8'd1;  
            #(`DELAY * 2)   
            wr = 1'b0;      
        end  

        #(`DELAY)  
        for (i = 0; i < 17; i = i + 1) begin: RDE  
            #(`DELAY * 2)   
            rd = 1'b1;      
            #(`DELAY * 2)   
            rd = 1'b0;      
        end  
    end  
endtask  

task debug_fifo;  
    begin  
        $display("----------------------------------------------");  
        $display("------------------   -----------------------");  
        $display("----------- SIMULATION RESULT ----------------");  
        $display("--------------       -------------------");  
        $display("----------------     ---------------------");  
        $display("----------------------------------------------");  
        $monitor("TIME = %d, wr = %b, rd = %b, data_in = %h", $time, wr, rd, data_in);  
    end  
endtask  

task endsimulation;  
    begin  
        #ENDTIME  
        $display("-------------- THE SIMULATION FINISHED ------------");  
        $finish;  
    end  
endtask  

endmodule  
