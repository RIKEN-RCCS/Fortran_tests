! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.7 [S4]


program integerConversion_002
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a, b

  a = 2.5 + command_argument_count()
  b = -2.5 - command_argument_count()

  write(*,'(A,I0)') 'nearest int(2.5)=', ieee_int(a, ieee_nearest)
  write(*,'(A,I0)') 'to_zero int(2.5)=', ieee_int(a, ieee_to_zero)
  write(*,'(A,I0)') 'up int(2.5)=', ieee_int(a, ieee_up)
  write(*,'(A,I0)') 'down int(2.5)=', ieee_int(a, ieee_down)
  write(*,'(A,I0)') 'nearest int(-2.5)=', ieee_int(b, ieee_nearest)
  write(*,'(A,I0)') 'to_zero int(-2.5)=', ieee_int(b, ieee_to_zero)
  write(*,'(A,I0)') 'up int(-2.5)=', ieee_int(b, ieee_up)
  write(*,'(A,I0)') 'down int(-2.5)=', ieee_int(b, ieee_down)
end program integerConversion_002
! CHECK: nearest int(2.5)=2
! CHECK-NEXT: to_zero int(2.5)=2
! CHECK-NEXT: up int(2.5)=3
! CHECK-NEXT: down int(2.5)=2
! CHECK-NEXT: nearest int(-2.5)=-2
! CHECK-NEXT: to_zero int(-2.5)=-2
! CHECK-NEXT: up int(-2.5)=-2
! CHECK-NEXT: down int(-2.5)=-3
