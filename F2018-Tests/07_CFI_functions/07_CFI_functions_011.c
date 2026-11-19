#include <stdio.h>
#include <ISO_Fortran_binding.h>

static char words[2][5] = {{'a', 'b', 'c', 'd', 'e'}, {'f', 'g', 'h', 'i', 'j'}};

void c_select_substring(void) {
  CFI_CDESC_T(1) ds, dr;
  CFI_cdesc_t *s = (CFI_cdesc_t *)&ds;
  CFI_cdesc_t *r = (CFI_cdesc_t *)&dr;
  CFI_index_t extents[1] = {2};
  int rc;
  CFI_establish(s, words, CFI_attribute_other, CFI_type_char, 5, 1, extents);
  CFI_establish(r, NULL, CFI_attribute_other, CFI_type_char, 1, 1, NULL);
  rc = CFI_select_part(r, s, 1, 3);
  printf("substring: rc=%d elem_len=%ld values", rc, (long)r->elem_len);
  if (rc == CFI_SUCCESS)
    for (CFI_index_t i = 0; i < r->dim[0].extent; i++) {
      CFI_index_t sub[1] = {r->dim[0].lower_bound + i};
      printf(" %.3s", (char *)CFI_address(r, sub));
    }
  printf("\n");
  fflush(stdout);
}
