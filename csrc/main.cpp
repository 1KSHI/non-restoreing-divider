#include "include/tb_common.h"

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
Vtop* top;


int main(int argc, char *argv[]) {
    sim_init();
    
    reset(1);
    float num = 30;
    int num_int = (int)num;
    top->dividend = num;
    top->start = 1;
    
    printf("D = %d\n", num_int);
    cycle(20);
    printf("1/D = %f\n", top->quotient/pow(2,12));
    printf("true = %f\n", 1/num);
    sim_exit();

    return 0;
}
