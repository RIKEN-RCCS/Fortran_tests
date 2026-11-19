#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_show_shape(CFI_cdesc_t *a) {
  printf("assumed_shape attribute_ok=%d type_ok=%d rank=%d\n",
         a->attribute == CFI_attribute_other, a->type == CFI_type_double,
         (int)a->rank);
  printf("assumed_shape lower_bounds=%ld %ld extents=%ld %ld values",
         (long)a->dim[0].lower_bound, (long)a->dim[1].lower_bound,
         (long)a->dim[0].extent, (long)a->dim[1].extent);
  for (CFI_index_t j = 0; j < a->dim[1].extent; j++)
    for (CFI_index_t i = 0; i < a->dim[0].extent; i++) {
      CFI_index_t sub[2] = {a->dim[0].lower_bound + i, a->dim[1].lower_bound + j};
      printf(" %.0f", *(double *)CFI_address(a, sub));
    }
  printf("\n");
  fflush(stdout);
}

void c_show_rank(CFI_cdesc_t *a) {
  printf("assumed_rank attribute_ok=%d type_ok=%d rank=%d\n",
         a->attribute == CFI_attribute_other, a->type == CFI_type_double,
         (int)a->rank);
  printf("assumed_rank lower_bounds=%ld %ld extents=%ld %ld\n",
         (long)a->dim[0].lower_bound, (long)a->dim[1].lower_bound,
         (long)a->dim[0].extent, (long)a->dim[1].extent);
  fflush(stdout);
}

void c_show_alloc(CFI_cdesc_t *a, int id) {
  static const char *const names[] = {"allocatable_unallocated",
                                      "allocatable_allocated"};
  printf("%s attribute_ok=%d base_addr_null=%d", names[id],
         a->attribute == CFI_attribute_allocatable, a->base_addr == NULL);
  if (a->base_addr != NULL) {
    printf(" lower_bound=%ld extent=%ld values", (long)a->dim[0].lower_bound,
           (long)a->dim[0].extent);
    for (CFI_index_t i = 0; i < a->dim[0].extent; i++) {
      CFI_index_t sub[1] = {a->dim[0].lower_bound + i};
      printf(" %d", *(int *)CFI_address(a, sub));
    }
  }
  printf("\n");
  fflush(stdout);
}
