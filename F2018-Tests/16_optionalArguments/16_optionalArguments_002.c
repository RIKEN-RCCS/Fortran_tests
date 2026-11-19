#include <stdio.h>

void f_check(int *x);

void c_call(void) {
  int v = 13;
  f_check(&v);
  f_check(NULL);
}
