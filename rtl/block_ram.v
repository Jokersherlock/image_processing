module block_ram (
    input               clk,
    input               rstn,
    input               en,
    input       [7:0]  data,
    input       [1:0]   pad,
    input       [7:0]   cnt,
    output  reg [23:0]  pixel00, pixel01, pixel02,
                        pixel10, pixel11, pixel12,
                        pixel20, pixel21, pixel22
);
    reg [23:0] line_0 [251:0];
    reg [23:0] line_1 [251:0];
    reg [23:0] line_2 [251:0];
    reg [23:0] line_3 [251:0];

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            pixel00 <= 0;
            pixel01 <= 0;
            pixel02 <= 0;
            pixel10 <= 0;
            pixel11 <= 0;
            pixel12 <= 0;
            pixel20 <= 0;
            pixel21 <= 0;
            pixel22 <= 0;
        end
        else if(en)begin
            case (pad)
                2'b00:begin
                    line_0[cnt+1] <= data;
                    pixel00 <= line_1[cnt];
                    pixel01 <= line_1[cnt+1];
                    pixel02 <= line_1[cnt+2];
                    pixel10 <= line_2[cnt];
                    pixel11 <= line_2[cnt+1];
                    pixel12 <= line_2[cnt+2];
                    pixel20 <= line_3[cnt];
                    pixel21 <= line_3[cnt+1];
                    pixel22 <= line_3[cnt+2];
                end
                2'b01:begin
                    line_1[cnt+1] <= data;
                    pixel00 <= line_2[cnt];
                    pixel01 <= line_2[cnt+1];
                    pixel02 <= line_2[cnt+2];
                    pixel10 <= line_3[cnt];
                    pixel11 <= line_3[cnt+1];
                    pixel12 <= line_3[cnt+2];
                    pixel20 <= line_0[cnt];
                    pixel21 <= line_0[cnt+1];
                    pixel22 <= line_0[cnt+2];
                end
                2'b10:begin
                    line_2[cnt+1] <= data;
                    pixel00 <= line_3[cnt];
                    pixel01 <= line_3[cnt+1];
                    pixel02 <= line_3[cnt+2];
                    pixel10 <= line_0[cnt];
                    pixel11 <= line_0[cnt+1];
                    pixel12 <= line_0[cnt+2];
                    pixel20 <= line_1[cnt];
                    pixel21 <= line_1[cnt+1];
                    pixel22 <= line_1[cnt+2];
                end
                2'b11:begin
                    line_3[cnt+1] <= data;
                    pixel00 <= line_0[cnt];
                    pixel01 <= line_0[cnt+1];
                    pixel02 <= line_0[cnt+2];
                    pixel10 <= line_1[cnt];
                    pixel11 <= line_1[cnt+1];
                    pixel12 <= line_1[cnt+2];
                    pixel20 <= line_2[cnt];
                    pixel21 <= line_2[cnt+1];
                    pixel22 <= line_2[cnt+2];
                end
            endcase
        end
    end
    
    
endmodule