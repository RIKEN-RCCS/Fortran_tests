! RUN: %if flang %{ %cc -c %S/07_CFI_functions_017.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_017.c -o %t.o && %gfortran -fcheck=bounds %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_017.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S6, S11, S13, S45, S46]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_errors() bind(c)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  call c_errors()
end program

! CHECK: CFI_establish character elem_len=0: rc={{-?[0-9]+}} detected=1 unmodified=1
! CHECK-NEXT: CFI_establish rank CFI_MAX_RANK+1: rc={{-?[0-9]+}} detected=1 unmodified=1
