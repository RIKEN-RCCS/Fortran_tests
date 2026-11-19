#include <stdio.h>
#include <stddef.h>
#include <ISO_Fortran_binding.h>

typedef struct { int i; double d; } pt;

static void show_double_section(const char *label, CFI_cdesc_t *r) {
  printf("%s", label);
  for (CFI_index_t i = 0; i < r->dim[0].extent; i++) {
    CFI_index_t sub[1] = {r->dim[0].lower_bound + i};
    printf(" %.1f", *(double *)CFI_address(r, sub));
  }
  printf("\n");
}

void c_select_struct(CFI_cdesc_t *a) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&d;
  int rc;
  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_double, sizeof(double), 1, NULL);
  rc = CFI_select_part(r, a, offsetof(pt, d), 0);
  printf("struct component: rc=%d elem_len_ok=%d sm_ok=%d values", rc,
         r->elem_len == sizeof(double), r->dim[0].sm == a->dim[0].sm);
  fflush(stdout);
  if (rc == CFI_SUCCESS) show_double_section("", r);
  else printf("\n");
}

void c_select_complex(CFI_cdesc_t *z) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&d;
  int rc;
  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_double, sizeof(double), 1, NULL);
  rc = CFI_select_part(r, z, sizeof(double), 0);
  printf("complex imaginary part: rc=%d elem_len_ok=%d sm_ok=%d values", rc,
         r->elem_len == sizeof(double), r->dim[0].sm == z->dim[0].sm);
  fflush(stdout);
  if (rc == CFI_SUCCESS) show_double_section("", r);
  else printf("\n");
}
