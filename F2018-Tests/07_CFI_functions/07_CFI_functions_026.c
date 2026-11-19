#include <stdio.h>
#include <ISO_Fortran_binding.h>

static int storage[6];

void c_establish_max_rank(void) {
  CFI_CDESC_T(CFI_MAX_RANK) d;
  CFI_cdesc_t *dv = (CFI_cdesc_t *)&d;
  CFI_index_t extents[CFI_MAX_RANK];
  int extents_ok = 1;
  for (int i = 0; i < CFI_MAX_RANK; i++) extents[i] = 1;
  extents[0] = 2;
  extents[CFI_MAX_RANK - 1] = 3;
  int rc = CFI_establish(dv, storage, CFI_attribute_other, CFI_type_int,
                         sizeof(int), CFI_MAX_RANK, extents);
  printf("rank CFI_MAX_RANK: rc=%d", rc);
  if (rc == CFI_SUCCESS)
    for (int i = 0; i < CFI_MAX_RANK; i++)
      if (dv->dim[i].extent != extents[i]) extents_ok = 0;
  printf(" rank_ok=%d extents_ok=%d dim0.extent=%ld dimlast.extent=%ld\n",
         dv->rank == CFI_MAX_RANK, extents_ok, (long)dv->dim[0].extent,
         (long)dv->dim[CFI_MAX_RANK - 1].extent);
  fflush(stdout);
}
