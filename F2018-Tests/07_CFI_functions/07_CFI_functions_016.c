#include <stdio.h>
#include <string.h>
#include <ISO_Fortran_binding.h>

static void report(const char *what, int rc, const void *dv, const void *saved,
                   size_t size) {
  printf("%s: rc=%d detected=%d unmodified=%d\n", what, rc, rc != CFI_SUCCESS,
         memcmp(dv, saved, size) == 0);
  fflush(stdout);
}

static int storage[4];

void c_errors(void) {
  CFI_CDESC_T(1) d, saved;
  CFI_cdesc_t *dv = (CFI_cdesc_t *)&d;
  CFI_index_t extents[1] = {4};
  int rc;

  memset(&d, 0x5a, sizeof d);
  memcpy(&saved, &d, sizeof d);
  rc = CFI_establish(dv, storage, CFI_attribute_allocatable, CFI_type_int,
                     sizeof(int), 1, extents);
  report("CFI_establish allocatable non-null base_addr", rc, &d, &saved, sizeof d);

  CFI_establish(dv, NULL, CFI_attribute_allocatable, CFI_type_int, sizeof(int), 1, NULL);
  memcpy(&saved, &d, sizeof d);
  rc = CFI_deallocate(dv);
  report("CFI_deallocate unallocated object", rc, &d, &saved, sizeof d);
}
