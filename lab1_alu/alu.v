module alu (
    input       [1:0] operation_i,
    input       [3:0] operand1_i,
    input       [3:0] operand2_i,
    
    output reg  [3:0] result_o
);

localparam ADD_OP   =  2'b00;
localparam SUB_OP   =  2'b01;
localparam OR_OP    =  2'b10;
localparam AND_OP   =  2'b11;

always @* begin

    case (operation_i)
        ADD_OP  : result_o = operand1_i + operand2_i;
        SUB_OP  : result_o = operand1_i + ~operand2_i + 1;
		  OR_OP   : result_o = operand1_i | operand2_i;
		  AND_OP  : result_o = operand1_i & operand2_i;
        default: result_o = 4'h0;
    endcase
   
end

endmodule