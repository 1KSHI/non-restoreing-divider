module top(
    input  [5:0] dividend,  // 被除数
    input  [3:0] divisor,   // 除数
    output [3:0] quotient,  // 商
    output [6:0] remainder  // 余数
);
wire [3:0] i_A [3:0];
wire [3:0] i_B [3:0];
wire [3:0] i_P [3:0];
wire [3:0] i_C [3:0]; 
wire [3:0] o_B [3:0];  
wire [3:0] o_P [3:0]; 
wire [3:0] o_S [3:0];
wire [3:0] o_C [3:0]; 

wire [6:0] i_x;
wire [3:0] i_y;
assign i_x = dividend;
assign i_y = divisor;
wire [3:0] o_Q;
wire [6:0] o_R;

assign quotient  = o_Q;
assign remainder = o_R;

genvar i,j;
for (i = 0; i < 4; i = i + 1) begin : gen_divisor
    for (j = 0; j < 4; j = j + 1) begin : gen_dividend
        CAS cas (
            .i_A(i_A[i][j]),
            .i_B(i_B[i][j]),
            .i_P(i_P[i][j]),
            .i_C(i_C[i][j]),
            .o_P(o_P[i][j]),
            .o_B(o_B[i][j]),
            .o_S(o_S[i][j]),
            .o_C(o_C[i][j])
        );
    end
end

//=================== row 1 =======================
//P C
assign i_P[0][0] = 1;
assign i_P[0][1] = o_P[0][0];
assign i_P[0][2] = o_P[0][1];
assign i_P[0][3] = o_P[0][2];
assign i_C[0][3] = o_P[0][3];
assign i_C[0][2] = o_C[0][3];
assign i_C[0][1] = o_C[0][2];
assign i_C[0][0] = o_C[0][1];
assign o_Q[3]    = o_C[0][0];

//B
assign i_B[0][0] = 0;
assign i_B[0][1] = i_y[2];
assign i_B[0][2] = i_y[1];
assign i_B[0][3] = i_y[0];

//A
assign i_A[0][0] = 0;
assign i_A[0][1] = i_x[5];
assign i_A[0][2] = i_x[4];
assign i_A[0][3] = i_x[3];

//=================== row 2 =======================
//P C
assign i_P[1][0] = o_C[0][0];
assign i_P[1][1] = o_P[1][0];
assign i_P[1][2] = o_P[1][1];
assign i_P[1][3] = o_P[1][2];
assign i_C[1][3] = o_P[1][3];
assign i_C[1][2] = o_C[1][3];
assign i_C[1][1] = o_C[1][2];
assign i_C[1][0] = o_C[1][1];
assign o_Q[2]    = o_C[1][0];

//B
assign i_B[1][0] = o_B[0][0];
assign i_B[1][1] = o_B[0][1];
assign i_B[1][2] = o_B[0][2];
assign i_B[1][3] = o_B[0][3];

//A
assign i_A[1][0] = o_S[0][1];
assign i_A[1][1] = o_S[0][2];
assign i_A[1][2] = o_S[0][3];
assign i_A[1][3] = i_x[2];

//=================== row 3 =======================
//P C
assign i_P[2][0] = o_C[1][0];
assign i_P[2][1] = o_P[2][0];
assign i_P[2][2] = o_P[2][1];
assign i_P[2][3] = o_P[2][2];
assign i_C[2][3] = o_P[2][3];
assign i_C[2][2] = o_C[2][3];
assign i_C[2][1] = o_C[2][2];
assign i_C[2][0] = o_C[2][1];
assign o_Q[1]    = o_C[2][0];

//B
assign i_B[2][0] = o_B[1][0];
assign i_B[2][1] = o_B[1][1];
assign i_B[2][2] = o_B[1][2];
assign i_B[2][3] = o_B[1][3];

//A
assign i_A[2][0] = o_S[1][1];
assign i_A[2][1] = o_S[1][2];
assign i_A[2][2] = o_S[1][3];
assign i_A[2][3] = i_x[1];

//=================== row 4 =======================
//P C
assign i_P[3][0] = o_C[2][0];
assign i_P[3][1] = o_P[3][0];
assign i_P[3][2] = o_P[3][1];
assign i_P[3][3] = o_P[3][2];
assign i_C[3][3] = o_P[3][3];
assign i_C[3][2] = o_C[3][3];
assign i_C[3][1] = o_C[3][2];
assign i_C[3][0] = o_C[3][1];
assign o_Q[0]    = o_C[3][0];

//B
assign i_B[3][0] = o_B[2][0];
assign i_B[3][1] = o_B[2][1];
assign i_B[3][2] = o_B[2][2];
assign i_B[3][3] = o_B[2][3];

//A
assign i_A[3][0] = o_S[2][1];
assign i_A[3][1] = o_S[2][2];
assign i_A[3][2] = o_S[2][3];
assign i_A[3][3] = i_x[0];

//=================== final =======================
assign o_R[0] = 0;
assign o_R[1] = 0;
assign o_R[2] = 0;
assign o_R[3] = o_S[3][3];
assign o_R[4] = o_S[3][2];
assign o_R[5] = o_S[3][1];
assign o_R[6] = o_S[3][0];


endmodule

module CAS(
    input        i_A,
    input        i_B,
    input        i_P,
    input        i_C,
    output       o_P,
    output       o_B,
    output       o_S,
    output       o_C
);
    assign o_P = i_P;
    assign o_B = i_B;
    assign o_S = i_A ^ (i_B ^ i_P) ^ i_C;
    assign o_C = ((i_B ^ i_P) & (i_C | i_A))| (i_C & i_A);
endmodule
