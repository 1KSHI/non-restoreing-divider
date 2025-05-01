#include "include/tb_common.h"
#include <fstream>
#include <iostream>
#include <vector>
#include <algorithm> // 用于排序
#include <numeric>   // 用于计算平均值

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
Vtop* top;

int main(int argc, char *argv[]) {
    sim_init();
    
    reset(1);
    // float a = 8043;
    // float b = 8192;
    // top->dividend =8043;
    // top->divisor = 8192;
    // top->start = 1;
    // cycle(15);
    // printf("quotient: %f\n", a/b);
    // printf("quotient: %f\n", top->quotient/pow(2, 11));
    // printf("error: %f\n", fabs(a/b-top->quotient/pow(2, 11)));
    // printf("error: %f\n", 1/pow(2, 10));
    std::ofstream outfile("output.txt");
    if (!outfile.is_open()) {
        std::cerr << "无法打开文件 output.txt" << std::endl;
        return 1;
    }

    std::vector<double> errors; // 用于存储所有误差

    for (int i = 1; i < 4095; i++) { // 从 1 开始，避免除以 0
        for(int j = 1; j < 4095; j+=100) {

            reset(1);
            float b = i;
            float a = j;
            top->dividend = a;
            top->divisor = b+a;
            top->start = 1;
            cycle(14);

            double true_value = a / (a+b);
            double approx_value = top->quotient / pow(2, 11);
            // printf("true_value: %.10f\n", true_value);
            // printf("approx_value: %.10f\n", approx_value);
            // printf("approx_value: %d\n", top->remainder);
            //remainder
            double error =  fabs(approx_value - true_value);
            errors.push_back(error); // 将误差存入向量

            outfile << "error: " << error << "  a: " << j << "  b: " << i << "  true_value: " << true_value << "  approx_value: " << approx_value << std::endl;
        }
    }

    // 关闭文件
    outfile.close();

    // 对误差进行排序，找出最大的 40 个误差
    std::sort(errors.begin(), errors.end(), [](double a, double b) { return std::abs(a) > std::abs(b); });

    // 输出最大的 40 个误差
    std::cout << "最大的 40 个误差：" << std::endl;
    for (size_t i = 0; i < std::min(errors.size(), size_t(40)); i++) {
        std::cout << "误差 " << i + 1 << ": " << errors[i] << std::endl;
    }

    // 计算误差的平均值
    double average_error = std::accumulate(errors.begin(), errors.end(), 0.0) / errors.size();
    std::cout << "所有误差的平均值: " << average_error << std::endl;

    sim_exit();

    return 0;
}