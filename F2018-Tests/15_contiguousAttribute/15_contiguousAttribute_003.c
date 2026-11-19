#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_show(CFI_cdesc_t *a);
void f_show_nc(CFI_cdesc_t *a);

static int arr[6] = {1, 2, 3, 4, 5, 6};

void c_call(void) {
  CFI_CDESC_T(1) d1, d2;
  CFI_cdesc_t *a = (CFI_cdesc_t *)&d1;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&d2;
  CFI_index_t ext[1] = {6}, lb[1] = {0}, ub[1] = {4}, st[1] = {2};
  CFI_establish(a, arr, CFI_attribute_other, CFI_type_int, sizeof(int), 1, ext);
  CFI_establish(r, NULL, CFI_attribute_pointer, CFI_type_int, sizeof(int), 1, NULL);
  CFI_section(r, a, lb, ub, st);
  printf("is_contiguous=%d\n", CFI_is_contiguous(r));
  fflush(stdout);
  f_show(r);
  f_show_nc(r);
}
