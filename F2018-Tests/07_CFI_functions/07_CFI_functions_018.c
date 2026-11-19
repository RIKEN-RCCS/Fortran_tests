#include <stdio.h>
#include <string.h>
#include <ISO_Fortran_binding.h>

static void report(const char *what, int rc, const void *dv, const void *saved,
                   size_t size) {
  printf("%s: rc=%d detected=%d unmodified=%d\n", what, rc, rc != CFI_SUCCESS,
         memcmp(dv, saved, size) == 0);
  fflush(stdout);
}

static int arr[5];

void c_errors(void) {
  CFI_CDESC_T(1) d, saved;
  CFI_cdesc_t *dv = (CFI_cdesc_t *)&d;
  CFI_index_t lower[1] = {1}, upper[1] = {4};
  CFI_attribute_t invalid = (CFI_attribute_t)(CFI_attribute_pointer +
      CFI_attribute_allocatable + CFI_attribute_other + 1);
  int rc;

  memset(&d, 0x5a, sizeof d);
  memcpy(&saved, &d, sizeof d);
  rc = CFI_establish(dv, NULL, invalid, CFI_type_int, sizeof(int), 1, NULL);
  report("CFI_establish attribute not in Table 1", rc, &d, &saved, sizeof d);

  CFI_establish(dv, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  memcpy(&saved, &d, sizeof d);
  rc = CFI_allocate(dv, lower, upper, 0);
  report("CFI_allocate attribute other", rc, &d, &saved, sizeof d);

  CFI_CDESC_T(1) ds, dr, savedr;
  CFI_cdesc_t *s = (CFI_cdesc_t *)&ds;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&dr;
  CFI_index_t extents[1] = {5}, lb[1] = {0}, ub[1] = {9}, st[1] = {1};
  CFI_establish(s, arr, CFI_attribute_other, CFI_type_int, sizeof(int), 1, extents);
  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  memcpy(&savedr, &dr, sizeof dr);
  rc = CFI_section(r, s, lb, ub, st);
  report("CFI_section upper bound beyond source", rc, &dr, &savedr, sizeof dr);
}
