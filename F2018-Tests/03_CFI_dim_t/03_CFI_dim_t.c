/* Companion for No.3 (N2161 2.3, the type CFI_dim_t).
 *
 * CFI_dim_t is a C struct required to include at least three CFI_index_t
 * members: lower_bound, extent, sm (stride in memory, in bytes).
 * CFI_index_t is a standard signed integer type capable of representing
 * a memory address difference in bytes.  This companion reports those
 * members for the dimensions of a descriptor a BIND(C) procedure
 * received, plus a few type-level facts. */

#include <stdio.h>
#include <ISO_Fortran_binding.h>

#define IS_STANDARD_SIGNED_INTEGER(x) _Generic((x), \
    signed char: 1, short: 1, int: 1, long: 1, long long: 1, default: 0)

void dims(CFI_cdesc_t *d) {
    int i;
    printf("rank: %d\n", (int) d->rank);
    printf("elem_len: %d\n", (int) d->elem_len);
    for (i = 0; i < d->rank; i++) {
        CFI_dim_t dim = d->dim[i];        /* copy by value: struct assignment works */
        printf("dim[%d]: lower_bound=%ld extent=%ld sm=%ld\n",
               i, (long) dim.lower_bound, (long) dim.extent, (long) dim.sm);
    }
}

void type_facts(void) {
    static char buf[100000];
    char *first = &buf[0];
    char *last = &buf[99999];
    CFI_index_t forward = last - first;
    CFI_index_t backward = first - last;
    printf("CFI_index_t_standard_signed_integer_type: %s\n",
           IS_STANDARD_SIGNED_INTEGER((CFI_index_t) 0) ? "yes" : "no");
    printf("pointer_difference_forward: %ld\n", (long) forward);
    printf("pointer_difference_backward: %ld\n", (long) backward);
    printf("dim_members_are_CFI_index_t: %s\n",
           (_Generic(((CFI_dim_t *) 0)->lower_bound, CFI_index_t: 1, default: 0) &&
            _Generic(((CFI_dim_t *) 0)->extent,      CFI_index_t: 1, default: 0) &&
            _Generic(((CFI_dim_t *) 0)->sm,          CFI_index_t: 1, default: 0))
           ? "yes" : "no");
}
