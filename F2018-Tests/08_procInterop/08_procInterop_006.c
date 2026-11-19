#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_alloc_char(CFI_cdesc_t *s);
void f_point(CFI_cdesc_t *p);

void c_call(void) {
  CFI_CDESC_T(0) ds;
  CFI_CDESC_T(1) dp;
  CFI_cdesc_t *s = (CFI_cdesc_t *)&ds;
  CFI_cdesc_t *p = (CFI_cdesc_t *)&dp;

  CFI_establish(s, NULL, CFI_attribute_allocatable, CFI_type_char, 1, 0, NULL);
  f_alloc_char(s);
  printf("allocatable_char base_addr_null=%d", s->base_addr == NULL);
  if (s->base_addr != NULL)
    printf(" elem_len=%ld text=%.*s", (long)s->elem_len, (int)s->elem_len,
           (char *)s->base_addr);
  printf("\n");

  CFI_establish(p, NULL, CFI_attribute_pointer, CFI_type_int, sizeof(int), 1, NULL);
  f_point(p);
  printf("pointer_int base_addr_null=%d", p->base_addr == NULL);
  if (p->base_addr != NULL) {
    printf(" lower_bound=%ld extent=%ld values", (long)p->dim[0].lower_bound,
           (long)p->dim[0].extent);
    for (CFI_index_t i = 0; i < p->dim[0].extent; i++) {
      CFI_index_t sub[1] = {p->dim[0].lower_bound + i};
      printf(" %d", *(int *)CFI_address(p, sub));
    }
  }
  printf("\n");
  fflush(stdout);
}
