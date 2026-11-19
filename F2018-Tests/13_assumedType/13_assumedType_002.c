#include <stdio.h>

void c_call(void *x, int present_flag) {
  printf("x(1)=%d\n", ((int *)x)[0]);
  fflush(stdout);
}
