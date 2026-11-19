! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.9 [S6]


program maxMinValues_004
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x, y

  x = 2.0 + command_argument_count()
  y = -2.0 - command_argument_count()

  write(*,'(A,F0.1)') 'max_num_mag(2,-2)=', ieee_max_num_mag(x, y)
  write(*,'(A,F0.1)') 'min_num_mag(2,-2)=', ieee_min_num_mag(x, y)
  write(*,'(A,L1)') 'max_num_mag_eq_max_num=', ieee_max_num_mag(x, y) == ieee_max_num(x, y)
  write(*,'(A,L1)') 'min_num_mag_eq_min_num=', ieee_min_num_mag(x, y) == ieee_min_num(x, y)
end program maxMinValues_004
! CHECK: max_num_mag(2,-2)=2.0
! CHECK-NEXT: min_num_mag(2,-2)=-2.0
! CHECK-NEXT: max_num_mag_eq_max_num=T
! CHECK-NEXT: min_num_mag_eq_min_num=T
