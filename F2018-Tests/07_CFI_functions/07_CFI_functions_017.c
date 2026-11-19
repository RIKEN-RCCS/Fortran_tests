#include <stdio.h>
#include <string.h>
#include <ISO_Fortran_binding.h>

static void report(const char *what, int rc, const void *dv, const void *saved,
                   size_t size) {
  printf("%s: rc=%d detected=%d unmodified=%d\n", what, rc, rc != CFI_SUCCESS,
         memcmp(dv, saved, size) == 0);
  fflush(stdout);
}

static char text[4];

void c_errors(void) {
  CFI_CDESC_T(0) d0, saved0;
  CFI_CDESC_T(CFI_MAX_RANK + 1) dr, savedr;
  CFI_cdesc_t *dv0 = (CFI_cdesc_t *)&d0;
  CFI_cdesc_t *dvr = (CFI_cdesc_t *)&dr;
  int rc;

  memset(&d0, 0x5a, sizeof d0);
  memcpy(&saved0, &d0, sizeof d0);
  rc = CFI_establish(dv0, text, CFI_attribute_other, CFI_type_char, 0, 0, NULL);
  report("CFI_establish character elem_len=0", rc, &d0, &saved0, sizeof d0);

  memset(&dr, 0x5a, sizeof dr);
  memcpy(&savedr, &dr, sizeof dr);
  rc = CFI_establish(dvr, NULL, CFI_attribute_allocatable, CFI_type_int,
                     sizeof(int), CFI_MAX_RANK + 1, NULL);
  report("CFI_establish rank CFI_MAX_RANK+1", rc, &dr, &savedr, sizeof dr);
}
