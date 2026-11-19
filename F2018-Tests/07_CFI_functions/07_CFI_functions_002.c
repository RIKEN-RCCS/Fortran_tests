#include <stdio.h>
#include <ISO_Fortran_binding.h>

void f_alloc(CFI_cdesc_t *a);
void f_ptr(CFI_cdesc_t *p);

void c_establish_null(void) {
  CFI_CDESC_T(1) da, dp;
  CFI_cdesc_t *a = (CFI_cdesc_t *)&da;
  CFI_cdesc_t *p = (CFI_cdesc_t *)&dp;
  int rc;

  rc = CFI_establish(a, NULL, CFI_attribute_allocatable, CFI_type_int,
                     sizeof(int), 1, NULL);
  printf("allocatable rc=%d base_addr_null=%d attribute_ok=%d\n", rc,
         a->base_addr == NULL, a->attribute == CFI_attribute_allocatable);
  fflush(stdout);
  f_alloc(a);

  rc = CFI_establish(p, NULL, CFI_attribute_pointer, CFI_type_int,
                     sizeof(int), 1, NULL);
  printf("pointer rc=%d base_addr_null=%d attribute_ok=%d\n", rc,
         p->base_addr == NULL, p->attribute == CFI_attribute_pointer);
  fflush(stdout);
  f_ptr(p);
}
