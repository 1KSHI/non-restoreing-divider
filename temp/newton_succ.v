module divider(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [11:0] x_in,       // 输入数x，Q8.8格式
    output reg done,
    output reg [23:0] y_out       // 输出1/x，Q8.8格式
);
  localparam WIDTH = 24; // Q8.8格式
  reg [WIDTH-1:0] x, y;
  reg [3:0] iter;
  reg running;

  wire [WIDTH*2-1:0] xy = x * y;                   // Q8.8 * Q8.8 = Q16.16
  wire [WIDTH-1:0] xy_shift = xy[35:12];          // 舍弃高位，取Q8.8结果
  wire [WIDTH-1:0] two_minus_xy = 24'h002000 - xy_shift;  // 2 - x*y, 2 in Q8.8 is 0x0200
  wire [WIDTH*2-1:0] y_next_full = y * two_minus_xy;      // y*(2 - x*y)
  wire [WIDTH-1:0] y_next = y_next_full[35:12];          // Q8.8

  always @(posedge clk or posedge rst) begin
      if (rst) begin
          y_out <= 0;
          done <= 0;
          y <= 0;
          x <= 0;
          iter <= 0;
          running <= 0;
      end else if (start && !running) begin
          x <= {x_in,12'b0};
          y <= 24'h000010;  // 初始猜测为1（Q8.8格式）
          iter <= 0;
          running <= 1;
          done <= 0;
      end else if (running) begin
          y <= y_next;
          iter <= iter + 1;
          if (iter == 4) begin  // 迭代4次
              y_out <= y_next;
              done <= 1;
              running <= 0;
          end
      end
  end
endmodule
