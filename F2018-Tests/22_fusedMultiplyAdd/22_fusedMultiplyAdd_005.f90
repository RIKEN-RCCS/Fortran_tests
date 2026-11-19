! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.5 [S2, S3]


program fusedMultiplyAdd_005
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  type(ieee_round_type) :: saved_round
  real :: a, b, c, zero
  real, volatile :: product, r, final_r
  logical :: underflow_flag, inexact_flag, final_underflow_flag
  logical :: halting_underflow, halting_inexact, halting_supported

  a = tiny(1.0) * (1.0 + command_argument_count())
  b = tiny(1.0) * (1.0 + command_argument_count())
  c = 1.0 + command_argument_count()
  zero = 0.0 + command_argument_count()
  write(*,'(A,L1)') 'underflow_flag_supported=', ieee_support_flag(ieee_underflow, a)
  write(*,'(A,L1)') 'inexact_flag_supported=', ieee_support_flag(ieee_inexact, a)
  write(*,'(A,L1)') 'nearest_supported=', ieee_support_rounding(ieee_nearest, a)
  halting_supported = ieee_support_halting(ieee_underflow) .and. ieee_support_halting(ieee_inexact)
  write(*,'(A,L1)') 'halting_supported=', halting_supported

  call ieee_get_rounding_mode(saved_round)
  call ieee_set_rounding_mode(ieee_nearest)
  call ieee_get_halting_mode(ieee_underflow, halting_underflow)
  call ieee_get_halting_mode(ieee_inexact, halting_inexact)
  if (halting_supported) then
    call ieee_set_halting_mode(ieee_underflow, .false.)
    call ieee_set_halting_mode(ieee_inexact, .false.)
  end if

  call ieee_set_flag(ieee_underflow, .false.)
  product = a * b
  call ieee_get_flag(ieee_underflow, underflow_flag)
  write(*,'(A,L1)') 'product_alone underflow=', underflow_flag

  call ieee_set_flag(ieee_underflow, .false.)
  call ieee_set_flag(ieee_inexact, .false.)
  r = ieee_fma(a, b, c)
  call ieee_get_flag(ieee_underflow, underflow_flag)
  call ieee_get_flag(ieee_inexact, inexact_flag)

  call ieee_set_flag(ieee_underflow, .false.)
  final_r = ieee_fma(a, b, zero)
  call ieee_get_flag(ieee_underflow, final_underflow_flag)

  call ieee_set_flag(ieee_underflow, .false.)
  call ieee_set_flag(ieee_inexact, .false.)
  if (halting_supported) then
    call ieee_set_halting_mode(ieee_underflow, halting_underflow)
    call ieee_set_halting_mode(ieee_inexact, halting_inexact)
  end if
  call ieee_set_rounding_mode(saved_round)
  write(*,'(A,L1,A,L1,A,L1)') 'fma(tiny,tiny,1) result_eq_1=', r == c, ' underflow=', underflow_flag, &
      ' inexact=', inexact_flag
  write(*,'(A,L1)') 'fma(tiny,tiny,0) underflow=', final_underflow_flag
end program fusedMultiplyAdd_005
! CHECK: underflow_flag_supported=T
! CHECK-NEXT: inexact_flag_supported=T
! CHECK-NEXT: nearest_supported=T
! CHECK-NEXT: halting_supported=T
! CHECK-NEXT: product_alone underflow=T
! CHECK-NEXT: fma(tiny,tiny,1) result_eq_1=T underflow=F inexact=T
! CHECK-NEXT: fma(tiny,tiny,0) underflow=T
