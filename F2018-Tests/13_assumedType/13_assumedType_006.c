#include <stdio.h>

void c_peek(void *p) {
  printf("c_loc int=%d\n", *(int *)p);
  fflush(stdout);
}
