#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_select_imag_rank2(CFI_cdesc_t *z) {
  CFI_CDESC_T(2) d;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&d;
  int rc;
  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_double, sizeof(double), 2, NULL);
  rc = CFI_select_part(r, z, sizeof(double), 0);
  printf("rank 2: rc=%d rank=%d elem_len_ok=%d extents=%ld,%ld sm_ok=%d values", rc,
         (int)r->rank, r->elem_len == sizeof(double), (long)r->dim[0].extent,
         (long)r->dim[1].extent,
         r->dim[0].sm == z->dim[0].sm && r->dim[1].sm == z->dim[1].sm);
  if (rc == CFI_SUCCESS)
    for (CFI_index_t j = 0; j < r->dim[1].extent; j++)
      for (CFI_index_t i = 0; i < r->dim[0].extent; i++) {
        CFI_index_t sub[2] = {r->dim[0].lower_bound + i, r->dim[1].lower_bound + j};
        printf(" %.1f", *(double *)CFI_address(r, sub));
      }
  printf("\n");
  fflush(stdout);
}
