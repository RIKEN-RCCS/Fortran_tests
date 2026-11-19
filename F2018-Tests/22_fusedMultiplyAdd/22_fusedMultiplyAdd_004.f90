! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.5 [S2, S3]


program fusedMultiplyAdd_004
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: a, b, c, zero
  real, volatile :: r, final_r
  logical :: overflow_flag, final_overflow_flag, halting, halting_supported

  a = huge(1.0)
  b = 2.0 + command_argument_count()
  c = -huge(1.0)
  zero = 0.0 + command_argument_count()
  write(*,'(A,L1)') 'overflow_flag_supported=', ieee_support_flag(ieee_overflow, a)
  halting_supported = ieee_support_halting(ieee_overflow)
  write(*,'(A,L1)') 'overflow_halting_supported=', halting_supported

  call ieee_get_halting_mode(ieee_overflow, halting)
  if (halting_supported) call ieee_set_halting_mode(ieee_overflow, .false.)

  call ieee_set_flag(ieee_overflow, .false.)
  r = ieee_fma(a, b, c)
  call ieee_get_flag(ieee_overflow, overflow_flag)

  call ieee_set_flag(ieee_overflow, .false.)
  final_r = ieee_fma(a, b, zero)
  call ieee_get_flag(ieee_overflow, final_overflow_flag)

  call ieee_set_flag(ieee_overflow, .false.)
  if (halting_supported) call ieee_set_halting_mode(ieee_overflow, halting)

  write(*,'(A,L1)') 'fma_result_finite=', ieee_is_finite(r)
  write(*,'(A,L1)') 'fma_result_eq_huge=', r == huge(1.0)
  write(*,'(A,L1)') 'overflow_not_signalled=', .not. overflow_flag
  write(*,'(A,L1)') 'final_overflow_signalled=', final_overflow_flag
end program fusedMultiplyAdd_004
! CHECK: overflow_flag_supported=T
! CHECK-NEXT: overflow_halting_supported=T
! CHECK-NEXT: fma_result_finite=T
! CHECK-NEXT: fma_result_eq_huge=T
! CHECK-NEXT: overflow_not_signalled=T
! CHECK-NEXT: final_overflow_signalled=T
