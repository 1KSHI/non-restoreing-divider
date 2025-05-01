`define INT  2
`define FLO  20
`define SIZE 14
module divider(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [11:0] z_in,
    input wire [11:0] x_in,
    output reg done,
    output wire [39:0] res_out,
    output reg [19:0] y_out
);
  
  reg [21:0] x, y;
  reg [3:0] iter;
  reg running;


  wire [43:0] xy = x * y;
  wire [21:0] xy_shift = xy[31:10];
  wire [21:0] two_minus_xy = 22'b10_0000_0000_0000_0000_0000 - xy_shift;
  wire [43:0] y_next_full = y * two_minus_xy;
  wire [21:0] y_next = y_next_full[41:20];

  wire [21:0]y_init;
  lut lut(
      .N({4'b0,x_in}),
      .initial_approx(y_init)
  );

  always @(posedge clk or posedge rst) begin
      if (rst) begin
          y_out <= 0;
          done <= 0;
          y <= 0;
          x <= 0;
          iter <= 0;
          running <= 0;
      end else if (start && !running) begin
          x <= {x_in,10'b0};
          y <= y_init;  // 初始猜测为1（Q8.8格式）
          iter <= 0;
          running <= 1;
          done <= 0;
      end else if (running) begin
          y <= y_next;
          iter <= iter + 1;
          if (iter == 3) begin  // 迭代4次
              y_out <= y_next[19:0];
              done <= 1;
              running <= 0;
          end
      end
  end

assign res_out = y_out*{8'b0,z_in};

endmodule
