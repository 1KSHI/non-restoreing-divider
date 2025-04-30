`define INT  2
`define FLO  12
`define SIZE 14
module divider(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [11:0] x_in,       // 输入数x，Q8.8格式
    output reg done,
    output reg [11:0] y_out       // 输出1/x，Q8.8格式
);

  reg [`INT+`FLO-1:0] x, y;
  reg [3:0] iter;
  reg running;

  wire [23:0] xy;  
  Wallace12x12 wallace_1(
      .x_in(x[13:2]),
      .y_in(y[13:2]),
      .result_out(xy)
  );

  // Q8.8 * Q8.8 = Q16.16
  wire [`INT+`FLO-1:0] xy_shift = {xy[11:0],2'b0};          // 舍弃高位，取Q8.8结果
  wire [`INT+`FLO-1:0] two_minus_xy = `SIZE'h2000 - xy_shift;  // 2 - x*y, 2 in Q8.8 is 0x0200
  wire [23:0] y_next_full;      // y*(2 - x*y)
  Wallace12x12 wallace_2(
      .x_in(y[13:2]),
      .y_in(two_minus_xy[13:2]),
      .result_out(y_next_full)
  );
  wire [`INT+`FLO-1:0] y_next = y_next_full[21:8];          // Q8.8

  always @(posedge clk or posedge rst) begin
      if (rst) begin
          y_out <= 0;
          done <= 0;
          y <= 0;
          x <= 0;
          iter <= 0;
          running <= 0;
      end else if (start && !running) begin
          x <= {x_in,2'b0};
          y <= `SIZE'b00_0000_1000_0000;  // 初始猜测为1（Q8.8格式）
          iter <= 0;
          running <= 1;
          done <= 0;
      end else if (running) begin
          y <= y_next;
          iter <= iter + 1;
          if (iter == 3) begin  // 迭代4次
              y_out <= y_next[11:0];
              done <= 1;
              running <= 0;
          end
      end
  end
endmodule
