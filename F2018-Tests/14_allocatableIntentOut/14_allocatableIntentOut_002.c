#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_reset(CFI_cdesc_t *a);

void c_call(void) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *a = (CFI_cdesc_t *)&d;
  CFI_index_t lower[1] = {1}, upper[1] = {3};
  CFI_establish(a, NULL, CFI_attribute_allocatable, CFI_type_int,
               sizeof(int), 1, NULL);
  CFI_allocate(a, lower, upper, 0);
  int null_before = a->base_addr == NULL;
  f_reset(a);
  printf("base_addr_null before call=%d\n", null_before);
  printf("base_addr_null after return=%d\n", a->base_addr == NULL);
  fflush(stdout);
}
