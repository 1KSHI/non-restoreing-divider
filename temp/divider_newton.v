`define INT  2
`define FLO  12
`define SIZE 14
module divider(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [11:0] x_in,
    output reg done,
    output reg [11:0] y_out
);

  reg [`INT+`FLO-1:0] x, y;
  reg [3:0] iter;
  reg running;

  reg [23:0] xy_stage1;
  reg [`INT+`FLO-1:0] two_minus_xy_stage1;
  reg [`INT+`FLO-1:0] y_stage1;
  reg [3:0] iter_stage1;
  
  reg [23:0] y_next_full_stage2;
  reg [3:0] iter_stage2;

  Wallace12x12 wallace_1(
      .x_in(x[13:2]),
      .y_in(y[13:2]),
      .result_out(xy_stage1)
  );

  always @(posedge clk) begin
      if (running) begin
          two_minus_xy_stage1 <= `SIZE'h2000 - {xy_stage1[11:0],2'b0};
          y_stage1 <= y;
          iter_stage1 <= iter;
      end
  end

  Wallace12x12 wallace_2(
      .x_in(y_stage1[13:2]),
      .y_in(two_minus_xy_stage1[13:2]),
      .result_out(y_next_full_stage2)
  );

  always @(posedge clk) begin
      if (running) begin
          iter_stage2 <= iter_stage1;
      end
  end

  wire [`INT+`FLO-1:0] y_next = y_next_full_stage2[21:8];

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
          y <= `SIZE'b00_0000_0000_0010;
          iter <= 0;
          running <= 1;
          done <= 0;
      end else if (running) begin
          if (iter_stage2 == 3) begin
              y_out <= y_next[11:0];
              done <= 1;
              running <= 0;
          end
          if (iter < 4) begin
              y <= y_next;
              iter <= iter + 1;
          end
      end
  end
endmodule