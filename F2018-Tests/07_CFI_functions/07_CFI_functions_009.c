#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_show(int label, CFI_cdesc_t *s);

void c_section_defaults(CFI_cdesc_t *a) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&d;
  CFI_index_t lb0 = a->dim[0].lower_bound;
  CFI_index_t lb[1] = {lb0 + 1}, ub[1] = {lb0 + 3}, ub6[1] = {lb0 + 5},
              st[1] = {2};
  int rc;

  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  rc = CFI_section(r, a, NULL, ub6, st);
  printf("CFI_section lower_bounds=NULL rc=%d\n", rc);
  fflush(stdout);
  if (rc == CFI_SUCCESS) f_show(1, r);

  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  rc = CFI_section(r, a, lb, NULL, st);
  printf("CFI_section upper_bounds=NULL rc=%d\n", rc);
  fflush(stdout);
  if (rc == CFI_SUCCESS) f_show(2, r);

  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  rc = CFI_section(r, a, lb, ub, NULL);
  printf("CFI_section strides=NULL rc=%d\n", rc);
  fflush(stdout);
  if (rc == CFI_SUCCESS) f_show(3, r);

  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  rc = CFI_section(r, a, NULL, NULL, NULL);
  printf("CFI_section all NULL rc=%d\n", rc);
  fflush(stdout);
  if (rc == CFI_SUCCESS) f_show(4, r);
}
