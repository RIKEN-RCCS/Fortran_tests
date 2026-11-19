! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.3 [S1], 4.7 [S4]


program roundingModes_006
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a, b

  a = 2.5 + command_argument_count()
  b = -2.5 - command_argument_count()

  write(*,'(A,I0)') 'away ieee_int(2.5)=', ieee_int(a, ieee_away)
  write(*,'(A,I0)') 'away ieee_int(-2.5)=', ieee_int(b, ieee_away)
end program roundingModes_006
! CHECK: away ieee_int(2.5)=3
! CHECK-NEXT: away ieee_int(-2.5)=-3
