`define INT  2
`define FLO  12
`define SIZE 14
module divider(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [11:0] z_in,
    input wire [11:0] x_in,
    output reg done,
    output wire [23:0] res_out,
    output reg [11:0] y_out
);
  
  reg [`INT+`FLO-1:0] x, y;
  reg [3:0] iter;
  reg running;

  wire [27:0] xy = x * y;
  wire [`INT+`FLO-1:0] xy_shift = xy[15:2];
  wire [`INT+`FLO-1:0] two_minus_xy = `SIZE'h2000 - xy_shift;
  wire [27:0] y_next_full = y * two_minus_xy;
  wire [`INT+`FLO-1:0] y_next = y_next_full[25:12];

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
          if (iter == 4) begin  // 迭代4次
              y_out <= y_next[11:0];
              done <= 1;
              running <= 0;
          end
      end
  end

  assign res_out = y_out*z_in;
endmodule
