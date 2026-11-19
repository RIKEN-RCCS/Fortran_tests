#include <stdio.h>

void c_show_int(void *x) {
  printf("int=%d\n", *(int *)x);
  fflush(stdout);
}
void c_show_double(void *x) {
  printf("double=%.1f\n", *(double *)x);
  fflush(stdout);
}
