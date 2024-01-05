module rom_control (
    input               clk,
    input               rstn,
    output              rom_rd_en,
    output  reg [14:0]  rom_addr,
    output  reg [7:0]   column,
    output  reg [6:0]   row
);

    assign rom_rd_en = (row != 0) && (row <= 114);
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            rom_addr <= 0;
        else if(rom_addr <= 28498 && rom_rd_en)
            rom_addr <= rom_addr + 1;
        else if(rom_addr == 28499 && rom_rd_en)
            rom_addr <= 0;
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            column <= 0;
        else if(column <= 248)
            column <= column + 1;
        else if(column == 249)
            column <= 0;
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            row <= 0;
        else if(row <= 114 && column == 249)
            row <= row + 1;
        else if(row == 115 && column == 249)
            row <= 0;
    end
    

    
endmodule