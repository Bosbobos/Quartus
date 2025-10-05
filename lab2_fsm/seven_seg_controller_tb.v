`include "defines.v"


// Define time unit (1ns) with time precision (1ps) for simulation (#1 would be delay of 1ns)
`timescale 1ns/1ps

// Declare top testbench module
module seven_seg_controller_tb;

    
reg clk;
reg rstn;
reg enable;

wire [5*6-1 : 0] symbols_array;

seven_seg_controller #( 
        .CLK_FREQ       (500),
        .UPDATE_PERIOD  (50),
        .SYMBOL_SIZE    (5),
        .DISPLAY_LENGTH (6) ) 
    seven_seg_controller_inst (
        .clk             (clk), 
        .rstn            (rstn),
        .enable          (enable),
        .symbols_array   (symbols_array)
    );
    
    
wire [7:0] hex0_data;
wire [7:0] hex1_data;
wire [7:0] hex2_data;
wire [7:0] hex3_data;
wire [7:0] hex4_data;
wire [7:0] hex5_data;

function [7:0] symbol2asci;
    input [4:0] symbol;
    begin
        case (symbol)
            {1'b0, 4'h0}:   symbol2asci = "0";
            {1'b0, 4'h1}:   symbol2asci = "1";
            {1'b0, 4'h2}:   symbol2asci = "2";
            {1'b0, 4'h3}:   symbol2asci = "3";
            {1'b0, 4'h4}:   symbol2asci = "4";
            {1'b0, 4'h5}:   symbol2asci = "5";
            {1'b0, 4'h6}:   symbol2asci = "6";
            {1'b0, 4'h7}:   symbol2asci = "7";
            {1'b0, 4'h8}:   symbol2asci = "8";
            {1'b0, 4'h9}:   symbol2asci = "9";
            {1'b0, 4'hA}:   symbol2asci = "A";
            {1'b0, 4'hB}:   symbol2asci = "B";
            {1'b0, 4'hC}:   symbol2asci = "C";
            {1'b0, 4'hD}:   symbol2asci = "D";
            {1'b0, 4'hE}:   symbol2asci = "E";
            {1'b0, 4'hF}:   symbol2asci = "F";
            // symbols
            `SYM_H      :   symbol2asci = "H";  
            `SYM_E      :   symbol2asci = "E";  
            `SYM_L      :   symbol2asci = "L";  
            `SYM_O      :   symbol2asci = "O";  
            `SYM_P      :   symbol2asci = "P";  
            `SYM__      :   symbol2asci = "_";  
            `SYM_BLANK  :   symbol2asci = " ";  
            
            default: symbol2asci = " ";
        
        endcase    
    end
endfunction
    
assign hex0_data = symbol2asci(symbols_array[4:0]);
assign hex1_data = symbol2asci(symbols_array[9:5]);
assign hex2_data = symbol2asci(symbols_array[14:10]);
assign hex3_data = symbol2asci(symbols_array[19:15]);
assign hex4_data = symbol2asci(symbols_array[24:20]);
assign hex5_data = symbol2asci(symbols_array[29:25]);
    
initial begin
    $display("Lab2!");
    
    clk = 1'b0;
    rstn = 1'b0;
    enable = 1'b0;
    
    $display("rstn = %b, enable = %b\n", rstn, enable);
    $monitor("%s%s%s%s%s%s", hex5_data, hex4_data, hex3_data, hex2_data, hex1_data, hex0_data);
    
    #100 rstn = 1'b1;
    $display("\nrstn = %b, enable = %b\n", rstn, enable);
    #100 enable = 1'b1;
    $display("\nrstn = %b, enable = %b\n", rstn, enable);
    
    #5000 rstn = 1'b0;
    $display("\nrstn = %b, enable = %b\n", rstn, enable);
    #5000 rstn = 1'b1;
    $display("\nrstn = %b, enable = %b\n", rstn, enable);
    #5000 enable = 1'b0;
    $display("\nrstn = %b, enable = %b\n", rstn, enable);
    #5000 enable = 1'b1;
    $display("\nrstn = %b, enable = %b\n", rstn, enable);
    
    
    
    #5000 $stop;
end


always 
    #5 clk = !clk;


endmodule