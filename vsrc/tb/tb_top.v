`timescale 1ns / 1ps

module tb_top();

    // 输入信号
    reg [12:0] dividend;
    reg [12:0] divisor;
    reg clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns周期的时钟信号
    end
    
    // 输出信号
    wire [12:0] quotient;
    
    // 实例化被测试模块
    top top (
        .clk(clk),
        .rst(1'b0), // 复位信号
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient)
    );
    
    // 测试过程
    initial begin
        // 初始化输入
        dividend = 0;
        divisor = 0;
        #10;
        
        // 测试用例
        dividend = 13'b0_0000_0000_0011;
        divisor  = 13'b0_0000_0000_0100;
        #60;
        $display("Dividend = %b, Divisor = %b, Quotient = %b", 
                 dividend, divisor, quotient);
        #10;


        $display("\nSimulation finished");
        $finish;
    end
    
endmodule
