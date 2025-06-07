
module res_div (
    input clk,
    input rst,
    input start,
    input  [12:0] dividend,
    input  [12:0] divisor,
    output [11:0] quotient,
    output reg done
);
//流水线寄存器,加一符号位
reg  signed [13:0] dd [0:11];
reg  signed [13:0] ds [0:11];
reg         [11:0] qo [0:10];
reg         [10:0] sign;
reg         [11:0] done_reg;

//========== cycle init  ===============
wire signed [13:0] cal_0;
wire signed [13:0] cal_0r;
wire signed [13:0] dd_0 = {1'b0,dividend};
wire signed [13:0] ds_0 = {1'b0,divisor};
wire sign_0;
wire sign_0r;
assign cal_0 = dd_0 - ds_0;
assign sign_0 = cal_0[13];

always @(posedge clk) begin
    if (rst) begin
        dd[0] <= 0;
        ds[0] <= 0;
        done_reg[0] <= 1'b0;
    end else if (start) begin
        dd[0] <= {cal_0[12:0],1'b0};
        ds[0] <= ds_0;
        done_reg[0] <= done_reg[0];
    end
end

assign cal_0r = sign_0?dd[0] + ds[0]:dd[0] - ds[0];
assign sign_0r = cal_0r[13];
//========== cycle 1  ===============
wire signed [13:0] dd_1;
wire signed [13:0] ds_1;
wire signed [13:0] cal_1;
wire signed [13:0] cal_1r;
wire        [11:0] qo_1;
wire        sign_1;
wire        sign_1r;

assign dd_1 = {cal_0r[12:0],1'b0};
assign ds_1 = ds[0];
assign qo_1 = sign_0r?{12'b000000000000}:{12'b100000000000};

assign cal_1 = sign_0r?dd_1 + ds_1:dd_1 - ds_1;
assign sign_1 = cal_1[13];  

always @(posedge clk) begin
    if (rst) begin
        dd[1] <= 0;
        ds[1] <= 0;
        qo[0] <= 0;
        done_reg[1] <= 1'b0;
    end else if (start) begin
        dd[1] <= {cal_1[12:0],1'b0};
        ds[1] <= ds_1;
        if (sign_1) begin
            qo[0] <= {qo_1[11],11'b00000000000};
        end else begin
            qo[0] <= {qo_1[11],11'b10000000000};
        end
        done_reg[1] <= done_reg[0];
    end
end
assign cal_1r = sign_1?dd[1] + ds[1]:dd[1] - ds[1];
assign sign_1r = cal_1r[13];
//========== cycle 2  ===============
wire signed [13:0] dd_2;
wire signed [13:0] ds_2;
wire signed [13:0] cal_2;
wire signed [13:0] cal_2r;
wire        [11:0] qo_2;
wire        sign_2;
wire        sign_2r;


assign dd_2 = {cal_1r[12:0],1'b0};
assign ds_2 = ds[1];
assign qo_2 = sign_1r?{qo[0][11:10],10'b0000000000}:{qo[0][11:10],10'b1000000000};

assign cal_2 = sign_1r?dd_2 + ds_2:dd_2 - ds_2;
assign sign_2 = cal_2[13];  

always @(posedge clk) begin
    if (rst) begin
        dd[2] <= 0;
        ds[2] <= 0;
        qo[1] <= 0;
        done_reg[2] <= 1'b0;
    end else if (start) begin
        dd[2] <= {cal_2[12:0],1'b0};
        ds[2] <= ds_2;
        if (sign_2) begin
            qo[1] <= {qo_2[11:9],9'b000000000};
        end else begin
            qo[1] <= {qo_2[11:9],9'b100000000};
        end
        done_reg[2] <= done_reg[3];
    end
end
assign cal_2r = sign_2?dd[2] + ds[2]:dd[2] - ds[2];
assign sign_2r = cal_2r[13];
//========== cycle 3  ===============
wire signed [13:0] dd_3;
wire signed [13:0] ds_3;
wire signed [13:0] cal_3;
wire signed [13:0] cal_3r;
wire        [11:0] qo_3;
wire        sign_3;
wire        sign_3r;

assign dd_3 = {cal_2r[12:0],1'b0};
assign ds_3 = ds[2];
assign qo_3 = sign_2r?{qo[1][11:8],8'b00000000}:{qo[1][11:8],8'b10000000};

assign cal_3 = sign_2r?dd_3 + ds_3:dd_3 - ds_3;
assign sign_3 = cal_3[13];
always @(posedge clk) begin
    if (rst) begin
        dd[3] <= 0;
        ds[3] <= 0;
        qo[2] <= 0;
        done_reg[3] <= 1'b0;
    end else if (start) begin
        dd[3] <= {cal_3[12:0],1'b0};
        ds[3] <= ds_3;
        if (sign_3) begin
            qo[2] <= {qo_3[11:7],7'b0000000};
        end else begin
            qo[2] <= {qo_3[11:7],7'b1000000};
        end
        done_reg[3] <= done_reg[4];
    end 
end
assign cal_3r = sign_3?dd[3] + ds[3]:dd[3] - ds[3];
assign sign_3r = cal_3r[13];
//========== cycle 4  ===============
wire signed [13:0] dd_4;
wire signed [13:0] ds_4;
wire signed [13:0] cal_4;
wire signed [13:0] cal_4r;
wire        [11:0] qo_4;
wire        sign_4;
wire        sign_4r;

assign dd_4 = {cal_3r[12:0],1'b0};
assign ds_4 = ds[3];
assign qo_4 = sign_3r?{qo[2][11:6],6'b000000}:{qo[2][11:6],6'b100000};

assign cal_4 = sign_3r?dd_4 + ds_4:dd_4 - ds_4;
always @(posedge clk) begin
    if (rst) begin
        dd[4] <= 0;
        ds[4] <= 0;
        qo[3] <= 0;
        done_reg[4] <= 1'b0;
    end else if (start) begin
        dd[4] <= {cal_4[12:0],1'b0};
        ds[4] <= ds_4;
        if (sign_4) begin
            qo[3] <= {qo_4[11:5],5'b00000};
        end else begin
            qo[3] <= {qo_4[11:5],5'b10000};
        end
        done_reg[4] <= done_reg[5];
    end 
end
assign cal_4r = sign_4?dd[4] + ds[4]:dd[4] - ds[4];
assign sign_4r = cal_4r[13];
//========== cycle 5  ===============
wire signed [13:0] dd_5;
wire signed [13:0] ds_5;
wire signed [13:0] cal_5;
wire signed [13:0] cal_5r;
wire        [11:0] qo_5;
wire        sign_5;
wire        sign_5r;
assign dd_5 = {cal_4r[12:0],1'b0};
assign ds_5 = ds[4];
assign qo_5 = sign_4r?{qo[3][11:4],4'b0000}:{qo[3][11:4],4'b1000};
assign cal_5 = sign_4r?dd_5 + ds_5:dd_5 - ds_5;
always @(posedge clk) begin
    if (rst) begin
        dd[5] <= 0;
        ds[5] <= 0;
        qo[4] <= 0;
        done_reg[5] <= 1'b0;
    end else if (start) begin
        dd[5] <= {cal_5[12:0],1'b0};
        ds[5] <= ds_5;
        if (sign_5) begin
            qo[4] <= {qo_5[11:3],3'b000};
        end else begin
            qo[4] <= {qo_5[11:3],3'b100};
        end
        done_reg[5] <= done_reg[6];
    end 
end
assign cal_5r = sign_5?dd[5] + ds[5]:dd[5] - ds[5];
assign sign_5r = cal_5r[13];
//========== cycle 6  ===============
wire signed [13:0] dd_6;
wire signed [13:0] ds_6;
wire signed [13:0] cal_6;
wire signed [13:0] cal_6r;
wire        [11:0] qo_6;
wire        sign_6;
assign dd_6 = {cal_5r[12:0],1'b0};
assign ds_6 = ds[5];
assign qo_6 = sign_5r?{qo[4][11:2],2'b00}:{qo[4][11:2],2'b10};
assign cal_6 = sign_5r?dd_6 + ds_6:dd_6 - ds_6;
always @(posedge clk) begin
    if (rst) begin
        dd[6] <= 0;
        ds[6] <= 0;
        qo[5] <= 0;
        done_reg[6] <= 1'b0;
    end else if (start) begin
        dd[6] <= {cal_6[12:0],1'b0};
        ds[6] <= ds_6;
        if (sign_6) begin
            qo[5] <= {qo_6[11:1],1'b0};
        end else begin
            qo[5] <= {qo_6[11:1],1'b1};
        end
        done_reg[6] <= done_reg[7];
    end 
end

assign quotient = qo[5][11:0];


endmodule
