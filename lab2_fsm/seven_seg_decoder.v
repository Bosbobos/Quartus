`include "defines.v"

module seven_seg_decoder (
    input       [4:0]   data_i,
    input               dot_i, 

    output reg [7:0]    result_o    //all segments are low-active! (1'b1 is off, 1'b0 is on)
);

// DE10-Lite seven segment indicator:
//
// ---bit0-
// |	  |
// |bit5  |bit1
// |	  |
// ---bit6-
// |	  |
// |bit4  |bit2
// |	  |
// ---bit3-
// dot - bit7

always @ * begin
    case (data_i)
        {1'b0, 4'h0}: result_o = {dot_i, 7'b1000000};
        {1'b0, 4'h1}: result_o = {dot_i, 7'b1111001};
        {1'b0, 4'h2}: result_o = {dot_i, 7'b0100100};
        {1'b0, 4'h3}: result_o = {dot_i, 7'b0110000};
        {1'b0, 4'h4}: result_o = {dot_i, 7'b0011001};
        {1'b0, 4'h5}: result_o = {dot_i, 7'b0010010};
        {1'b0, 4'h7}: result_o = {dot_i, 7'b1111000};
        {1'b0, 4'h8}: result_o = {dot_i, 7'b0000000};
        {1'b0, 4'h9}: result_o = {dot_i, 7'b0011000};
        {1'b0, 4'hA}: result_o = {dot_i, 7'b0001000};
        {1'b0, 4'hB}: result_o = {dot_i, 7'b0000011};
        {1'b0, 4'hC}: result_o = {dot_i, 7'b1000110};
        {1'b0, 4'hD}: result_o = {dot_i, 7'b0100001};
        {1'b0, 4'hE}: result_o = {dot_i, 7'b0000110};
        {1'b0, 4'hF}: result_o = {dot_i, 7'b0001110};
        
        // symbols
        `SYM_H:     result_o = {dot_i, 7'b0001001};   // H
        `SYM_E:     result_o = {dot_i, 7'b0000110};   // E
        `SYM_L:     result_o = {dot_i, 7'b1000111};   // L
        `SYM_O:     result_o = {dot_i, 7'b1000000};   // 0
        `SYM_P:     result_o = {dot_i, 7'b0001100};   // P
        `SYM__:     result_o = {dot_i, 7'b1110111};   // _
        `SYM_BLANK: result_o = {dot_i, 7'b1111111};   // blank
    
        default: result_o = {8'hFF};
    endcase
end

endmodule