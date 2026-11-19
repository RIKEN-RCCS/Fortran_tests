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

static void dump(const char *tag, CFI_cdesc_t *d) {
    int i;
    printf("[%s]\n", tag);
    printf("base_addr: %s\n", d->base_addr ? "nonnull" : "null");
    printf("elem_len: %d\n", (int) d->elem_len);
    printf("version_is_CFI_VERSION: %s\n",
           d->version == CFI_VERSION ? "yes" : "no");
    printf("rank: %d\n", (int) d->rank);
    printf("type_is_CFI_type_t: %s\n",
           _Generic(d->type, CFI_type_t: "yes", default: "no"));
    printf("attribute: %s\n", attr_name(d->attribute));
    for (i = 0; i < d->rank; i++) {
        printf("dim[%d].lower_bound: %d\n", i, (int) d->dim[i].lower_bound);
        printf("dim[%d].extent: %d\n",      i, (int) d->dim[i].extent);
        printf("dim[%d].sm: %d\n",          i, (int) d->dim[i].sm);
    }
}

void inspect_i0(CFI_cdesc_t *d) { dump("i0", d); }
void inspect_d1(CFI_cdesc_t *d) { dump("d1", d); }
void inspect_d2(CFI_cdesc_t *d) { dump("d2", d); }
void inspect_z1(CFI_cdesc_t *d) { dump("z1", d); }
void inspect_i2(CFI_cdesc_t *d) { dump("i2", d); }
void inspect_c0(CFI_cdesc_t *d) {
    int is_char = d->type == CFI_type_char;
    dump("c0", d);
    printf("type_is_CFI_type_char: %s\n", is_char ? "yes" : "no");
    if (is_char && d->elem_len == 5 && d->base_addr)
        printf("value: %.5s\n", (const char *) d->base_addr);
    else
        printf("value: (not read)\n");
}
