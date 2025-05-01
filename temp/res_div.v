
module res_div (
    input clk,
    input rst,
    input start,
    input  [11:0] dividend,
    input  [11:0] divisor,
    output [11:0] quotient,
    output [11:0] remainder,
    output done
);
reg [11:0] dd[0:11];
reg [11:0] ds[0:11];
reg [11:0] qo[0:11];
reg [11:0] dd_r[0:11];
wire signed [11:0] ddsub[0:11];

//========== cycle 0  ===============


always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[0] <= 0;
        ds[0] <= 0;
        qo[0] <= 0;
        dd_r[0] <= 0;
    end else if (start) begin
        dd_r[0] <= dividend;
        dd[0] <= {11'b0,dividend[11]};
        ds[0] <= divisor;
        qo[0] <= 0;
    end
end
//========== cycle 1  ===============
assign ddsub[1] = dd[0] - ds[0];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[1] <= 0;
        ds[1] <= 0;
        qo[1] <= 0;
        dd_r[1] <= 0;
    end else if (start) begin
        if(ddsub[1]>=0)begin//除数大于被除数
            dd[1] <= {ddsub[1][10:0],dd_r[0][10]};
            ds[1] <= ds[0];
            qo[1][11] <= 1'b1;
        end else begin
            dd[1] <= {10'b0,dd_r[0][11:10]};
            ds[1] <= ds[0];
            qo[1] <= qo[0];
        end
        dd_r[1] <= dd_r[0];
    end
end
//========== cycle 2  ===============
assign ddsub[2] = dd[1] - ds[1];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[2] <= 0;
        ds[2] <= 0;
        qo[2] <= 0;
        dd_r[2] <= 0;
    end else if (start) begin
        if(ddsub[2]>=0)begin//除数大于被除数
            dd[2] <= {ddsub[2][10:0],dd_r[1][9]};
            ds[2] <= ds[1];
            qo[2][11:10] <= {qo[1][11],1'b1};
        end else begin
            dd[2] <= {9'b0,dd_r[1][11:9]};
            ds[2] <= ds[1];
            qo[2] <= qo[1];
        end
        dd_r[2] <= dd_r[1];
    end
end
//========== cycle 3  ===============
assign ddsub[3] = dd[2] - ds[2];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[3] <= 0;
        ds[3] <= 0;
        qo[3] <= 0;
        dd_r[3] <= 0;
    end else if (start) begin
        if(ddsub[3]>=0)begin//除数大于被除数
            dd[3] <= {ddsub[3][10:0],dd_r[2][8]};
            ds[3] <= ds[2];
            qo[3][11:9] <= {qo[2][11:10],1'b1};
        end else begin
            dd[3] <= {8'b0,dd_r[2][11:8]};
            ds[3] <= ds[2];
            qo[3] <= qo[2];
        end
        dd_r[3] <= dd_r[2];
    end
end
//========== cycle 4  ===============
assign ddsub[4] = dd[3] - ds[3];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[4] <= 0;
        ds[4] <= 0;
        qo[4] <= 0;
        dd_r[4] <= 0;
    end else if (start) begin
        if(ddsub[4]>=0)begin//除数大于被除数
            dd[4] <= {ddsub[4][10:0],dd_r[3][7]};
            ds[4] <= ds[3];
            qo[4][11:8] <= {qo[3][11:9],1'b1};
        end else begin
            dd[4] <= {7'b0,dd_r[3][11:7]};
            ds[4] <= ds[3];
            qo[4] <= qo[3];
        end
        dd_r[4] <= dd_r[3];
    end
end
//========== cycle 5  ===============
assign ddsub[5] = dd[4] - ds[4];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[5] <= 0;
        ds[5] <= 0;
        qo[5] <= 0;
        dd_r[5] <= 0;
    end else if (start) begin
        if(ddsub[5]>=0)begin//除数大于被除数
            dd[5] <= {ddsub[5][10:0],dd_r[4][6]};
            ds[5] <= ds[4];
            qo[5][11:7] <= {qo[4][11:8],1'b1};
        end else begin
            dd[5] <= {6'b0,dd_r[4][11:6]};
            ds[5] <= ds[4];
            qo[5] <= qo[4];
        end
        dd_r[5] <= dd_r[4];
    end
end
//========== cycle 6  ===============
assign ddsub[6] = dd[5] - ds[5];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[6] <= 0;
        ds[6] <= 0;
        qo[6] <= 0;
        dd_r[6] <= 0;
    end else if (start) begin
        if(ddsub[6]>=0)begin//除数大于被除数
            dd[6] <= {ddsub[6][10:0],dd_r[5][5]};
            ds[6] <= ds[5];
            qo[6][11:6] <= {qo[5][11:7],1'b1};
        end else begin
            dd[6] <= {5'b0,dd_r[5][11:5]};
            ds[6] <= ds[5];
            qo[6] <= qo[5];
        end
        dd_r[6] <= dd_r[5];
    end
end
//========== cycle 7  ===============
assign ddsub[7] = dd[6] - ds[6];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[7] <= 0;
        ds[7] <= 0;
        qo[7] <= 0;
        dd_r[7] <= 0;
    end else if (start) begin
        if(ddsub[7]>=0)begin//除数大于被除数
            dd[7] <= {ddsub[7][10:0],dd_r[6][4]};
            ds[7] <= ds[6];
            qo[7][11:5] <= {qo[6][11:6],1'b1};
        end else begin
            dd[7] <= {4'b0,dd_r[6][11:4]};
            ds[7] <= ds[6];
            qo[7] <= qo[6];
        end
        dd_r[7] <= dd_r[6];
    end
end
//========== cycle 8  ===============
assign ddsub[8] = dd[7] - ds[7];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[8] <= 0;
        ds[8] <= 0;
        qo[8] <= 0;
        dd_r[8] <= 0;
    end else if (start) begin
        if(ddsub[8]>=0)begin//除数大于被除数
            dd[8] <= {ddsub[8][10:0],dd_r[7][3]};
            ds[8] <= ds[7];
            qo[8][11:4] <= {qo[7][11:5],1'b1};
        end else begin
            dd[8] <= {3'b0,dd_r[7][11:3]};
            ds[8] <= ds[7];
            qo[8] <= qo[7];
        end
        dd_r[8] <= dd_r[7];
    end
end
//========== cycle 9  ===============
assign ddsub[9] = dd[8] - ds[8];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[9] <= 0;
        ds[9] <= 0;
        qo[9] <= 0;
        dd_r[9] <= 0;
    end else if (start) begin
        if(ddsub[9]>=0)begin//除数大于被除数
            dd[9] <= {ddsub[9][10:0],dd_r[8][2]};
            ds[9] <= ds[8];
            qo[9][11:3] <= {qo[8][11:4],1'b1};
        end else begin
            dd[9] <= {2'b0,dd_r[8][11:2]};
            ds[9] <= ds[8];
            qo[9] <= qo[8];
        end
        dd_r[9] <= dd_r[8];
    end
end
//========== cycle 10  ===============
assign ddsub[10] = dd[9] - ds[9];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[10] <= 0;
        ds[10] <= 0;
        qo[10] <= 0;
        dd_r[10] <= 0;
    end else if (start) begin
        if(ddsub[10]>=0)begin//除数大于被除数
            dd[10] <= {ddsub[10][10:0],dd_r[9][1]};
            ds[10] <= ds[9];
            qo[10][11:2] <= {qo[9][11:3],1'b1};
        end else begin
            dd[10] <= {1'b0,dd_r[9][11:1]};
            ds[10] <= ds[9];
            qo[10] <= qo[9];
        end
        dd_r[10] <= dd_r[9];
    end
end
//========== cycle 11  ===============
assign ddsub[11] = dd[10] - ds[10];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dd[11] <= 0;
        ds[11] <= 0;
        qo[11] <= 0;
        dd_r[11] <= 0;
    end else if (start) begin
        if(ddsub[11]>=0)begin//除数大于被除数
            dd[11] <= {ddsub[11][10:0],dd_r[10][0]};
            ds[11] <= ds[10];
            qo[11][11:1] <= {qo[10][11:2],1'b1};
        end else begin
            dd[11] <= {dd_r[10][11:0]};
            ds[11] <= ds[10];
            qo[11] <= qo[10];
        end
        dd_r[11] <= dd_r[10];
    end
end

assign quotient = qo[11];
assign remainder = dd[11];
        
endmodule
