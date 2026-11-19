#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_select_real_part(CFI_cdesc_t *z) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&d;
  int rc;
  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_double, sizeof(double), 1, NULL);
  rc = CFI_select_part(r, z, 0, 0);
  printf("complex real part: rc=%d elem_len_ok=%d sm_ok=%d values", rc,
         r->elem_len == sizeof(double), r->dim[0].sm == z->dim[0].sm);
  if (rc == CFI_SUCCESS)
    for (CFI_index_t i = 0; i < r->dim[0].extent; i++) {
      CFI_index_t sub[1] = {r->dim[0].lower_bound + i};
      printf(" %.1f", *(double *)CFI_address(r, sub));
    }
  printf("\n");
  fflush(stdout);
}
