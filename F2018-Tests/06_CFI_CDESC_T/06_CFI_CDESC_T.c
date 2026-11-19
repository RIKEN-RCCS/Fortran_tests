#include <stdio.h>
#include <stddef.h>
#include <ISO_Fortran_binding.h>

void macro_defined(void) {
#ifdef CFI_CDESC_T
    printf("CFI_CDESC_T defined=1\n");
#else
    printf("CFI_CDESC_T defined=0\n");
#endif
}

#ifdef CFI_CDESC_T

typedef CFI_CDESC_T(0) cdesc0_t;
typedef CFI_CDESC_T(1) cdesc1_t;
typedef CFI_CDESC_T(2) cdesc2_t;
typedef CFI_CDESC_T(7) cdesc7_t;
typedef CFI_CDESC_T(15) cdesc15_t;

static void storage(int rank, size_t size, size_t align) {
    size_t need = offsetof(CFI_cdesc_t, dim) + (size_t) rank * sizeof(CFI_dim_t);
    printf("CFI_CDESC_T(%d) size>=need=%d\n", rank, size >= need);
    printf("CFI_CDESC_T(%d) align>=CFI_cdesc_t=%d\n", rank,
           align >= _Alignof(CFI_cdesc_t));
}

static void establish(CFI_cdesc_t *d, double *base, int rank,
                      const CFI_index_t extents[]) {
    int r = CFI_establish(d, base, CFI_attribute_other, CFI_type_double,
                          sizeof(double), (CFI_rank_t) rank, extents);
    printf("rank%d establish==CFI_SUCCESS=%d", rank, r == CFI_SUCCESS);
    if (r == CFI_SUCCESS) {
        printf(" rank=%d", (int) d->rank);
        if (rank > 0)
            printf(" dim%d.extent=%d", rank - 1, (int) d->dim[rank - 1].extent);
    }
    printf("\n");
}

void ranks_0_1_7(void) {
    double backing[6] = {0};
    CFI_index_t ext1[1] = {5};
    CFI_index_t ext7[7] = {2, 1, 1, 1, 1, 1, 3};
    cdesc0_t b0;
    cdesc1_t b1;
    cdesc7_t b7;

    storage(0, sizeof(cdesc0_t), _Alignof(cdesc0_t));
    storage(1, sizeof(cdesc1_t), _Alignof(cdesc1_t));
    storage(7, sizeof(cdesc7_t), _Alignof(cdesc7_t));
    establish((CFI_cdesc_t *) &b0, backing, 0, NULL);
    establish((CFI_cdesc_t *) &b1, backing, 1, ext1);
    establish((CFI_cdesc_t *) &b7, backing, 7, ext7);
}

void rank_15(void) {
    double backing[6] = {0};
    CFI_index_t ext15[15] = {2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3};
    cdesc15_t b15;

    storage(15, sizeof(cdesc15_t), _Alignof(cdesc15_t));
    establish((CFI_cdesc_t *) &b15, backing, 15, ext15);
}

void roundtrip(void) {
    double backing[6] = {0};
    CFI_index_t ext[2] = {2, 3};
    cdesc2_t b;
    CFI_cdesc_t *d = (CFI_cdesc_t *) &b;

    CFI_establish(d, backing, CFI_attribute_other, CFI_type_double,
                  sizeof(double), 2, ext);
    d->dim[1].extent = 99;
    printf("dim1.extent=%d\n", (int) d->dim[1].extent);
    printf("dim0.extent=%d\n", (int) d->dim[0].extent);
}

#endif
