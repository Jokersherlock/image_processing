`timescale 1ns/1ns

module tb_rom_control;
    
    parameter  PERIOD = 10;

    reg clk;
    reg rstn;
    wire rom_rd_en;
    wire [14:0] rom_addr;
    wire [7:0] column;
    wire [7:0] row;
    rom_control u_rom_control(
        .clk(clk),
        .rstn(rstn),
        .rom_rd_en(rom_rd_en),
        .rom_addr(rom_addr),
        .column(column),
        .row(row)
    );

    always #(PERIOD) clk = ~clk;
    initial begin
        clk = 0;
        rstn = 0;
        #10
        rstn = 1;
    end
endmodule