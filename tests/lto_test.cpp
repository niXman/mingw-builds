#include <iostream>
#include <time.h>

#include "lto_int.h"

int main(int argc, char* const argv[])
{
  int i1, i2, i3;
  Int int1, int2, int3;
  double sum;

  clock_t start, end;
  double cpu_time_used;

  sum = 0.0;
  start = clock();
  for (int i = 0; i < 1000000000; i++)
  {
    i1 = i;
    i2 = i + 1;
    i3 = i1 +i2;
    sum = sum + i3;
  }
  end = clock();
  cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
  std::cout << sum << std::endl;
  std::cout << cpu_time_used << std::endl;

  sum = 0.0;
  start = clock();
  for (int i = 0; i < 1000000000; i++)
  {
    int1 = i;
    int2 = i + 1;
    int3 = int1 +int2;
    sum = sum + int3.value;
  }
  end = clock();
  cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
  std::cout << sum << std::endl;
  std::cout << cpu_time_used << std::endl;

  return 0;
}
