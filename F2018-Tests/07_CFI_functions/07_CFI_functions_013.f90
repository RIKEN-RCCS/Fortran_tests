! RUN: %if flang %{ %cc -c %S/07_CFI_functions_013.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_013.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_013.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S39]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_contiguous() bind(c)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  call c_contiguous()
end program

! CHECK: whole array=1
! CHECK-NEXT: section stride 1=1
! CHECK-NEXT: section stride 2=0
! CHECK-NEXT: rank2 row section=0
