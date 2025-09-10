module seven_seg_decoder (
    input       [3:0]   data_i,
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
        4'h0: result_o = {dot_i, 7'b1000000};
        4'h1: result_o = {dot_i, 7'b1111001};
        4'h2: result_o = {dot_i, 7'b0100100};
        4'h3: result_o = {dot_i, 7'b0110000};
        4'h4: result_o = {dot_i, 7'b0011001};
        4'h5: result_o = {dot_i, 7'b0010010};
		  4'h6: result_o = {dot_i, 7'b0100000}; 
        4'h7: result_o = {dot_i, 7'b1111000};
        4'h8: result_o = {dot_i, 7'b0000000};
        4'h9: result_o = {dot_i, 7'b0011000};
        4'hA: result_o = {dot_i, 7'b0001000};
        4'hB: result_o = {dot_i, 7'b0000011};
        4'hC: result_o = {dot_i, 7'b1000110};
        4'hD: result_o = {dot_i, 7'b0100001};
        4'hE: result_o = {dot_i, 7'b0000110};
        4'hF: result_o = {dot_i, 7'b0001110};
    
        default: result_o = {8'hFF};
    endcase
end

endmodule