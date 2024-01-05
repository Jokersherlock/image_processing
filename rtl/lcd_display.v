module lcd_display (
    input               lcd_pclk,
    input               rstn,

    input       [10:0]  pixel_xpos,
    input       [10:0]  pixel_ypos,
    output  reg [23:0]  pixel_data
);
    localparam  ORIGIN_X_START = 11'd10;
    localparam  ORIGIN_Y_START = 11'd10;

    localparam  DST_X_START    = 11'd270;
    localparam  DST_Y_START    = 11'd10;
    localparam  LA_X_START     = 11'd540;
    localparam  LA_Y_START     = 11'd10;

    localparam  BACK_COLOR     = 24'hE0FFFF;
    localparam  PIC_WIDTH      = 250;
    localparam  PIC_HEIGHT     = 114;

    reg [14:0] origin_addr,dst_addr,laplace_addr;
    wire [23:0] origin_data,dst_data,laplace_data;
    
    always @(posedge lcd_pclk or negedge rstn) begin
        if(!rstn)
            pixel_data <= BACK_COLOR;
     //   else if( (pixel_xpos >= ORIGIN_X_START - 1'b1) && (pixel_xpos < ORIGIN_X_START + PIC_WIDTH - 1'b1) 
    //            && (pixel_ypos >= ORIGIN_Y_START) && (pixel_ypos < ORIGIN_Y_START + PIC_HEIGHT) )
   //         pixel_data <= origin_data ;  //显示图片
        else if( (pixel_xpos >= LA_X_START - 1'b1) && (pixel_xpos < LA_X_START + PIC_WIDTH - 1'b1) 
                && (pixel_ypos >= LA_Y_START) && (pixel_ypos < LA_Y_START + PIC_HEIGHT) )
            pixel_data <= laplace_data ;  //显示图片
    //    else if( (pixel_xpos >= DST_X_START - 1'b1) && (pixel_xpos < DST_X_START + PIC_WIDTH - 1'b1) 
     //           && (pixel_ypos >= DST_Y_START) && (pixel_ypos < DST_Y_START + PIC_HEIGHT) )
     //       pixel_data <= dst_data ;  //显示图片
        else 
            pixel_data <= BACK_COLOR;
    end
/*
    always @(posedge lcd_pclk or negedge rstn) begin
        if(!rstn)
            origin_addr <= 14'd0;
        //当横纵坐标位于图片显示区域时,累加ROM地址    
        else if((pixel_ypos >= ORIGIN_Y_START) && (pixel_ypos < ORIGIN_Y_START + PIC_HEIGHT) 
            && (pixel_xpos >= ORIGIN_X_START - 2'd2) && (pixel_xpos < ORIGIN_X_START + PIC_WIDTH - 2'd2)) 
            origin_addr <= origin_addr + 1'b1;
        //当横纵坐标位于图片区域最后一个像素点时,ROM地址清零    
        else if((pixel_ypos >= ORIGIN_Y_START + PIC_HEIGHT))
            origin_addr <= 14'd0;
    end

    always @(posedge lcd_pclk or negedge rstn) begin
        if(!rstn)
            dst_addr <= 14'd0;
        //当横纵坐标位于图片显示区域时,累加ROM地址    
        else if((pixel_ypos >= DST_Y_START) && (pixel_ypos < DST_Y_START + PIC_HEIGHT) 
            && (pixel_xpos >= DST_X_START - 2'd2) && (pixel_xpos < DST_X_START + PIC_WIDTH - 2'd2)) 
            dst_addr <= dst_addr + 1'b1;
        //当横纵坐标位于图片区域最后一个像素点时,ROM地址清零    
        else if((pixel_ypos >= DST_Y_START + PIC_HEIGHT))
            dst_addr <= 14'd0;
    end
    */

    always @(posedge lcd_pclk or negedge rstn) begin
        if(!rstn)
            laplace_addr <= 14'd0;
        //当横纵坐标位于图片显示区域时,累加ROM地址    
        else if((pixel_ypos >= LA_Y_START) && (pixel_ypos < LA_Y_START + PIC_HEIGHT) 
            && (pixel_xpos >= LA_X_START - 2'd2) && (pixel_xpos < LA_X_START + PIC_WIDTH - 2'd2)) 
            laplace_addr <= laplace_addr + 1'b1;
        //当横纵坐标位于图片区域最后一个像素点时,ROM地址清零    
        else if((pixel_ypos >= LA_Y_START + PIC_HEIGHT))
            laplace_addr <= 14'd0;
    end

    conv u_conv(
        .clk(lcd_pclk),
        .rstn(rstn),
       // .dst_addr(dst_addr),
        .laplace_addr(laplace_addr),
       // .origin_addr(origin_addr),
      //  .dst_output(dst_data),
      //  .origin_output(origin_data),
        .laplace_output(laplace_data)
    );

endmodule