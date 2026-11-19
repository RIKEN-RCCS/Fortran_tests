! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.3 [S2, S3]


program roundingModes_003
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved, decimal_before, decimal_after
  integer :: radix

  radix = 10 + command_argument_count()

  call ieee_get_rounding_mode(saved)
  call ieee_get_rounding_mode(decimal_before, radix)

  call ieee_set_rounding_mode(ieee_to_zero)
  call ieee_get_rounding_mode(decimal_after, radix)
  write(*,'(A,L1)') 'decimal_independent_of_binary=', decimal_after == decimal_before

  call ieee_set_rounding_mode(saved)
end program roundingModes_003
! CHECK: decimal_independent_of_binary=T
