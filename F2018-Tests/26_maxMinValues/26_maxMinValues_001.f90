! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.9 [S1, S2, S3]


program maxMinValues_001
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x, y

  x = 2.0 + command_argument_count()
  y = -3.0 - command_argument_count()

  write(*,'(A,F0.1)') 'max_num(2,-3)=', ieee_max_num(x, y)
  write(*,'(A,F0.1)') 'max_num_mag(2,-3)=', ieee_max_num_mag(x, y)
  write(*,'(A,F0.1)') 'min_num(2,-3)=', ieee_min_num(x, y)
  write(*,'(A,F0.1)') 'min_num_mag(2,-3)=', ieee_min_num_mag(x, y)
  write(*,'(A,L1)') 'result_kind=', kind(ieee_max_num(x, y)) == kind(x)
  write(*,'(A,L1)') 'elemental_applies=', &
       all(ieee_max_num([x, y], [y, x]) == [ieee_max_num(x, y), ieee_max_num(y, x)])
end program maxMinValues_001
! CHECK: max_num(2,-3)=2.0
! CHECK-NEXT: max_num_mag(2,-3)=-3.0
! CHECK-NEXT: min_num(2,-3)=-3.0
! CHECK-NEXT: min_num_mag(2,-3)=2.0
! CHECK-NEXT: result_kind=T
! CHECK-NEXT: elemental_applies=T
