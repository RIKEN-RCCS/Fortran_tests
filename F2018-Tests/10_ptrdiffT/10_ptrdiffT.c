#include <stddef.h>
#include <stdint.h>

size_t c_ptrdiff_size(void) { return sizeof(ptrdiff_t); }

ptrdiff_t c_diff(int *a, int *b) { return a - b; }

ptrdiff_t c_ptrdiff_max(void) { return PTRDIFF_MAX; }

ptrdiff_t c_neg_ptrdiff_max(void) { return -PTRDIFF_MAX; }
