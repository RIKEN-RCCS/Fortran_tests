#include <stdio.h>
#include <ISO_Fortran_binding.h>

static char buf[12];

void c_establish_more(void) {
  CFI_CDESC_T(1) d1;
  CFI_CDESC_T(0) d0;
  CFI_cdesc_t *a = (CFI_cdesc_t *)&d1;
  CFI_cdesc_t *s = (CFI_cdesc_t *)&d0;
  CFI_index_t invalid_extents[1] = {-5};
  int rc;

  rc = CFI_establish(a, NULL, CFI_attribute_other, CFI_type_int, sizeof(int), 1, NULL);
  printf("other null base_addr: rc=%d base_addr_null=%d attribute_ok=%d rank=%d\n",
         rc, a->base_addr == NULL, a->attribute == CFI_attribute_other, (int)a->rank);
  fflush(stdout);

  rc = CFI_establish(a, NULL, CFI_attribute_pointer, CFI_type_int, sizeof(int), 1,
                     invalid_extents);
  printf("null base_addr with extents: rc=%d base_addr_null=%d\n", rc,
         a->base_addr == NULL);
  fflush(stdout);

  rc = CFI_establish(s, buf, CFI_attribute_other, CFI_type_int, sizeof(int), 0,
                     invalid_extents);
  printf("rank 0 with extents: rc=%d rank=%d\n", rc, (int)s->rank);
  fflush(stdout);
}
