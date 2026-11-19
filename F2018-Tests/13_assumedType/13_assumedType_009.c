#include <stdio.h>

void c_peek_first(void *p, int form) {
  static const char *name[] = {"size", "shape", "rank"};
  printf("c_loc %s first=%d\n", name[form], *(int *)p);
  fflush(stdout);
}
