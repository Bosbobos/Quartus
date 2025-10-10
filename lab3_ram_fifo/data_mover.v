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

// Старый некорректный вариант
// localparam [63:0] UPDATE_PERIOD_IN_TICKS = (CLK_FREQ / 1000) * UPDATE_PERIOD ;

// Новый корректный
reg [63 : 0] counter = 0;
localparam [63:0] UPDATE_PERIOD_IN_TICKS = (CLK_FREQ * UPDATE_PERIOD) / 1000 ;

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
    // Если мы нажали ресет
    if (!rstn) begin
        // Всё в ноль
        ram_addr        <= 5'h0;
        fifo_wrreq      <= 1'b0;
        fifo_data_out   <= 16'h00;
    end else begin
        // если не занулить запись в фифо, оно может дублироваться и вообще мы взорвёмся (я лично)
        fifo_wrreq <= 1'b0;

		  // запись/чтение происходит если плата включена + мы хотим, чтобы они произошли + есть место в фифо
        if (enable && update_req && !fifo_full) begin
            // записываем во вход фифо нужную ячейку рам
            fifo_data_out <= ram_data_in;
            // Говорим фифо закинуть ячейку данных из входа в него самого
            fifo_wrreq <= 1'b1;
            // Если рам закончился, то возвращаемся в начало
            if (ram_addr > 5'd30)
                ram_addr <= 5'd0;
            else // В ином случае просто едем дальше
                ram_addr <= ram_addr + 1;
        end

    end
   
end

endmodule