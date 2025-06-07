module top(
    input       clk,
    input       rst,
    input  [12:0] dividend,  // 被除数
    input  [12:0] divisor,   // 除数
    output [12:0] quotient
);
wire [12:0] i_A [12:0];
wire [12:0] i_B [12:0];
wire [12:0] i_P [12:0];
wire [12:0] i_C [12:0]; 
wire [12:0] o_B [12:0];  
wire [12:0] o_P [12:0]; 
wire [12:0] o_S [12:0];
wire [12:0] o_C [12:0]; 

reg [12:0] i_A_reg [12:0];
reg [12:0] i_B_reg [12:0];
reg [12:0] i_P_reg ;

wire [12:0] i_x;
wire [12:0] i_y;
assign i_x = dividend;
assign i_y = divisor;
wire [12:0] o_Q;

assign quotient  = o_Q;

genvar i,j;
for (i = 0; i < 13; i = i + 1) begin : gen_divisor
    CAS cas (
            .i_A(i_A_reg[i][0]),
            .i_B(i_B_reg[i][0]),
            .i_P(i_P_reg[i]),
            .i_C(i_C[i][0]),
            .o_P(o_P[i][0]),
            .o_B(o_B[i][0]),
            .o_S(o_S[i][0]),
            .o_C(o_C[i][0])
        );
    for (j = 1; j < 13; j = j + 1) begin : gen_dividend
        CAS cas (
            .i_A(i_A_reg[i][j]),
            .i_B(i_B_reg[i][j]),
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
    assign i_P[0][0 ] = 1;
for (i = 1; i <= 12; i = i + 1) begin : row1p
    assign i_P[0][i ] = o_P[0][i-1 ];
end
    assign i_C[0][12] = o_P[0][12];
for (i = 1; i <= 12; i = i + 1) begin : row1c
    assign i_C[0][i-1] = o_C[0][i];
end
    assign o_Q[12]     = o_C[0][0 ];

//B
for (i = 0; i <= 12; i = i + 1) begin : row1b
    assign i_B[0][i] = i_y[12-i];
end

//A
for (i = 0; i <= 12; i = i + 1) begin : row1a
    assign i_A[0][i] = i_x[12-i];
end

//=================== row 2 =======================
for (j = 1; j <= 12; j = j + 1) begin
        assign i_P[j][0 ] = o_C[j-1][0];
    for (i = 1; i <= 12; i = i + 1) begin : rowp
        assign i_P[j][i ] = o_P[j][i-1 ];
    end
        assign i_C[j][12] = o_P[j][12];
    for (i = 1; i <= 12; i = i + 1) begin : rowc
        assign i_C[j][i-1] = o_C[j][i];
    end
        assign o_Q[12-j]     = o_C[j][0 ];

    //B
    for (i = 0; i <= 12; i = i + 1) begin : rowb
        assign i_B[j][i] = i_B[j-1][i];
    end

    //A
    for (i = 0; i <= 11; i = i + 1) begin : rowa
        assign i_A[j][i] = o_S[j-1][i+1];
    end
    assign i_A[j][12] = 0;
end

for (i = 1; i < 13; i = i + 2) begin : getreg0
    for (j = 0; j < 13; j = j + 1) begin : getreg0
        always @(posedge clk) begin
            i_A_reg[i][j] <= i_A[i][j];
            i_B_reg[i][j] <= i_B[i][j];
        end
    end
    always @(posedge clk) begin
        i_P_reg[i]    <= i_P[i][0];
    end
end

for (i = 0; i < 13; i = i + 2) begin : getreg1
    for (j = 0; j < 13; j = j + 1) begin : getreg1
        always @(*) begin
            i_A_reg[i][j] = i_A[i][j];
            i_B_reg[i][j] = i_B[i][j];
        end
    end
    always @(*) begin
        i_P_reg[i]    = i_P[i][0];
    end
end

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
