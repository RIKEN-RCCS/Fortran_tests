#include <stdio.h>
#include <ISO_Fortran_binding.h>

typedef struct { int i; double d; } pt;

void f_char(CFI_cdesc_t *s);
void f_struct(CFI_cdesc_t *a);

static char text[5] = {'h', 'e', 'l', 'l', 'o'};
static pt pts[2] = {{1, 0.5}, {2, 1.5}};
static int ints[1] = {7};

void c_establish_elem_len(void) {
  CFI_CDESC_T(0) dc;
  CFI_CDESC_T(1) ds, di;
  CFI_cdesc_t *c = (CFI_cdesc_t *)&dc;
  CFI_cdesc_t *s = (CFI_cdesc_t *)&ds;
  CFI_cdesc_t *i = (CFI_cdesc_t *)&di;
  CFI_index_t e2[1] = {2}, e1[1] = {1};
  int rc;

  rc = CFI_establish(c, text, CFI_attribute_other, CFI_type_char, 5, 0, NULL);
  printf("char rc=%d elem_len=%ld type_ok=%d\n", rc, (long)c->elem_len,
         c->type == CFI_type_char);
  fflush(stdout);
  f_char(c);

  rc = CFI_establish(s, pts, CFI_attribute_other, CFI_type_struct,
                     sizeof(pt), 1, e2);
  printf("struct rc=%d elem_len_ok=%d type_ok=%d\n", rc,
         s->elem_len == sizeof(pt), s->type == CFI_type_struct);
  fflush(stdout);
  f_struct(s);

  /* elem_len is not equal to the real element size on purpose: it must be
     ignored (and CFI_establish must still succeed) for a non-character,
     non-struct, non-other intrinsic type. */
  rc = CFI_establish(i, ints, CFI_attribute_other, CFI_type_int, 0, 1, e1);
  printf("int elem_len=0 rc=%d elem_len_ok=%d\n", rc,
         rc == CFI_SUCCESS && i->elem_len == sizeof(int));
  fflush(stdout);
}
