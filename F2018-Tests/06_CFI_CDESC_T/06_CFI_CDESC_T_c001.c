#include <ISO_Fortran_binding.h>

static void use_it(CFI_cdesc_t *d) { (void) d; }

void bad_cast(void) {
    CFI_CDESC_T(2) ok;
    CFI_CDESC_T(2) b;
    use_it((CFI_cdesc_t *) &ok);
    use_it(&b);
}
