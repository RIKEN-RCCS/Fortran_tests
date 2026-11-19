/* Companion for No.4 (F2018 18.5.4 / N2161 2.4, the CFI_type_* macros).
 *
 * The raw integer value of a type code is processor dependent, and the
 * standard explicitly permits the type codes of different C types that
 * have the same representation to share a value (18.5.4). gfortran, for
 * instance, gives CFI_type_long and CFI_type_size_t the same value on
 * LP64. Only CFI_type_other (negative) and CFI_type_struct (positive)
 * must be distinct from every other type code. These tests therefore
 * check portable properties only, over the whole of N2161 Table 2:
 * presence of the macros, the sign rules, the two required-distinct
 * codes, per-type consistency of the descriptor type member, and the
 * exact code for the types that Table 2 maps to a single macro
 * (CFI_type_cptr is split into 004, which flang/nvfortran currently
 * fail). */

#include <stdio.h>
#include <ISO_Fortran_binding.h>

#if !defined(CFI_type_signed_char) || !defined(CFI_type_short) \
 || !defined(CFI_type_int) || !defined(CFI_type_long) \
 || !defined(CFI_type_long_long) || !defined(CFI_type_size_t) \
 || !defined(CFI_type_int8_t) || !defined(CFI_type_int16_t) \
 || !defined(CFI_type_int32_t) || !defined(CFI_type_int64_t) \
 || !defined(CFI_type_int_least8_t) || !defined(CFI_type_int_least16_t) \
 || !defined(CFI_type_int_least32_t) || !defined(CFI_type_int_least64_t) \
 || !defined(CFI_type_int_fast8_t) || !defined(CFI_type_int_fast16_t) \
 || !defined(CFI_type_int_fast32_t) || !defined(CFI_type_int_fast64_t) \
 || !defined(CFI_type_intmax_t) || !defined(CFI_type_intptr_t) \
 || !defined(CFI_type_ptrdiff_t) \
 || !defined(CFI_type_float) || !defined(CFI_type_double) \
 || !defined(CFI_type_long_double) \
 || !defined(CFI_type_float_Complex) || !defined(CFI_type_double_Complex) \
 || !defined(CFI_type_long_double_Complex) \
 || !defined(CFI_type_Bool) || !defined(CFI_type_char) \
 || !defined(CFI_type_cptr) || !defined(CFI_type_struct) \
 || !defined(CFI_type_other)
#error "expected CFI_type_* macros missing from ISO_Fortran_binding.h"
#endif

/* Slots, in N2161 Table 2 order (CFI_type_other excluded). */
enum {
    S_schar, S_short, S_int, S_long, S_llong, S_size,
    S_i8, S_i16, S_i32, S_i64,
    S_l8, S_l16, S_l32, S_l64, S_f8, S_f16, S_f32, S_f64,
    S_imax, S_iptr, S_pdiff,
    S_float, S_double, S_ldbl,
    S_fcx, S_dcx, S_ldcx,
    S_bool, S_char, S_cptr, S_struct,
    NT
};

/* The 31 interoperable type codes of N2161 Table 2, same order as S_*. */
static const CFI_type_t table2[NT] = {
    CFI_type_signed_char, CFI_type_short, CFI_type_int, CFI_type_long,
    CFI_type_long_long, CFI_type_size_t,
    CFI_type_int8_t, CFI_type_int16_t, CFI_type_int32_t, CFI_type_int64_t,
    CFI_type_int_least8_t, CFI_type_int_least16_t, CFI_type_int_least32_t,
    CFI_type_int_least64_t,
    CFI_type_int_fast8_t, CFI_type_int_fast16_t, CFI_type_int_fast32_t,
    CFI_type_int_fast64_t,
    CFI_type_intmax_t, CFI_type_intptr_t, CFI_type_ptrdiff_t,
    CFI_type_float, CFI_type_double, CFI_type_long_double,
    CFI_type_float_Complex, CFI_type_double_Complex, CFI_type_long_double_Complex,
    CFI_type_Bool, CFI_type_char, CFI_type_cptr, CFI_type_struct
};

void macros_present(void) {
    printf("table2_type_code_macros_present: yes\n");
}

/* ---- 001: sign rules, required-distinct codes, per-type checks ---- */

void macro_rules(void) {
    int i, signs_ok = 1, other_ok = 1, struct_ok = 1;

    for (i = 0; i < NT; i++) {
        if (table2[i] <= 0) signs_ok = 0;
        if (CFI_type_other == table2[i]) other_ok = 0;
        if (i != S_struct && CFI_type_struct == table2[i]) struct_ok = 0;
    }
    printf("table2_codes_positive: %s\n", signs_ok ? "yes" : "no");
    printf("other_is_negative: %s\n", CFI_type_other < 0 ? "yes" : "no");
    printf("other_distinct_from_all: %s\n", other_ok ? "yes" : "no");
    printf("struct_distinct_from_all: %s\n", struct_ok ? "yes" : "no");
}

static CFI_type_t code[NT];
static int seen[NT];

void note(int slot, CFI_cdesc_t *d) {
    if (slot < 0 || slot >= NT) return;
    code[slot] = d->type;
    seen[slot] = 1;
}

void report(void) {
    int i, all_seen = 1, positive = 1, exact_ok;

    for (i = 0; i < NT; i++) if (!seen[i]) all_seen = 0;
    printf("all_slots_seen: %s\n", all_seen ? "yes" : "no");

    for (i = 0; i < NT; i++) if (seen[i] && code[i] <= 0) positive = 0;
    printf("descriptor_codes_positive: %s\n", positive ? "yes" : "no");

    printf("double_is_CFI_type_double: %s\n",
           code[S_double] == CFI_type_double ? "yes" : "no");

    /* Table 2 types with exactly one macro each (CFI_type_cptr is
       checked in 004: flang/nvfortran do not report it here) */
    exact_ok =
        code[S_float]  == CFI_type_float          &&
        code[S_double] == CFI_type_double         &&
        code[S_fcx]    == CFI_type_float_Complex  &&
        code[S_dcx]    == CFI_type_double_Complex &&
        code[S_bool]   == CFI_type_Bool           &&
        code[S_char]   == CFI_type_char           &&
        code[S_struct] == CFI_type_struct;
    printf("unique_macro_types_match: %s\n", exact_ok ? "yes" : "no");
}

/* another real(c_double) entity, passed to a different C function than
   note, must get the same code that note recorded for S_double */
void same_code(CFI_cdesc_t *b) {
    printf("same_type_same_code: %s\n",
           seen[S_double] && b->type == code[S_double] ? "yes" : "no");
}

/* 004: descriptor type of a type(c_ptr) dummy is CFI_type_cptr */
void cptr_check(CFI_cdesc_t *d) {
    printf("cptr_type_is_CFI_type_cptr: %s\n",
           d->type == CFI_type_cptr ? "yes" : "no");
}

/* ---- 003: sized integers, elem_len and non-other ---- */

void dump2(CFI_cdesc_t *a, CFI_cdesc_t *b) {
    printf("a_elem_len: %d\n", (int) a->elem_len);
    printf("b_elem_len: %d\n", (int) b->elem_len);
    printf("a_is_other: %s\n", a->type == CFI_type_other ? "yes" : "no");
    printf("b_is_other: %s\n", b->type == CFI_type_other ? "yes" : "no");
    printf("codes_differ: %s\n", a->type != b->type ? "yes" : "no");
}
