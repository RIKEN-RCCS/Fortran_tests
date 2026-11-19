! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/02_CFI_attribute_report_type.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/02_CFI_attribute_report_type.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/02_CFI_attribute_report_type.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.2 [S4]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine report_type() bind(c, name="report_type")
    end subroutine
  end interface
  call report_type()
end program main

! CHECK: attribute_t_standard_integer: yes
! CHECK-NEXT: pointer_representable: yes
! CHECK-NEXT: allocatable_representable: yes
! CHECK-NEXT: other_representable: yes
