! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S4, S8, S10]


program outOfRange_009
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  integer :: m

  write(*,'(A,L1)') 'undefined_mold=', out_of_range(1.0_dp + real(command_argument_count(), dp), m)
end program outOfRange_009
! CHECK: undefined_mold=F
