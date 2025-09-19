module alu (
    input       [1:0]   operation_i,
    input       [3:0]   operand1_i,
    input       [3:0]   operand2_i,
        
    input               carry_in, // or borrow for substraction
        
    output  reg [3:0]   result_o, 
    
    output              zero,
    output  reg         carry_out // or borrow out (active low) for substraction
);

assign zero = (result_o == 4'b0);

localparam ADD_OP   =  2'b00;
localparam SUB_OP   =  2'b01;
localparam OR_OP    =  2'b10;
localparam AND_OP   =  2'b11;

// Временная переменная для хранения 5-битного результата (4 бита + перенос)
reg [4:0] temp_result;

always @* begin
    case (operation_i)
        ADD_OP: begin
            temp_result = operand1_i + operand2_i + carry_in;
            result_o = temp_result[3:0];
            carry_out = temp_result[4];
        end
        
        SUB_OP: begin
            // Вычитание: A - B - borrow_in = A + ~B + 1 - borrow_in
            // Поскольку borrow_in активен низким уровнем, используем ~borrow_in
            temp_result = operand1_i + (~operand2_i) + 1; // TODO: понять че не так
            result_o = temp_result[3:0];
            carry_out = ~temp_result[4]; // Для вычитания borrow out активен низким
        end
        
        OR_OP: begin
            result_o = operand1_i | operand2_i;
            carry_out = 1'b0; // Для логических операций перенос не используется
        end
        
        AND_OP: begin
            result_o = operand1_i & operand2_i;
            carry_out = 1'b0; // Для логических операций перенос не используется
        end
        
        default: begin 
            result_o = 4'h0;
            carry_out = 1'b0;
        end
    endcase
end

endmodule