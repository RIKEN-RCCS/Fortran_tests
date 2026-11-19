! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/04_CFI_type_005.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/04_CFI_type_005.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/04_CFI_type_005.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.4 [S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine macros_are_constants() bind(c, name="macros_are_constants")
    end subroutine
  end interface
  call macros_are_constants()
end program main

! CHECK: macros_defined: yes
! CHECK-NEXT: integer_constant_expressions: yes
