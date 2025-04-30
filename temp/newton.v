module newton (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [11:0] x_in,  // 被除数
    input wire [11:0] y_in,  // 除数 (不能为0)
    output reg [11:0] res_out, // 结果: x_in / y_in
    output reg done
);

// 状态定义
localparam IDLE = 2'b00;
localparam INIT = 2'b01;
localparam ITER = 2'b10;
localparam FINISH = 2'b11;

reg [1:0] state;
reg [11:0] x_reg, y_reg;
reg [11:0] reciprocal; // 用于存储倒数的中间结果 (12.12格式)
reg [3:0] iter_count;  // 迭代计数器

// 中间信号
wire [11:0] y_scaled = y_reg; // 将y扩展到24位 (12.12格式)

wire [23:0] product;
wire [11:0] product_shift;

wire [11:0] two_minus_product;

wire [23:0] new_reciprocal;
wire [11:0] new_reciprocal_shift;


assign product = (reciprocal * y_scaled);
assign product_shift = product[23:12];

assign two_minus_product = 12'h002 - product_shift;

assign new_reciprocal = (reciprocal * two_minus_product);
assign new_reciprocal_shift = new_reciprocal[23:12];

wire [23:0] res_out_temp = (x_reg * reciprocal);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        res_out <= 12'b0;
        done <= 1'b0;
        reciprocal <= 12'b0;
        iter_count <= 4'b0;
    end else begin
        case (state)
            IDLE: begin
                done <= 1'b0;
                if (start) begin
                    x_reg <= x_in;
                    y_reg <= (y_in == 12'b0) ? 12'b1 : y_in; // 避免除0错误
                    state <= INIT;
                end
            end
            
            INIT: begin
                // 初始估计值: 1/y ≈ 1.0/y (使用简单的查找表或近似)
                // 这里使用简单的近似: reciprocal ≈ (48/y) << 8 (12.12格式)
                // 实际应用中可以使用更精确的初始估计
                reciprocal <= 12'b000100000000; // 近似倒数
                iter_count <= 4'b0;
                state <= ITER;
            end
            
            ITER: begin
                // 牛顿迭代: x_{n+1} = x_n * (2 - a * x_n)
                reciprocal <= new_reciprocal_shift;
                iter_count <= iter_count + 1;
                
                // 通常3-4次迭代足够12位精度
                if (iter_count == 4'd2) begin
                    state <= FINISH;
                end
            end
            
            FINISH: begin
                // 计算最终结果: x/y = x * (1/y)
                // 使用12.12格式的倒数，所以结果需要右移12位
                res_out <= res_out_temp[11:0];
                done <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule