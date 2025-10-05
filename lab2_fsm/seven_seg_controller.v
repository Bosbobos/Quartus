`include "defines.v"

module seven_seg_controller 
#(  parameter CLK_FREQ          = 50000000,         // Hz
    parameter UPDATE_PERIOD     = 500,              // ms
    parameter SYMBOL_SIZE       = 5,                // bit size of one symbol
    parameter DISPLAY_LENGTH    = 6)                // Number of hexdisplays to use 

(   input           clk, 
    input           rstn, 
            
    input           enable,

    output [5*DISPLAY_LENGTH - 1 : 0] symbols_array
    
);

localparam [63:0] UPDATE_PERIOD_IN_TICKS = CLK_FREQ * UPDATE_PERIOD / 1000;

reg [$clog2(UPDATE_PERIOD_IN_TICKS) : 0] counter = 0;
reg update_req = 0;

always @ (posedge clk) begin 
    if (counter == UPDATE_PERIOD_IN_TICKS) begin
        update_req <= 1'b1;
        counter <= 0;
    end else begin
        update_req <= 1'b0;
        counter <= counter + 1;
    end
end

reg [3:0] state;
reg [7:0] cnt;

localparam [3:0] OFF        = 0;
localparam [3:0] IDLE       = 1;
localparam [3:0] FEED       = 2;
localparam [3:0] SHIFT      = 3;

localparam [SYMBOL_SIZE*3-1:0] ASSESSMENT_VARIANT_NUMBER = {5'h0, 5'h1, 5'h5};

localparam STRING_TO_DISPLAY_LEN = 11;
localparam STD_MSB = SYMBOL_SIZE*STRING_TO_DISPLAY_LEN - 1; // STRING_TO_DISPLAY most significant bit
reg [STD_MSB:0] string_to_display = {`SYM_BLANK, `SYM_H, `SYM_E, `SYM_L, `SYM_L, `SYM_O, `SYM__, ASSESSMENT_VARIANT_NUMBER, `SYM_BLANK};

wire [SYMBOL_SIZE-1:0] first_symbol;
wire [SYMBOL_SIZE-1:0] last_symbol;

wire [STD_MSB:0] string_to_display_shifted_left;
wire [STD_MSB:0] string_to_display_shifted_right;

assign string_to_display_shifted_left = string_to_display << (cnt*SYMBOL_SIZE);
assign string_to_display_shifted_right = string_to_display >> (cnt*SYMBOL_SIZE);

assign first_symbol = string_to_display_shifted_left[STD_MSB : STD_MSB - SYMBOL_SIZE + 1];
assign last_symbol  = string_to_display_shifted_right[2*SYMBOL_SIZE - 1: SYMBOL_SIZE];      // skip last blank symbol

localparam MEMSIZE = STRING_TO_DISPLAY_LEN*SYMBOL_SIZE;
reg [MEMSIZE-1:0] symbols_array_tmp;

assign symbols_array = symbols_array_tmp[SYMBOL_SIZE*DISPLAY_LENGTH-1:0];

always @ (posedge clk) begin
    if (!rstn) begin
        state <= OFF;
        cnt <= 0;
        symbols_array_tmp <= {(MEMSIZE/SYMBOL_SIZE){`SYM_BLANK}};
    end else begin
        case (state) 
            
            OFF: begin
                if (enable) begin
                    state <= FEED;
                    cnt <= 0;
                end
                symbols_array_tmp <= {(MEMSIZE/SYMBOL_SIZE){`SYM_BLANK}};
            end
                
            IDLE: begin
                if (update_req && enable) begin
                    state <= SHIFT;
                end
            end
            
            FEED: begin
						// Справа налево
						// symbols_array_tmp[SYMBOL_SIZE-1:0] <= first_symbol;   // select first symbol
                
						//	Слева направо
					 symbols_array_tmp[MEMSIZE - 1 : MEMSIZE - SYMBOL_SIZE] <= last_symbol;
                if (update_req && enable) begin
                    state <= SHIFT;
                    cnt <= cnt + 1;
                end
            end
            
            SHIFT: begin
                // cycle shift left: put last symbol back to the start
					 // Выражаясь по-русски, справа налево
                // symbols_array_tmp <= {symbols_array_tmp[STD_MSB - SYMBOL_SIZE : 0], symbols_array_tmp[STD_MSB : STD_MSB - SYMBOL_SIZE + 1]};
                // if (first_symbol  == `SYM_BLANK) begin
					 
					 // Слева направо
					 symbols_array_tmp <= {symbols_array_tmp[SYMBOL_SIZE - 1 : 0], symbols_array_tmp[MEMSIZE - 1 : SYMBOL_SIZE]};
					 if (last_symbol == `SYM_BLANK) begin
                    state <= IDLE;
                end else begin
                    state <= FEED;
                end
            end
            
            default: state <= OFF;
        
        endcase
    end
end


endmodule