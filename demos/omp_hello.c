#include <stdio.h>

int main(int argc, char* argv[])
{
   printf("Obey your master!\n");
#pragma omp parallel
 {
   printf("Slave to the grind\n");
 }
   printf("Back with master\n");
}
