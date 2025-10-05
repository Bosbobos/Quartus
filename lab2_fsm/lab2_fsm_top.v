// Top module declaration 

module lab2_fsm_top(
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

wire [5*6 - 1 : 0] symbols_array;

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

seven_seg_controller #( 
        .CLK_FREQ       (50000000),
        .UPDATE_PERIOD  (500),
        .SYMBOL_SIZE    (5),
        .DISPLAY_LENGTH (6) ) 
    seven_seg_controller_inst (
        .clk             (max10_clk1_50), 
        .rstn            (rstn_qq),
        .enable          (enable_qq),
        .symbols_array   (symbols_array)
    );

// 7 Segment Decoder module instantiation (HEX0)

seven_seg_decoder seven_seg_decoder_inst0 (
    .data_i     (symbols_array[4:0]),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex0)
);

// 7 Segment Decoder module instantiation (HEX1)

seven_seg_decoder seven_seg_decoder_inst1 (
    .data_i     (symbols_array[9:5]),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex1)
);

// 7 Segment Decoder module instantiation (HEX2)

seven_seg_decoder seven_seg_decoder_inst2 (
    .data_i     (symbols_array[14:10]),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex2)
);

// 7 Segment Decoder module instantiation (HEX3)

seven_seg_decoder seven_seg_decoder_inst3 (
    .data_i     (symbols_array[19:15]),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex3)
);

// 7 Segment Decoder module instantiation (HEX4)

seven_seg_decoder seven_seg_decoder_inst4 (
    .data_i     (symbols_array[24:20]),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex4)
);

// 7 Segment Decoder module instantiation (HEX5)

seven_seg_decoder seven_seg_decoder_inst5 (
    .data_i     (symbols_array[29:25]),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex5)
);



endmodule
