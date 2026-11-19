! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.7 [S4]


program integerConversion_005
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a(4)
  type(ieee_round_type) :: modes(4)
  integer :: r(4)

  a = [2.5, 2.5, 2.5, -2.5] + command_argument_count() * [1.0, 1.0, 1.0, -1.0]
  modes = [ieee_nearest, ieee_up, ieee_down, ieee_to_zero]
  r = ieee_int(a, modes)
  write(*,'(A,I0)') 'array_round nearest int(2.5)=', r(1)
  write(*,'(A,I0)') 'array_round up int(2.5)=', r(2)
  write(*,'(A,I0)') 'array_round down int(2.5)=', r(3)
  write(*,'(A,I0)') 'array_round to_zero int(-2.5)=', r(4)
end program integerConversion_005
! CHECK: array_round nearest int(2.5)=2
! CHECK-NEXT: array_round up int(2.5)=3
! CHECK-NEXT: array_round down int(2.5)=2
! CHECK-NEXT: array_round to_zero int(-2.5)=-2
