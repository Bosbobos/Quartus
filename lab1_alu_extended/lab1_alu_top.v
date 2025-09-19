// Top module declaration 

module lab1_alu_top(
    
    // SEG7
    output  [7:0]   hex0,
    output  [7:0]   hex1,
    output  [7:0]   hex2,
    output  [7:0]   hex3,
    output  [7:0]   hex4,
    output  [7:0]   hex5,
    
    // KEY
    input   [1:0]   key,    // active low
    
    // LED
    output  [9:0]   ledr,   // active high
    
    // SW
    input   [9:0]   sw
);

// wire declaration

wire [3:0] result;
wire [3:0] operand1;
wire [3:0] operand2;
wire [1:0] operation;


// wire FPGA inputs to our signals (for simplicity)
assign operation    = sw[1:0];
assign operand1     = sw[9:6];
assign operand2     = sw[5:2];

//wire our signals to FPGA outputs 
assign ledr[1:0] = operation;
assign ledr[7:2] = 6'h00; // hign-active signal


// ALU module instantiation

alu alu_inst (
    .operation_i    (operation),
    .operand1_i     (operand1),
    .operand2_i     (operand2),
    
    .carry_in       (~key[0]),
    
    .zero           (ledr[9]),
    .carry_out      (ledr[8]),
    
    .result_o       (result)
);


// 7 Segment Decoder module instantiation (HEX0) - 4bit result

seven_seg_decoder seven_seg_decoder_inst0 (
    .data_i     (result),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex0)
);

// 7 Segment Decoder module instantiation (HEX1) - zero (we have only 4bit operand and result)

seven_seg_decoder seven_seg_decoder_inst1 (
    .data_i     (4'b0),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex1)
);

// 7 Segment Decoder module instantiation (HEX2) - 4bit second operand

seven_seg_decoder seven_seg_decoder_inst2 (
    .data_i     (operand2),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex2)
);

// 7 Segment Decoder module instantiation (HEX3) - zero (we have only 4bit operand and result)

seven_seg_decoder seven_seg_decoder_inst3 (
    .data_i     (4'b0),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex3)
);

// 7 Segment Decoder module instantiation (HEX4) - 4bit first operand

seven_seg_decoder seven_seg_decoder_inst4 (
    .data_i     (operand1),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex4)
);

// 7 Segment Decoder module instantiation (HEX5) - zero (we have only 4bit operand and result)

seven_seg_decoder seven_seg_decoder_inst5 (
    .data_i     (4'b0),
    .dot_i      (1'b1), // segments in seven segment indicator are low-active
    
    .result_o   (hex5)
);



endmodule
