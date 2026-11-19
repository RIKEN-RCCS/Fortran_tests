! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.4 [S5, S6]


program roundedConversions_004
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved
  real :: a, b

  a = 2.5 + command_argument_count()
  b = -2.5 - command_argument_count()

  call ieee_get_rounding_mode(saved)
  call ieee_set_rounding_mode(ieee_nearest)

  write(*,'(A,F0.1)') 'round_omitted rint(2.5)=', ieee_rint(a)
  write(*,'(A,F0.1)') 'nearest rint(2.5)=', ieee_rint(a, ieee_nearest)
  write(*,'(A,F0.1)') 'to_zero rint(2.5)=', ieee_rint(a, ieee_to_zero)
  write(*,'(A,F0.1)') 'up rint(2.5)=', ieee_rint(a, ieee_up)
  write(*,'(A,F0.1)') 'down rint(2.5)=', ieee_rint(a, ieee_down)
  write(*,'(A,F0.1)') 'to_zero rint(-2.5)=', ieee_rint(b, ieee_to_zero)
  write(*,'(A,F0.1)') 'up rint(-2.5)=', ieee_rint(b, ieee_up)
  write(*,'(A,F0.1)') 'down rint(-2.5)=', ieee_rint(b, ieee_down)

  call ieee_set_rounding_mode(saved)
end program roundedConversions_004
! CHECK: round_omitted rint(2.5)=2.0
! CHECK-NEXT: nearest rint(2.5)=2.0
! CHECK-NEXT: to_zero rint(2.5)=2.0
! CHECK-NEXT: up rint(2.5)=3.0
! CHECK-NEXT: down rint(2.5)=2.0
! CHECK-NEXT: to_zero rint(-2.5)=-2.0
! CHECK-NEXT: up rint(-2.5)=-2.0
! CHECK-NEXT: down rint(-2.5)=-3.0
