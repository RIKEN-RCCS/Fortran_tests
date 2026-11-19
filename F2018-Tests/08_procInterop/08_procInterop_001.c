#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_show(CFI_cdesc_t *s, int id) {
  static const char *const names[] = {"whole", "substring"};
  printf("%s elem_len=%ld rank=%d type_ok=%d text=%.*s\n", names[id],
         (long)s->elem_len, (int)s->rank, s->type == CFI_type_char,
         (int)s->elem_len, (char *)s->base_addr);
  fflush(stdout);
}
