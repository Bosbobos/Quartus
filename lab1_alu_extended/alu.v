module alu (
    input       [1:0]   operation_i,
    input       [3:0]   operand1_i,
    input       [3:0]   operand2_i,

    input               carry_in,    // or borrow for substraction

    output  reg [3:0]   result_o, 
    output              zero,        
    output  reg         carry_out    // or borrow out (active low) for substraction
);

localparam ADD_OP   = 2'b00;
localparam SUB_OP   = 2'b01;
localparam OR_OP    = 2'b10;
localparam AND_OP   = 2'b11;

reg [4:0] temp; // Временная переменная для хранения 5-битного результата (4 бита + перенос)

always @* begin
    // значения по умолчанию
    result_o  = 4'h0;
    carry_out = 1'b0;
    temp       = 5'd0;

    case (operation_i)

        // ---------- СЛОЖЕНИЕ: A + B + carry_in ----------
        ADD_OP: begin
            temp      = {1'b0, operand1_i} + {1'b0, operand2_i} + {4'b0, carry_in};
            result_o = temp[3:0];
            carry_out= temp[4];                // перенос из старшего разряда
        end

        // ---------- ВЫЧИТАНИЕ: A - B - borrow_in ----------
        // A - B - bin = A + ~B + (1 - bin)  => прибавляем ~carry_in вместо 1
        // tmp[4] тут = 1  => заимствования НЕТ (no-borrow)
        // Требование твоего TB: carry_out = 1 если заимствование БЫЛО -> инвертируем.
        SUB_OP: begin
            temp      = {1'b0, operand1_i} + {1'b0, ~operand2_i} + {4'b0, ~carry_in};
            result_o = temp[3:0];
            carry_out= ~temp[4];               // 1 => borrow был, 0 => borrow не было
        end

        OR_OP: begin
            result_o  = operand1_i | operand2_i;
            carry_out = 1'b0;
        end
		  
        AND_OP: begin
            result_o  = operand1_i & operand2_i;
            carry_out = 1'b0;
        end

        default: begin
            result_o  = 4'h0;
            carry_out = 1'b0;
        end
    endcase
end

// Флаг нулевого результата
assign zero = (result_o == 4'h0);

endmodule