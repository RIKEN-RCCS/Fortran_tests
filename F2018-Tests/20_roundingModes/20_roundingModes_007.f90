! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.3 [S1], 4.4 [S5, S6]


program roundingModes_007
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a, b
  a = 2.5 + command_argument_count()
  b = -2.5 - command_argument_count()
  write(*,'(A,F0.1)') 'away rint(2.5)=', ieee_rint(a, ieee_away)
  write(*,'(A,F0.1)') 'away rint(-2.5)=', ieee_rint(b, ieee_away)
end program roundingModes_007
! CHECK: away rint(2.5)=3.0
! CHECK-NEXT: away rint(-2.5)=-3.0
