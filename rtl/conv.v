module conv(
    input               clk,
    input               rstn,
    //input       [14:0]  dst_addr,
    input       [14:0]  laplace_addr,
    //input       [14:0]  origin_addr,
    //output  reg [23:0]  dst_output,
    //output  reg [23:0]  origin_output,
    output  reg [23:0]  laplace_output
    
);
    wire rom_rd_en;
    wire [23:0] rom_rd_data;
    wire [14:0] rom_addr;
    reg [7:0] laplace [28499:0];
    //reg [7:0] dst [28499:0];
    wire [7:0] column;
    wire [6:0] row;
    reg [1:0] pad;
    reg [23:0] write_data;
    wire [23:0] origin_data;
    wire en;
    wire [23:0] pixel00,pixel01,pixel02,
               pixel10,pixel11,pixel12,
               pixel20,pixel21,pixel22;
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            pad <= 0;
        else if(column == 249)
            pad <= pad + 1;
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            write_data <= 0;
        else if(rom_rd_en)
           // write_data <= dst[rom_addr];
            write_data <= (77*rom_rd_data[23:16]+150*rom_rd_data[15:8]+29*rom_rd_data[7:0])>>8;
        else
            write_data <= 0;
    end

/*
    always @(posedge clk) begin
        if(rom_rd_en)
            dst[rom_addr] <= (77*rom_rd_data[23:16]+150*rom_rd_data[15:8]+29*rom_rd_data[7:0])>>8;  
            //dst[rom_addr] <= rom_rd_data[23:16];  
    end
*/
    always @(posedge clk) begin
        if(rom_rd_en)begin
            if(row>=3)
                laplace[(row-3)*250+column] <= pixel01 + pixel10 - 4*pixel11 + pixel12;
            end
            else if (row == 0)
                laplace[28250+column] <= pixel01 + pixel10 - 4*pixel11 + pixel12;
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
           // origin_output<=0;
            //dst_output<=0;
            laplace_output<=0;
        end
        else begin
           // origin_output <= 0;
            //dst_output <= {dst[dst_addr],dst[dst_addr],dst[dst_addr]};
            laplace_output <= {laplace[laplace_addr],laplace[laplace_addr],laplace[laplace_addr]};
        end
    end

    block_ram u_block_ram(
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .data(write_data),
        .pad(pad),
        .cnt(column),
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22)
    );

    rom_control u_rom_control(
        .clk(clk),
        .rstn(rstn),
        .rom_rd_en(rom_rd_en),
        .rom_addr(rom_addr),
        .column(column),
        .row(row)
    );

    blk_mem_gen_0  blk_mem_gen_0 (
        .clka  (clk),    // input wire clka
        .ena   (rom_rd_en),   // input wire ena
        .addra (rom_addr),    // input wire [13 : 0] addra
        .douta (rom_rd_data)  // output wire [23 : 0] douta
    );

endmodule