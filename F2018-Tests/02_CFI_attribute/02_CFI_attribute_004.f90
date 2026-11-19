! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/02_CFI_attribute_report_macros.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/02_CFI_attribute_report_macros.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/02_CFI_attribute_report_macros.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.2 [S1, S2]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine report_macros() bind(c, name="report_macros")
    end subroutine
  end interface
  call report_macros()
end program main

! CHECK: pointer_defined: yes
! CHECK-NEXT: allocatable_defined: yes
! CHECK-NEXT: other_defined: yes
! CHECK-NEXT: nonnegative: yes
! CHECK-NEXT: distinct: yes
