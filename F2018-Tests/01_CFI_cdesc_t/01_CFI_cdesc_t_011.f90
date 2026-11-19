! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.1 [S8], 2.2, 2.6 [S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine establish_attr() bind(c, name="establish_attr")
    end subroutine
  end interface
  call establish_attr()
end program main

! CHECK: establish CFI_attribute_other: success=yes attribute=other
! CHECK-NEXT: establish CFI_attribute_pointer: success=yes attribute=pointer
! CHECK-NEXT: establish CFI_attribute_allocatable: success=yes attribute=allocatable
