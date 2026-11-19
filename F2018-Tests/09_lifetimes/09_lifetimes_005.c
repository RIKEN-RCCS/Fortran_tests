#include <stdio.h>

static int *saved;

void c_start(int *x) {
  saved = x;
  printf("c_start ptr_null=%d\n", saved == NULL);
  fflush(stdout);
}

void c_complete(void) {
  printf("saved a=");
  for (int i = 0; i < 3; i++) {
    printf(" %d", saved[i]);
  }
  printf("\n");
  saved[1] = 99;
  fflush(stdout);
}
