! RUN: %if flang %{ %cc -c %S/07_CFI_functions_011.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_011.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_011.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S32, S35]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_select_substring() bind(c)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  call c_select_substring()
end program

! CHECK: substring: rc=0 elem_len=3 values bcd ghi
