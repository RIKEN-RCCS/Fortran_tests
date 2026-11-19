#include <stdio.h>
#include <ISO_Fortran_binding.h>

static int arr[12];

void c_contiguous(void) {
  CFI_CDESC_T(1) d1, r1;
  CFI_CDESC_T(2) d2;
  CFI_cdesc_t *a = (CFI_cdesc_t *)&d1;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&r1;
  CFI_cdesc_t *b = (CFI_cdesc_t *)&d2;
  CFI_index_t ext1[1] = {12}, ext2[2] = {3, 4};
  CFI_index_t lb[1] = {2}, ub[1] = {6}, st1[1] = {1}, st2[1] = {2};
  CFI_index_t lb2[2] = {1, 0}, ub2[2] = {1, 3}, st0[2] = {0, 1};

  CFI_establish(a, arr, CFI_attribute_other, CFI_type_int, sizeof(int), 1, ext1);
  printf("whole array=%d\n", CFI_is_contiguous(a));

  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  CFI_section(r, a, lb, ub, st1);
  printf("section stride 1=%d\n", CFI_is_contiguous(r));

  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  CFI_section(r, a, lb, ub, st2);
  printf("section stride 2=%d\n", CFI_is_contiguous(r));

  CFI_establish(b, arr, CFI_attribute_other, CFI_type_int, sizeof(int), 2, ext2);
  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  CFI_section(r, b, lb2, ub2, st0);
  printf("rank2 row section=%d\n", CFI_is_contiguous(r));
  fflush(stdout);
}
