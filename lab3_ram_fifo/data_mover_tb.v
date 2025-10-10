// Define time unit (1ns) with time precision (1ps) for simulation (#1 would be delay of 1ns)
`timescale 1ns/1ps

// Declare top testbench module
module data_mover_tb;

reg clk;
reg rstn;
reg enable;


wire [4:0]  ram_addr;
wire [15:0] ram_data_in;
wire        ram_wren;
wire [15:0] ram_data_out;

ram	ram_inst (
    .address    ( ram_addr ),
    .clock      ( clk ),
    .data       ( ram_data_in ),
    .wren       ( ram_wren ),
    .q          ( ram_data_out )
);

wire [15:0] fifo_data_in;
wire [15:0] fifo_data_out;
wire        fifo_empty;
wire        fifo_full;
wire        fifo_rdreq;
wire        fifo_wrreq;

assign fifo_rdreq = 1'b1 & ~fifo_empty;     // always read

fifo fifo_inst (
    .clock      ( clk ),
    .data       ( fifo_data_in ),
    .rdreq      ( fifo_rdreq ),
    .wrreq      ( fifo_wrreq ),
    .empty      ( fifo_empty ),
    .full       ( fifo_full ),
    .q          ( fifo_data_out )
);

data_mover  #( 
        .CLK_FREQ       (500),
        .UPDATE_PERIOD  (50) )  
    data_mover_int (
        .clock          ( clk ), 
        .rstn           ( rstn ),
        .enable         ( enable ),

        // port for reading from RAM
        .ram_addr       ( ram_addr ),
        .ram_data_in    ( ram_data_out ), 

        // port for writing to FIFO
        .fifo_data_out  ( fifo_data_in ),
        .fifo_wrreq     ( fifo_wrreq ),
        .fifo_full      ( fifo_full )
    );
    

initial begin
    $display("Lab3!");
    
    $monitor("%h", fifo_data_out);
    
    clk = 1'b0;
    rstn = 1'b0;
    enable = 1'b0;
    
    #2000 rstn = 1'b1;
    #2000 enable = 1'b1;
    $display("rstn = %b, enable = %b\n", rstn, enable);
    
    #2000 rstn = 1'b0;
    $display("rstn = %b, enable = %b\n", rstn, enable);
    #2000 rstn = 1'b1;
    $display("rstn = %b, enable = %b\n", rstn, enable);
    #2000 enable = 1'b0;
    $display("rstn = %b, enable = %b\n", rstn, enable);
    #2000 enable = 1'b1;
    $display("rstn = %b, enable = %b\n", rstn, enable);
    
    $stop;
end

always 
    #5 clk = !clk;

endmodule