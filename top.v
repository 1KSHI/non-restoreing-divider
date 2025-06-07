module top(
    input clk,
    input rst,
    input start,
    input  [3:0] dividend,
    input  [3:0] divisor,
    output [3:0] quotient,
    output [3:0] remainder,
    output done
);

divarr divarr(dividend,divisor,quotient,remainder);
//res_div res_div(dividend,divisor,quotient,remainder);

//res_div res_div(clk,rst,start,dividend,divisor,quotient,remainder,done);


endmodule
