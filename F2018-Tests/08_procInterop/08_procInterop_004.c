#include <stdio.h>

void c_show_scalar(void *x, int kind) {
  if (kind == 0)
    printf("int scalar=%d\n", *(int *)x);
  else
    printf("double scalar=%.1f\n", *(double *)x);
  fflush(stdout);
}

void c_show_array(void *x, int n) {
  printf("int array");
  for (int i = 0; i < n; i++) printf(" %d", ((int *)x)[i]);
  printf("\n");
  fflush(stdout);
}
