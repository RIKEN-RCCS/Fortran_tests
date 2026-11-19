! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.10 [S1, S2]

program ptrdiffT_004
  use, intrinsic :: iso_c_binding, only: c_ptrdiff_t
  implicit none

  write(*,'(A,L1)') 'c_ptrdiff_t>=0=', c_ptrdiff_t >= 0
end program ptrdiffT_004
! CHECK: c_ptrdiff_t>=0=T
