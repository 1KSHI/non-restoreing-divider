module top(
    input clk,
    input rst,
    input  [11:0] dividend,
    input  [7:0] divisor,
    input start,
    output [11:0] quotient,
    output [7:0] remainder
);

wire done;

divider divider(clk,rst,start,dividend,done,quotient);


endmodule
