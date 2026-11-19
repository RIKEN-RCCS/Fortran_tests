! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.4 [S4, S7]


program roundedConversions_006
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real32, real64
  implicit none
  type(ieee_round_type) :: saved
  integer :: n_exact, n_rounded
  real(real64) :: a_exact, a_rounded
  real :: y
  real(real32) :: one
  logical :: flag

  n_exact = 7 + command_argument_count()
  n_rounded = 16777217 + command_argument_count()
  a_exact = 3.5_real64 + command_argument_count()
  a_rounded = 1.0_real64 + 3.0_real64 * 2.0_real64**(-25) + command_argument_count()
  one = 1.0_real32 + command_argument_count()

  write(*,'(A,L1)') 'inexact_supported=', ieee_support_flag(ieee_inexact, y)

  call ieee_get_rounding_mode(saved)
  call ieee_set_rounding_mode(ieee_to_zero)

  call ieee_set_flag(ieee_inexact, .false.)
  y = ieee_real(n_exact)
  call ieee_get_flag(ieee_inexact, flag)
  write(*,'(A,F0.1,A,L1)') 'exact ieee_real(7)=', y, ' inexact=', flag

  call ieee_set_flag(ieee_inexact, .false.)
  y = ieee_real(n_rounded)
  call ieee_get_flag(ieee_inexact, flag)
  write(*,'(A,F0.1,A,L1)') 'rounded ieee_real(16777217)=', y, ' inexact=', flag

  call ieee_set_flag(ieee_inexact, .false.)
  y = ieee_real(a_exact, real32)
  call ieee_get_flag(ieee_inexact, flag)
  write(*,'(A,F0.1,A,L1)') 'exact ieee_real(3.5_real64,real32)=', y, ' inexact=', flag

  call ieee_set_flag(ieee_inexact, .false.)
  y = ieee_real(a_rounded, real32)
  call ieee_get_flag(ieee_inexact, flag)
  write(*,'(A,L1,A,L1)') 'rounded ieee_real(1+0.75ulp,real32)_eq_1=', y == one, ' inexact=', flag

  call ieee_set_rounding_mode(saved)
end program roundedConversions_006
! CHECK: inexact_supported=T
! CHECK-NEXT: exact ieee_real(7)=7.0 inexact=F
! CHECK-NEXT: rounded ieee_real(16777217)=16777216.0 inexact=T
! CHECK-NEXT: exact ieee_real(3.5_real64,real32)=3.5 inexact=F
! CHECK-NEXT: rounded ieee_real(1+0.75ulp,real32)_eq_1=T inexact=T
