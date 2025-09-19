// Define time unit (1ns) with time precision (1ps) for simulation (#1 would be delay of 1ns)
`timescale 1ns/1ps

// Declare top testbench module
module alu_tb;

reg     [3:0]   operand1;
reg     [3:0]   operand2;
reg     [1:0]   operation;
reg             carry_in;
    
wire    [3:0]   result;
reg     [4:0]   result_2comp;   // for 2's complement of a result if carry out flag was set for subtraction 
wire            zero, carry_out;
    
integer         result_ref;

// ALU design under test instantiation

alu alu_dut_inst (
    .operation_i    (operation),
    .operand1_i     (operand1),
    .operand2_i     (operand2),
    
    .carry_in       (carry_in),
    
    .zero           (zero),
    .carry_out      (carry_out),
    
    .result_o       (result)
);


localparam ADD_OP   =  2'b00;
localparam SUB_OP   =  2'b01;
localparam OR_OP    =  2'b10;
localparam AND_OP   =  2'b11;

// modify these parameters accordingly your assessment variant number
// mine is 15
localparam OPERAND1_INIT_VALUE = 4'h5;
localparam OPERAND2_INIT_VALUE = 4'h0;
localparam OPERAND1_INC_VALUE = 3;
localparam OPERAND2_INC_VALUE = 1;

function integer compute_result;
    input integer operation, operand1, operand2, carry_in;
    begin        
        case (operation)
            ADD_OP  : compute_result = operand1 + operand2 + carry_in;
            SUB_OP  : compute_result = operand1 - operand2 - carry_in;  // borrow
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
    integer ii;
    
    integer result_int;
    
    reg [7:0] op_string;
    
    begin
        operation = 0;
        operand1 = 0;
        operand2 = 0;
        carry_in = 0;
        
        for (ii = 0; ii <= 1; ii = ii + 1) begin
            carry_in = ii;
            $display("Testing carry_in %0d", carry_in);
            for (k = 0; k < 4; k = k + 1) begin // loop through operations
                operation   = k;
                op_string = (operation == ADD_OP) ? "+" : ((operation == SUB_OP) ? "-" : ((operation == OR_OP) ? "|" : "&"));
                $display("Testing '%s' operation!", op_string);
                for (i = OPERAND1_INIT_VALUE; i < 16; i = i + OPERAND1_INC_VALUE) begin         //loop through operand 1
                    for (j = OPERAND2_INIT_VALUE; j < 16; j = j + OPERAND2_INC_VALUE) begin     //loop through operand 2
                        
                        operand1    = i;
                        operand2    = j;
                     
                        result_ref = compute_result(operation, operand1, operand2, carry_in);
                        #1;
                        
                        if (operation == ADD_OP) begin
                            
                        end else if (operation == SUB_OP) begin
                            // borrow flag was set - convert 4bit unsigned value with borrow flag to signed int 
                            if (carry_out) begin 
                                // borrow flag was set - convert result to two's complement form
                                result_2comp = ~{carry_out, result} + 1;
                                // convert to negative signed integer
                                result_int = -result_2comp;
                            end else begin
                                result_2comp = {carry_out, result};
                                result_int = result_2comp;
                            end
                                
                            if (result_int != result_ref) begin
                                $display("Calculation error: %d %s %d is %0d (must be %0d) (zero flag: %d, borrow flag: %d)", operand1, op_string, operand2, result_int, result_ref, zero, carry_out);
                            end else begin
                                $display("Calculation is correct: %d %s %0d is %0d (zero flag: %d, borrow flag: %d)", operand1, op_string, operand2, result_int, zero, carry_out);
                            end
                        end else begin
                            if (result != result_ref[3:0]) begin
                                $display("Calculation error: %b %s %b is %b (must be %b)", operand1, op_string, operand2, result, result_ref[3:0]);
                            end else begin
                                $display("Calculation is correct: %b %s %b is %b", operand1, op_string, operand2, result);
                            end
                        end

                    end
                end
            end
        end
    end
endtask

// Initial block would run only once!
initial begin
    $display("Using OPERAND1_INIT_VALUE = %0d with %0d increment, OPERAND2_INIT_VALUE = %0d with %0d increment.", OPERAND1_INIT_VALUE, OPERAND1_INC_VALUE, OPERAND2_INIT_VALUE, OPERAND2_INC_VALUE);
    
    run_alu_tests();
    
    $stop;
end

endmodule