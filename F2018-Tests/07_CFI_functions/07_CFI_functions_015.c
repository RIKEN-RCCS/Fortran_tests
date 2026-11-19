#include <stdio.h>
#include <ISO_Fortran_binding.h>

void c_error_codes(void) {
  const int codes[] = {
      CFI_SUCCESS,           CFI_ERROR_BASE_ADDR_NULL, CFI_ERROR_BASE_ADDR_NOT_NULL,
      CFI_INVALID_ELEM_LEN,  CFI_INVALID_RANK,         CFI_INVALID_TYPE,
      CFI_INVALID_ATTRIBUTE, CFI_INVALID_EXTENT,       CFI_INVALID_DESCRIPTOR,
      CFI_ERROR_MEM_ALLOCATION, CFI_ERROR_OUT_OF_BOUNDS};
  const int n = (int)(sizeof(codes) / sizeof(codes[0]));
  int nonzero = 1, distinct = 1;
  for (int i = 1; i < n; i++)
    if (codes[i] == 0) nonzero = 0;
  for (int i = 0; i < n; i++)
    for (int j = i + 1; j < n; j++)
      if (codes[i] == codes[j]) distinct = 0;
  printf("CFI_SUCCESS=%d\n", CFI_SUCCESS);
  printf("others nonzero=%d\n", nonzero);
  printf("pairwise distinct=%d\n", distinct);
  fflush(stdout);
}
