/* Companion for No.2 005 (F2018 18.5, the CFI_attribute_* macros).
 *
 * CFI_attribute_t is a typedef name for a standard integer type
 * capable of representing the values for the supported attribute codes. */

#include <stdio.h>
#include <ISO_Fortran_binding.h>

void report_type(void) {
    int is_standard_integer = _Generic((CFI_attribute_t)0,
        signed char: 1, unsigned char: 1,
        short: 1, unsigned short: 1,
        int: 1, unsigned int: 1,
        long: 1, unsigned long: 1,
        long long: 1, unsigned long long: 1,
        default: 0);
    printf("attribute_t_standard_integer: %s\n", is_standard_integer ? "yes" : "no");
#ifdef CFI_attribute_pointer
    printf("pointer_representable: %s\n",
           (CFI_attribute_t)CFI_attribute_pointer == CFI_attribute_pointer ? "yes" : "no");
#else
    printf("pointer_representable: no\n");
#endif
#ifdef CFI_attribute_allocatable
    printf("allocatable_representable: %s\n",
           (CFI_attribute_t)CFI_attribute_allocatable == CFI_attribute_allocatable ? "yes" : "no");
#else
    printf("allocatable_representable: no\n");
#endif
#ifdef CFI_attribute_other
    printf("other_representable: %s\n",
           (CFI_attribute_t)CFI_attribute_other == CFI_attribute_other ? "yes" : "no");
#else
    printf("other_representable: no\n");
#endif
}
