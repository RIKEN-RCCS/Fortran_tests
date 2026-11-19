#include <stdio.h>
#include <ISO_Fortran_binding.h>

static int storage[1];

void c_establish_zero_extent(void) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *dv = (CFI_cdesc_t *)&d;
  CFI_index_t extents[1] = {0};
  int rc = CFI_establish(dv, storage, CFI_attribute_other, CFI_type_int,
                         sizeof(int), 1, extents);
  printf("extent 0: rc=%d rank=%d extent=%ld\n", rc, (int)dv->rank,
         (long)dv->dim[0].extent);
  fflush(stdout);
}
