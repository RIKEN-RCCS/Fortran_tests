! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.4 [S4]


program roundedConversions_005
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real32, real64
  implicit none
  type(ieee_round_type) :: saved
  real(real64) :: a
  real(real32) :: one, one_up

  a = 1.0_real64 + 3.0_real64 * 2.0_real64**(-25) + command_argument_count()
  one = 1.0_real32 + command_argument_count()
  one_up = one + spacing(one)

  call ieee_get_rounding_mode(saved)
  call ieee_set_rounding_mode(ieee_nearest)
  write(*,'(A,L1)') 'nearest ieee_real(1+0.75ulp,real32)_eq_1+ulp=', ieee_real(a, real32) == one_up
  call ieee_set_rounding_mode(ieee_to_zero)
  write(*,'(A,L1)') 'to_zero ieee_real(1+0.75ulp,real32)_eq_1=', ieee_real(a, real32) == one
  call ieee_set_rounding_mode(ieee_up)
  write(*,'(A,L1)') 'up ieee_real(1+0.75ulp,real32)_eq_1+ulp=', ieee_real(a, real32) == one_up
  call ieee_set_rounding_mode(ieee_down)
  write(*,'(A,L1)') 'down ieee_real(1+0.75ulp,real32)_eq_1=', ieee_real(a, real32) == one
  call ieee_set_rounding_mode(saved)
end program roundedConversions_005
! CHECK: nearest ieee_real(1+0.75ulp,real32)_eq_1+ulp=T
! CHECK-NEXT: to_zero ieee_real(1+0.75ulp,real32)_eq_1=T
! CHECK-NEXT: up ieee_real(1+0.75ulp,real32)_eq_1+ulp=T
! CHECK-NEXT: down ieee_real(1+0.75ulp,real32)_eq_1=T
