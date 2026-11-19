! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.7 [S5]


program integerConversion_003
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: a
  integer :: r
  logical :: invalid_flag, halting

  a = huge(1.0) - command_argument_count()

  call ieee_get_halting_mode(ieee_invalid, halting)
  call ieee_set_halting_mode(ieee_invalid, .false.)
  call ieee_set_flag(ieee_invalid, .false.)

  r = ieee_int(a, ieee_to_zero)

  call ieee_get_flag(ieee_invalid, invalid_flag)
  call ieee_set_halting_mode(ieee_invalid, halting)

  write(*,'(A,L1)') 'out_of_range_signals_invalid=', invalid_flag
end program integerConversion_003
! CHECK: out_of_range_signals_invalid=T
