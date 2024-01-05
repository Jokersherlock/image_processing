module  image_processing(
    input              sys_clk ,
    input              sys_rst_n ,
    //RGB LCD接口 
    output             lcd_hs  ,       //LCD 行同步信�?
    output             lcd_vs  ,       //LCD 场同步信�?
    output             lcd_de  ,       //LCD 数据输入使能
    inout      [23:0]  lcd_rgb ,       //LCD RGB565颜色数据
    output             lcd_bl  ,       //LCD 背光控制信号
    output             lcd_rst,        //LCD 复位
    output             lcd_clk         //LCD 采样时钟
);
    
//wire define    
wire  [15:0]  lcd_id    ;    //LCD屏ID
wire          lcd_pclk  ;    //LCD像素时钟
              
wire  [10:0]  pixel_xpos;    //当前像素点横坐标
wire  [10:0]  pixel_ypos;    //当前像素点纵坐标
wire  [10:0]  h_disp    ;    //LCD屏水平分辨率
wire  [10:0]  v_disp    ;    //LCD屏垂直分辨率
wire  [23:0]  pixel_data;    //像素数据
wire  [23:0]  lcd_rgb_o ;    //输出的像素数�?
wire  [23:0]  lcd_rgb_i ;    //输入的像素数�?

//*****************************************************
//**                    main code
//*****************************************************

//像素数据方向切换
assign lcd_rgb = lcd_de ?  lcd_rgb_o :  {24{1'bz}};
assign lcd_rgb_i = lcd_rgb;

//读LCD ID模块
rd_id u_rd_id(
    .clk          (sys_clk  ),
    .rst_n        (sys_rst_n),
    .lcd_rgb      (lcd_rgb_i),
    .lcd_id       (lcd_id   )
    );    

//时钟分频模块    
clk_div u_clk_div(
    .clk           (sys_clk  ),
    .rst_n         (sys_rst_n),
    .lcd_id        (lcd_id   ),
    .lcd_pclk      (lcd_pclk )
    );    

//LCD显示模块    
lcd_display u_lcd_display(
    .lcd_pclk       (lcd_pclk  ),
    .rstn          (sys_rst_n ),
    .pixel_xpos     (pixel_xpos),
    .pixel_ypos     (pixel_ypos),
    .pixel_data     (pixel_data)
    );    

//LCD驱动模块
lcd_driver u_lcd_driver(
    .lcd_pclk      (lcd_pclk  ),
    .rst_n         (sys_rst_n ),
    .lcd_id        (lcd_id    ),
    .pixel_data    (pixel_data),
    .pixel_xpos    (pixel_xpos),
    .pixel_ypos    (pixel_ypos),
    .h_disp        (h_disp    ),
    .v_disp        (v_disp    ),

    .lcd_de        (lcd_de    ),
    .lcd_hs        (lcd_hs    ),
    .lcd_vs        (lcd_vs    ),
    .lcd_bl        (lcd_bl    ),
    .lcd_clk       (lcd_clk   ),
    .lcd_rst       (lcd_rst   ),
    .lcd_rgb       (lcd_rgb_o )
    );

endmodule
