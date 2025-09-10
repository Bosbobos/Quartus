// Define time unit (1ns) with time precision (1ps) for simulation (#1 would be delay of 1ns)
`timescale 1ns/1ps

// Declare top testbench module
module alu_tb;

reg     [3:0]   operand1;
reg     [3:0]   operand2;
reg     [1:0]   operation;
    
wire    [3:0]   result;
    
integer         result_ref;

// ALU design under test instantiation

alu alu_dut_inst (
    .operation_i    (operation),
    .operand1_i     (operand1),
    .operand2_i     (operand2),
    
    .result_o       (result)
);


localparam ADD_OP   =  2'b00;
localparam SUB_OP   =  2'b01;
localparam OR_OP    =  2'b10;
localparam AND_OP   =  2'b11;

// modify these parameters accordingly your assessment variant number

localparam OPERAND1_INIT_VALUE = 4'h3;
localparam OPERAND2_INIT_VALUE = 4'h7;
localparam OPERAND1_INC_VALUE = 1;
localparam OPERAND2_INC_VALUE = 3;

function integer compute_result;
    input integer operation, operand1, operand2;
    begin        
        case (operation)
            ADD_OP  : compute_result = operand1 + operand2;
            SUB_OP  : compute_result = operand1 - operand2;
            OR_OP   : compute_result = operand1 | operand2;
            AND_OP  : compute_result = operand1 & operand2;
            
            default: compute_result = 4'h0;
        endcase
    end
endfunction

task run_alu_tests();
    
    integer i;
    integer j;
    integer k;
    
    reg [7:0] op_string;
    
    begin
        for (k = 0; k < 4; k = k + 1) begin
            operation   = k;
            op_string = (operation == ADD_OP)   ? "+" : 
                        ((operation == SUB_OP)  ? "-" : 
                        ((operation == OR_OP)   ? "|" : 
                        "&"));
            $display("\n\nTesting '%s' operation!", op_string);
            for (i = OPERAND1_INIT_VALUE; i < 16; i = i + OPERAND1_INC_VALUE) begin
                for (j = OPERAND2_INIT_VALUE; j < 16; j = j + OPERAND2_INC_VALUE) begin
            
                    operand1    = i;
                    operand2    = j;
                    
                    
                    result_ref = compute_result(operation, operand1, operand2);
                    // we must wait or combinational alu to finish
                    #1 
                    
                    if (operation == ADD_OP || operation == SUB_OP) begin
                        // we do not have carry bit in our ALU, so truncate result 
                        // to lower 4bits
                        if (result != result_ref[3:0]) begin
                            $error("Calculation error: %d %s %d is %d (must be %d)", 
                                operand1, op_string, operand2, result, result_ref[3:0]);
                        end else begin
                            $display("Calculation is correct: %d %s %d is %d", operand1, 
                                op_string, operand2, result);
                        end
                    end else begin
                        if (result != result_ref[3:0]) begin
                            $error("Calculation error: %b %s %b is %b (must be %b)", 
                                operand1, op_string, operand2, result, result_ref[3:0]);
                        end else begin
                            $display("Calculation is correct: %b %s %b is %b", operand1, 
                                op_string, operand2, result);
                        end
                    end

                end
            end
        end
    end
endtask

// Initial block would run only once!
initial begin
    $display("Using OPERAND1_INIT_VALUE = %0d with %0d increment, \
        OPERAND2_INIT_VALUE = %0d with %0d increment.", 
        OPERAND1_INIT_VALUE, OPERAND1_INC_VALUE, 
        OPERAND2_INIT_VALUE, OPERAND2_INC_VALUE);
    
    run_alu_tests();
    
    $stop;
end

endmodule