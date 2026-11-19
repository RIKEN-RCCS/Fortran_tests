#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_show(int stride, CFI_cdesc_t *s);

void c_section_rank1(CFI_cdesc_t *a) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&d;
  CFI_index_t lb[1], ub[1], st[1];
  int rc;

  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  lb[0] = a->dim[0].lower_bound + 1;
  ub[0] = a->dim[0].lower_bound + 7;
  st[0] = 3;
  rc = CFI_section(r, a, lb, ub, st);
  printf("CFI_section stride=3 rc=%d\n", rc);
  fflush(stdout);
  if (rc == CFI_SUCCESS) f_show(3, r);

  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  lb[0] = a->dim[0].lower_bound + 8;
  ub[0] = a->dim[0].lower_bound + 2;
  st[0] = -3;
  rc = CFI_section(r, a, lb, ub, st);
  printf("CFI_section stride=-3 rc=%d\n", rc);
  fflush(stdout);
  if (rc == CFI_SUCCESS) f_show(-3, r);
}

void c_section_rank2(CFI_cdesc_t *b) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&d;
  CFI_index_t lb[2] = {b->dim[0].lower_bound + 1, b->dim[1].lower_bound};
  CFI_index_t ub[2] = {b->dim[0].lower_bound + 1, b->dim[1].lower_bound + 3};
  CFI_index_t st[2] = {0, 1};
  int rc;
  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  rc = CFI_section(r, b, lb, ub, st);
  printf("CFI_section stride=0 rc=%d rank=%d\n", rc, (int)r->rank);
  fflush(stdout);
  if (rc == CFI_SUCCESS) f_show(0, r);
}
