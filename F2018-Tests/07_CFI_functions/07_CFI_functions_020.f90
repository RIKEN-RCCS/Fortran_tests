! RUN: %if flang %{ %cc -c %S/07_CFI_functions_020.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_020.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_020.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S11]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_establish_type_other() bind(c)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  call c_establish_type_other()
end program

! CHECK: type other: rc=0 elem_len=12 type_ok=1
