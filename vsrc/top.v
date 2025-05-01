module top(
    input clk,
    input rst,
    input start,
    input  [12:0] dividend,
    input  [12:0] divisor,
    output [11:0] quotient,
    output [12:0] remainder,
    output done
);

res_div res_div(clk,rst,start,dividend,divisor,quotient,done);
//res_div res_div(dividend,divisor,quotient,remainder);

//res_div res_div(clk,rst,start,dividend,divisor,quotient,remainder,done);


endmodule
