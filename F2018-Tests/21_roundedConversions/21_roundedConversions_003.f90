! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.4 [S4]


program roundedConversions_003
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved
  integer :: n, m

  n = 33554435 + command_argument_count()
  m = 16777217 + command_argument_count()

  call ieee_get_rounding_mode(saved)

  call ieee_set_rounding_mode(ieee_nearest)
  write(*,'(A,F0.1)') 'nearest ieee_real(33554435)=', ieee_real(n)
  write(*,'(A,F0.1)') 'nearest ieee_real(16777217)=', ieee_real(m)
  call ieee_set_rounding_mode(ieee_to_zero)
  write(*,'(A,F0.1)') 'to_zero ieee_real(33554435)=', ieee_real(n)
  call ieee_set_rounding_mode(ieee_up)
  write(*,'(A,F0.1)') 'up ieee_real(33554435)=', ieee_real(n)
  write(*,'(A,F0.1)') 'up ieee_real(16777217)=', ieee_real(m)
  call ieee_set_rounding_mode(ieee_down)
  write(*,'(A,F0.1)') 'down ieee_real(33554435)=', ieee_real(n)

  call ieee_set_rounding_mode(saved)
end program roundedConversions_003
! CHECK: nearest ieee_real(33554435)=33554436.0
! CHECK-NEXT: nearest ieee_real(16777217)=16777216.0
! CHECK-NEXT: to_zero ieee_real(33554435)=33554432.0
! CHECK-NEXT: up ieee_real(33554435)=33554436.0
! CHECK-NEXT: up ieee_real(16777217)=16777218.0
! CHECK-NEXT: down ieee_real(33554435)=33554432.0
