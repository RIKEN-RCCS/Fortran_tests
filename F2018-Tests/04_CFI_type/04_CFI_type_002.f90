! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.4 [S1]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine macros_present() bind(c, name="macros_present")
    end subroutine
  end interface
  call macros_present()
end program main

! CHECK: table2_type_code_macros_present: yes
