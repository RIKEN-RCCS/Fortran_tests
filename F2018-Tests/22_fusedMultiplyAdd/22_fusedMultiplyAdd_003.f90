! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.5 [S2]


program fusedMultiplyAdd_003
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved_round
  real :: a, b, c
  real, volatile :: product

  a = 4097.0 + command_argument_count()
  b = 4097.0 + command_argument_count()
  c = -16785408.0 - command_argument_count()
  write(*,'(A,L1)') 'nearest_supported=', ieee_support_rounding(ieee_nearest, a)

  call ieee_get_rounding_mode(saved_round)
  call ieee_set_rounding_mode(ieee_nearest)
  product = a * b

  write(*,'(A,L1)') 'fma_eq_1=', ieee_fma(a, b, c) == 1.0
  write(*,'(A,L1)') 'rounded_product_plus_c_eq_0=', (product + c) == 0.0
  call ieee_set_rounding_mode(saved_round)
end program fusedMultiplyAdd_003
! CHECK: nearest_supported=T
! CHECK-NEXT: fma_eq_1=T
! CHECK-NEXT: rounded_product_plus_c_eq_0=T
