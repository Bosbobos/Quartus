module data_mover  
#(  parameter CLK_FREQ          = 50000000,         // Hz
    parameter UPDATE_PERIOD     = 1500)              // ms

(
    input               clock, 
    input               rstn,
    input               enable,

    // port for reading from RAM
    output reg  [4:0]   ram_addr,
    input       [15:0]  ram_data_in, 

    // port for writing to FIFO
    output reg  [15:0]  fifo_data_out,
    output reg          fifo_wrreq,
    input               fifo_full
);

localparam [63:0] UPDATE_PERIOD_IN_TICKS = (CLK_FREQ / 1000) * UPDATE_PERIOD ;
reg [$clog2(UPDATE_PERIOD_IN_TICKS) : 0] counter = 0;
reg update_req = 0;

always @ (posedge clock) begin 
    if (counter >= UPDATE_PERIOD_IN_TICKS) begin
        update_req <= 1'b1;
        counter <= 0;
    end else begin
        update_req <= 1'b0;
        counter <= counter + 1;
    end
end

always @ (posedge clock) begin
    if (!rstn) begin
        ram_addr        <= 5'h0;
        
        fifo_wrreq      <= 1'b0;
        fifo_data_out   <= 16'h00;
    end else begin
        
    end
   
end

endmodule