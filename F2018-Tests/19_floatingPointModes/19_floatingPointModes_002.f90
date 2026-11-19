! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.2 [S2, S3]


program floatingPointModes_002
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  type(ieee_modes_type) :: saved
  type(ieee_round_type) :: round_before, round_after
  real :: a, b, c

  a = 3.0 + command_argument_count()
  b = 7.0 + command_argument_count()

  call ieee_get_rounding_mode(round_before)
  call ieee_get_modes(saved)

  call ieee_set_rounding_mode(ieee_up)
  c = a / b
  call ieee_set_rounding_mode(ieee_down)
  c = c + a / b
  call ieee_set_rounding_mode(ieee_to_zero)
  c = c + a / b

  call ieee_set_modes(saved)
  call ieee_get_rounding_mode(round_after)

  write(*,'(A,L1)') 'rounding_restored_after_arith=', round_after == round_before
  write(*,'(A,L1)') 'arith_result_positive=', c > 0.0
end program floatingPointModes_002
! CHECK: rounding_restored_after_arith=T
! CHECK-NEXT: arith_result_positive=T
