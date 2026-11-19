#include <stdio.h>
#include <ISO_Fortran_binding.h>

void constants(void) {
#ifdef CFI_VERSION
    printf("CFI_VERSION defined=1\n");
#else
    printf("CFI_VERSION defined=0\n");
#endif
#ifdef CFI_MAX_RANK
    printf("CFI_MAX_RANK defined=1\n");
    printf("CFI_MAX_RANK>=15=%d\n", CFI_MAX_RANK >= 15);
#else
    printf("CFI_MAX_RANK defined=0\n");
#endif
}

void version_member(CFI_cdesc_t *d) {
    printf("version==CFI_VERSION=%d\n", d->version == CFI_VERSION);
}

void rank_member(CFI_cdesc_t *d) {
    printf("rank=%d\n", (int) d->rank);
    printf("rank<=CFI_MAX_RANK=%d\n", d->rank <= CFI_MAX_RANK);
}
