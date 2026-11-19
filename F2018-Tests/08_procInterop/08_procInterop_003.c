#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_show(CFI_cdesc_t *p, int id) {
  static const char *const names[] = {"pointer_disassociated",
                                      "pointer_associated"};
  printf("%s attribute_ok=%d rank=%d base_addr_null=%d", names[id],
         p->attribute == CFI_attribute_pointer, (int)p->rank,
         p->base_addr == NULL);
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
