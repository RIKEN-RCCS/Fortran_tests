! RUN: %if flang %{ %cc -c %S/07_CFI_functions_015.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_015.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_015.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S41]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_error_codes() bind(c)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  call c_error_codes()
end program

! CHECK: CFI_SUCCESS=0
! CHECK-NEXT: others nonzero=1
! CHECK-NEXT: pairwise distinct=1
