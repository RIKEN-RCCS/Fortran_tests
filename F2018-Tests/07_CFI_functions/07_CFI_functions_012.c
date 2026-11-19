#include <stdio.h>
#include <ISO_Fortran_binding.h>

static int at(CFI_cdesc_t *dv, CFI_index_t i, CFI_index_t j) {
  CFI_index_t sub[2] = {i, j};
  return *(int *)CFI_address(dv, sub);
}

void c_address_alloc(CFI_cdesc_t *a) {
  printf("allocatable lower_bounds=%ld %ld\n", (long)a->dim[0].lower_bound,
         (long)a->dim[1].lower_bound);
  printf("a(2,0)=%d a(4,0)=%d a(3,1)=%d\n", at(a, 2, 0), at(a, 4, 0), at(a, 3, 1));
  fflush(stdout);
}

void c_address_other(CFI_cdesc_t *b) {
  CFI_index_t s0[1] = {0}, s3[1] = {3};
  printf("other lower_bound=%ld\n", (long)b->dim[0].lower_bound);
  printf("b(0)=%d b(3)=%d\n", *(int *)CFI_address(b, s0), *(int *)CFI_address(b, s3));
  fflush(stdout);
}

void c_address_scalar(CFI_cdesc_t *x) {
  printf("scalar NULL subscripts=%d\n", *(int *)CFI_address(x, NULL));
  fflush(stdout);
}
