module newton (
    input clk,
    input reset,
    input [11:0] N,
    input start,
    output reg [23:0] reciprocal,  // Q24格式的定点数结果
    output reg done
);

reg [11:0] N_reg;
reg [23:0] x;  // 迭代变量
reg [2:0] iter_count;
reg running;

// 初始近似值查找表 (简化版，实际可使用更精确的初始值)
function [23:0] initial_approx;
    input [11:0] n;
    begin
        if (n > 3072) initial_approx = 24'h0000AA;   // ~1/3072
        else if (n > 2048) initial_approx = 24'h0000FF;
        else if (n > 1024) initial_approx = 24'h0001FF;
        else initial_approx = 24'h0003FF;
    end
endfunction

always @(posedge clk or posedge reset) begin
    if (reset) begin
        reciprocal <= 0;
        done <= 0;
        running <= 0;
        iter_count <= 0;
    end else if (start && !running) begin
        N_reg <= N;
        x <= initial_approx(N);
        iter_count <= 0;
        running <= 1;
        done <= 0;
    end else if (running) begin
        // 牛顿迭代: x_{n+1} = x_n*(2 - N*x_n)
        x <= x * (24'h200000 - {N_reg, 12'b0} * x) >> 23;
        
        iter_count <= iter_count + 1;
        if (iter_count == 3) begin  // 3次迭代通常足够
            reciprocal <= x;
            done <= 1;
            running <= 0;
        end
    end
end

endmodule