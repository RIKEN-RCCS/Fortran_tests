#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_show(CFI_cdesc_t *a);

static double arr[6] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0};

void c_establish_array(void) {
  CFI_CDESC_T(2) d;
  CFI_cdesc_t *dv = (CFI_cdesc_t *)&d;
  CFI_index_t extents[2] = {2, 3};
  int rc = CFI_establish(dv, arr, CFI_attribute_other, CFI_type_double,
                         sizeof(double), 2, extents);
  printf("CFI_establish rc=%d\n", rc);
  printf("base_addr_ok=%d elem_len_ok=%d version_ok=%d\n",
         dv->base_addr == (void *)arr, dv->elem_len == sizeof(double),
         dv->version == CFI_VERSION);
  printf("rank=%d type_ok=%d attribute_ok=%d\n", (int)dv->rank,
         dv->type == CFI_type_double, dv->attribute == CFI_attribute_other);
  printf("dim0 lower_bound=%ld extent=%ld sm_ok=%d\n",
         (long)dv->dim[0].lower_bound, (long)dv->dim[0].extent,
         dv->dim[0].sm == (CFI_index_t)sizeof(double));
  printf("dim1 lower_bound=%ld extent=%ld sm_ok=%d\n",
         (long)dv->dim[1].lower_bound, (long)dv->dim[1].extent,
         dv->dim[1].sm == (CFI_index_t)(2 * sizeof(double)));
  fflush(stdout);
  f_show(dv);
}
