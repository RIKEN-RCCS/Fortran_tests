/* Companion for No.2 001-003, 006-008 (F2018 18.5 / N2161 2.2, the CFI_attribute_* macros).
 *
 * check_attr() reports whether the "attribute" member of a descriptor a
 * BIND(C) procedure received equals the macro the Fortran side expects
 * (expect: 0 = other, 1 = allocatable, 2 = pointer). */

#include <stdio.h>
#include <ISO_Fortran_binding.h>

static const char *name_of(CFI_attribute_t v) {
    if (v == CFI_attribute_pointer) return "pointer";
    else if (v == CFI_attribute_allocatable) return "allocatable";
    else if (v == CFI_attribute_other) return "other";
    else return "unknown";
}

void check_attr(CFI_cdesc_t *d, int *expect) {
    CFI_attribute_t want = (*expect == 2) ? CFI_attribute_pointer
                         : (*expect == 1) ? CFI_attribute_allocatable
                         : CFI_attribute_other;
    printf("attribute: %s\n", name_of(d->attribute));
    printf("matches_expected: %s\n", d->attribute == want ? "yes" : "no");
}
