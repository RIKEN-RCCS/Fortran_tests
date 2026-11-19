#include <stdio.h>
#include <ISO_Fortran_binding.h>

typedef struct { int i; double d; } pt;

void f_double(CFI_cdesc_t *a);
void f_struct(CFI_cdesc_t *a);

static double da[3] = {1.0, 2.0, 3.0};
static pt pts[2] = {{1, 0.5}, {2, 1.5}};

void c_call(void) {
  CFI_CDESC_T(1) d;
  CFI_cdesc_t *a = (CFI_cdesc_t *)&d;
  CFI_index_t e3[1] = {3}, e2[1] = {2};

  CFI_establish(a, da, CFI_attribute_other, CFI_type_double, sizeof(double), 1, e3);
  f_double(a);
  CFI_establish(a, pts, CFI_attribute_other, CFI_type_struct, sizeof(pt), 1, e2);
  f_struct(a);
}
