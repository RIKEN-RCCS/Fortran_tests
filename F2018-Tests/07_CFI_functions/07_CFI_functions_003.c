#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_ptr(CFI_cdesc_t *p);

static int target[4] = {11, 12, 13, 14};

void c_establish_pointer(void) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *p = (CFI_cdesc_t *)&d;
  CFI_index_t extents[1] = {4};
  int rc = CFI_establish(p, target, CFI_attribute_pointer, CFI_type_int,
                         sizeof(int), 1, extents);
  printf("CFI_establish rc=%d lower_bound=%ld extent=%ld\n", rc,
         (long)p->dim[0].lower_bound, (long)p->dim[0].extent);
  fflush(stdout);
  f_ptr(p);
}
