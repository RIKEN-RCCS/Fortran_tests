! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.7 [S6]


program integerConversion_004
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: a, b, c
  integer :: r
  logical :: first, second, other, exact_flag, halting

  a = 2.5 + command_argument_count()
  b = 4.0 + command_argument_count()
  c = 3.25 + command_argument_count()

  call ieee_get_halting_mode(ieee_inexact, halting)
  call ieee_set_halting_mode(ieee_inexact, .false.)

  call ieee_set_flag(ieee_inexact, .false.)
  r = ieee_int(a, ieee_to_zero)
  call ieee_get_flag(ieee_inexact, first)

  call ieee_set_flag(ieee_inexact, .false.)
  r = ieee_int(a, ieee_to_zero)
  call ieee_get_flag(ieee_inexact, second)

  call ieee_set_flag(ieee_inexact, .false.)
  r = ieee_int(c, ieee_to_zero)
  call ieee_get_flag(ieee_inexact, other)

  call ieee_set_flag(ieee_inexact, .false.)
  r = ieee_int(b, ieee_to_zero)
  call ieee_get_flag(ieee_inexact, exact_flag)

  call ieee_set_halting_mode(ieee_inexact, halting)

  write(*,'(A,L1)') 'inexact_consistent=', first .eqv. second
  write(*,'(A,L1)') 'inexact_consistent_other_input=', first .eqv. other
  write(*,'(A,L1)') 'exact_input_no_inexact=', .not. exact_flag
end program integerConversion_004
! CHECK: inexact_consistent=T
! CHECK-NEXT: inexact_consistent_other_input=T
! CHECK-NEXT: exact_input_no_inexact=T
