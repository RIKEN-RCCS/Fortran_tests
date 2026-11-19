#include <stdio.h>
#include <ISO_Fortran_binding.h>

int c_is_contiguous(CFI_cdesc_t *a) {
  return CFI_is_contiguous(a);
}
