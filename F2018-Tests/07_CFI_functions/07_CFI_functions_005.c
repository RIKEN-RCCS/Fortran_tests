#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_setpointer(CFI_cdesc_t *p, CFI_cdesc_t *q, int mode) {
  CFI_index_t lower_bounds[1] = {-2};
  int rc;
  if (mode == 1)
    rc = CFI_setpointer(p, q, lower_bounds);
  else if (mode == 2)
    rc = CFI_setpointer(p, q, NULL);
  else
    rc = CFI_setpointer(p, NULL, NULL);
  printf("CFI_setpointer %s: rc=%d\n",
         mode == 1 ? "lower_bounds=-2" : mode == 2 ? "lower_bounds=NULL" : "source=NULL",
         rc);
  fflush(stdout);
}
