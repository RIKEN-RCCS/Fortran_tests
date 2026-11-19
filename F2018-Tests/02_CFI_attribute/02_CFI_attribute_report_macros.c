/* Companion for No.2 004 (F2018 18.5 / N2161 2.2, the CFI_attribute_* macros).
 *
 * ISO_Fortran_binding.h defines three integer constant macros:
 *   CFI_attribute_pointer, CFI_attribute_allocatable, CFI_attribute_other
 * Their values are nonnegative and distinct. */

#include <stdio.h>
#include <ISO_Fortran_binding.h>

void report_macros(void) {
#ifdef CFI_attribute_pointer
    printf("pointer_defined: yes\n");
#else
    printf("pointer_defined: no\n");
#endif
#ifdef CFI_attribute_allocatable
    printf("allocatable_defined: yes\n");
#else
    printf("allocatable_defined: no\n");
#endif
#ifdef CFI_attribute_other
    printf("other_defined: yes\n");
#else
    printf("other_defined: no\n");
#endif
#if defined(CFI_attribute_pointer) && defined(CFI_attribute_allocatable) && defined(CFI_attribute_other)
    int p = CFI_attribute_pointer;
    int a = CFI_attribute_allocatable;
    int o = CFI_attribute_other;
    printf("nonnegative: %s\n", (p >= 0 && a >= 0 && o >= 0) ? "yes" : "no");
    printf("distinct: %s\n", (p != a && a != o && p != o) ? "yes" : "no");
#else
    printf("nonnegative: no\n");
    printf("distinct: no\n");
#endif
}
