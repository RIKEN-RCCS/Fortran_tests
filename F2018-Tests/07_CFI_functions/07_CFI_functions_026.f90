! RUN: %if flang %{ %cc -c %S/07_CFI_functions_026.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_026.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_026.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S13]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_establish_max_rank() bind(c)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  call c_establish_max_rank()
end program

! CHECK: rank CFI_MAX_RANK: rc=0 rank_ok=1 extents_ok=1 dim0.extent=2 dimlast.extent=3
