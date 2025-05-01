module divider(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [11:0] x_in,       // 输入数x，Q8.8格式
    output reg done,
    output reg [11:0] y_out       // 输出1/x，Q8.8格式
);

  reg [13:0] x, y;//x Q2.12 , y Q2.12
  reg [3:0] iter;
  reg running;

  wire [27:0] xy = x * y;                   // Q2.12 * Q2.12
  wire [13:0] xy_shift = xy[25:12];          // 舍弃高位，取Q2.12
  wire [13:0] two_minus_xy = 14'h2000 - xy_shift;  // 2 - x*y, 符号拓展
  wire [27:0] y_next_full = y * two_minus_xy;      // y*(2 - x*y) Q2.12
  wire [13:0] y_next = y_next_full[25:12];          // Q2.12


  always @(posedge clk or posedge rst) begin
      if (rst) begin
          y_out <= 0;
          done <= 0;
          y <= 0;
          x <= 0;
          iter <= 0;
          running <= 0;
      end else if (start && !running) begin
          x <= {x_in,2'b00};
          y <= 14'h100;  // 初始猜测为1（Q8.8格式）
          iter <= 0;
          running <= 1;
          done <= 0;
      end else if (running) begin
          y <= y_next;
          iter <= iter + 1;
          if (iter == 4) begin  // 迭代4次
              y_out <= y_next[11:0];
              done <= 1;
              running <= 0;
          end
      end
  end
endmodule
