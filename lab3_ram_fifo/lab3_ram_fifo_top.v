`include "defines.v"

// Top module declaration 

module lab3_ram_fifo_top(
    input           max10_clk1_50,
    
    // SEG7
    output  [7:0]   hex0,
    output  [7:0]   hex1,
    output  [7:0]   hex2,
    output  [7:0]   hex3,
    output  [7:0]   hex4,
    output  [7:0]   hex5,
    
    // KEY
    input   [1:0]   key,
    
    // LED
    output  [9:0]   ledr,
    
    // SW
    input   [9:0]   sw
);

reg rstn_q,  rstn_qq;

always @ (posedge max10_clk1_50) begin
    rstn_q <= key[0];
    rstn_qq <= rstn_q;
end

reg enable_q,  enable_qq;

always @ (posedge max10_clk1_50) begin
    enable_q <= sw[0];
    enable_qq <= enable_q;
end

wire [4:0]  ram_addr;
wire [15:0] ram_data_in;
wire        ram_wren;
wire [15:0] ram_data_out;

ram	ram_inst (
    .address    ( ram_addr ),
    .clock      ( max10_clk1_50 ),
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

assign ledr[0] = fifo_empty;
assign ledr[1] = fifo_full;

fifo fifo_inst (
    .clock      ( max10_clk1_50 ),
    .data       ( fifo_data_in ),
    .rdreq      ( fifo_rdreq ),
    .wrreq      ( fifo_wrreq ),
    .empty      ( fifo_empty ),
    .full       ( fifo_full ),
    .q          ( fifo_data_out )
);

data_mover  #( 
        .CLK_FREQ       (50000000),
        .UPDATE_PERIOD  (500) )  
    data_mover_int (
        .clock          ( max10_clk1_50 ), 
        .rstn       ( rstn_qq ),
        .enable     ( enable_qq ),

        // port for reading from RAM
        .ram_addr       ( ram_addr ),
        .ram_data_in    ( ram_data_out ), 

        // port for writing to FIFO
        .fifo_data_out  ( fifo_data_in ),
        .fifo_wrreq     ( fifo_wrreq ),
        .fifo_full      ( fifo_full )
    );

// 7 Segment Decoder module instantiation (HEX0)

seven_seg_decoder seven_seg_decoder_inst0 (
    .data_i     (`SYM_BLANK),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex0)
);

// 7 Segment Decoder module instantiation (HEX1)

seven_seg_decoder seven_seg_decoder_inst1 (
    .data_i     ({1'b0, fifo_data_out[3:0]}),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex1)
);

// 7 Segment Decoder module instantiation (HEX2)

seven_seg_decoder seven_seg_decoder_inst2 (
    .data_i     ({1'b0, fifo_data_out[7:4]}),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex2)
);

// 7 Segment Decoder module instantiation (HEX3)

seven_seg_decoder seven_seg_decoder_inst3 (
    .data_i     ({1'b0, fifo_data_out[11:8]}),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex3)
);

// 7 Segment Decoder module instantiation (HEX4)

seven_seg_decoder seven_seg_decoder_inst4 (
    .data_i     ({1'b0, fifo_data_out[15:12]}),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex4)
);

// 7 Segment Decoder module instantiation (HEX5)

seven_seg_decoder seven_seg_decoder_inst5 (
    .data_i     (`SYM_BLANK),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex5)
);



endmodule
