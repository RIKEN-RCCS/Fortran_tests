! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.10 [S1, S2, S3, S4]


program adjacentNumbers_001
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x
  logical :: supported

  x = 1.0 + command_argument_count()
  supported = ieee_support_datatype(x)
  write(*,'(A,L1)') 'datatype_supported=', supported

  write(*,'(A,L1)') 'next_up_gt_x=', ieee_next_up(x) > x
  write(*,'(A,L1)') 'next_down_lt_x=', ieee_next_down(x) < x
  write(*,'(A,L1)') 'next_up_step_eq_spacing=', ieee_next_up(x) - x == spacing(x)
  write(*,'(A,L1)') 'next_down_of_next_up_eq_x=', ieee_next_down(ieee_next_up(x)) == x
  write(*,'(A,L1)') 'elemental_applies=', all(ieee_next_up([x, -x]) > [x, -x])
end program adjacentNumbers_001
! CHECK: datatype_supported=T
! CHECK-NEXT: next_up_gt_x=T
! CHECK-NEXT: next_down_lt_x=T
! CHECK-NEXT: next_up_step_eq_spacing=T
! CHECK-NEXT: next_down_of_next_up_eq_x=T
! CHECK-NEXT: elemental_applies=T
