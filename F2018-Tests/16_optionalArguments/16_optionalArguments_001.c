#include <stdio.h>

void c_take(int *x) {
  if (x != NULL)
    printf("c_take present null=0 value=%d\n", *x);
  else
    printf("c_take absent null=1\n");
  fflush(stdout);
}
