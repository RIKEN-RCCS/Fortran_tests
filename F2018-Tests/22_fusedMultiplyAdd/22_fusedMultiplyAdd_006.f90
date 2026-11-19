! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.5 [S2, S3]


program fusedMultiplyAdd_006
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: a, b, c
  real, volatile :: product, r
  logical :: inexact_flag, halting, halting_supported

  a = 4097.0 + command_argument_count()
  b = 4097.0 + command_argument_count()
  c = -16785408.0 - command_argument_count()
  write(*,'(A,L1)') 'inexact_flag_supported=', ieee_support_flag(ieee_inexact, a)
  halting_supported = ieee_support_halting(ieee_inexact)
  write(*,'(A,L1)') 'inexact_halting_supported=', halting_supported

  call ieee_get_halting_mode(ieee_inexact, halting)
  if (halting_supported) call ieee_set_halting_mode(ieee_inexact, .false.)

  call ieee_set_flag(ieee_inexact, .false.)
  product = a * b
  call ieee_get_flag(ieee_inexact, inexact_flag)
  write(*,'(A,L1)') 'product_alone inexact=', inexact_flag

  call ieee_set_flag(ieee_inexact, .false.)
  r = ieee_fma(a, b, c)
  call ieee_get_flag(ieee_inexact, inexact_flag)

  call ieee_set_flag(ieee_inexact, .false.)
  if (halting_supported) call ieee_set_halting_mode(ieee_inexact, halting)
  write(*,'(A,L1,A,L1)') 'fma(4097,4097,-16785408) result_eq_1=', r == 1.0, ' inexact=', inexact_flag
end program fusedMultiplyAdd_006
! CHECK: inexact_flag_supported=T
! CHECK-NEXT: inexact_halting_supported=T
! CHECK-NEXT: product_alone inexact=T
! CHECK-NEXT: fma(4097,4097,-16785408) result_eq_1=T inexact=F
