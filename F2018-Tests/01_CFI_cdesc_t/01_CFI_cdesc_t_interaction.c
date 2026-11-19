#include <stdio.h>
#include <ISO_Fortran_binding.h>

static const char *attr_name(CFI_attribute_t a) {
    switch (a) {
    case CFI_attribute_pointer:     return "pointer";
    case CFI_attribute_allocatable: return "allocatable";
    case CFI_attribute_other:       return "other";
    default:                        return "unknown";
    }
}

static const char *yes_no(int b) { return b ? "yes" : "no"; }

void attr_type(CFI_cdesc_t *d) {
    printf("base_addr: %s\n", d->base_addr ? "nonnull" : "null");
    printf("attribute: %s\n", attr_name(d->attribute));
    printf("elem_len: %d\n", (int) d->elem_len);
    printf("type==CFI_type_double: %s\n", yes_no(d->type == CFI_type_double));
    printf("type!=CFI_type_other: %s\n", yes_no(d->type != CFI_type_other));
}

void rank15(CFI_cdesc_t *d) {
    int i, ones = 1;
    printf("rank: %d\n", (int) d->rank);
    printf("rank<=CFI_MAX_RANK: %s\n", yes_no(d->rank <= CFI_MAX_RANK));
    if (d->rank != 15)
        return;
    for (i = 1; i < 14; i++)
        if (d->dim[i].extent != 1) ones = 0;
    printf("dim[0].extent: %d\n", (int) d->dim[0].extent);
    printf("dim[1:13].extent==1: %s\n", yes_no(ones));
    printf("dim[14].extent: %d\n", (int) d->dim[14].extent);
}

void stride3(CFI_cdesc_t *d) {
    int i;
    printf("type==CFI_type_double: %s\n", yes_no(d->type == CFI_type_double));
    printf("elem_len: %d\n", (int) d->elem_len);
    for (i = 0; i < d->rank; i++) {
        printf("dim[%d].extent: %d\n", i, (int) d->dim[i].extent);
        printf("dim[%d].sm: %d\n",     i, (int) d->dim[i].sm);
    }
}

#ifdef CFI_CDESC_T

static void establish_with(const char *label, CFI_attribute_t attr) {
    double backing[1] = {0};
    CFI_index_t ext[1] = {1};
    CFI_CDESC_T(1) storage;
    CFI_cdesc_t *d = (CFI_cdesc_t *) &storage;
    void *base = (attr == CFI_attribute_other) ? (void *) backing : NULL;
    int r = CFI_establish(d, base, attr, CFI_type_double, sizeof(double), 1, ext);
    printf("establish %s: success=%s", label, yes_no(r == CFI_SUCCESS));
    if (r == CFI_SUCCESS)
        printf(" attribute=%s", attr_name(d->attribute));
    printf("\n");
}

void establish_attr(void) {
    establish_with("CFI_attribute_other", CFI_attribute_other);
    establish_with("CFI_attribute_pointer", CFI_attribute_pointer);
    establish_with("CFI_attribute_allocatable", CFI_attribute_allocatable);
}

static void establish_rank(CFI_cdesc_t *d, int rank) {
    double backing[2] = {0};
    CFI_index_t ext[7] = {2, 1, 1, 1, 1, 1, 1};
    int r = CFI_establish(d, backing, CFI_attribute_other, CFI_type_double,
                          sizeof(double), (CFI_rank_t) rank, ext);
    printf("establish rank %d: success=%s", rank, yes_no(r == CFI_SUCCESS));
    if (r == CFI_SUCCESS)
        printf(" rank=%d version==CFI_VERSION=%s", (int) d->rank,
               yes_no(d->version == CFI_VERSION));
    printf("\n");
}

void establish_version_rank(void) {
    CFI_CDESC_T(0) s0;
    CFI_CDESC_T(1) s1;
    CFI_CDESC_T(7) s7;
    establish_rank((CFI_cdesc_t *) &s0, 0);
    establish_rank((CFI_cdesc_t *) &s1, 1);
    establish_rank((CFI_cdesc_t *) &s7, 7);
}

#endif
