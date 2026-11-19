! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.1 [S3, S4, S8, S9], 2.2, 2.4

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine attr_type(a) bind(c, name="attr_type")
      import :: c_double
      real(c_double), allocatable :: a(:)
    end subroutine
  end interface
  real(c_double), allocatable :: x(:)
  allocate(x(4))
  x = 0
  call attr_type(x)
end program main

! CHECK: base_addr: nonnull
! CHECK-NEXT: attribute: allocatable
! CHECK-NEXT: elem_len: 8
! CHECK-NEXT: type==CFI_type_double: yes
! CHECK-NEXT: type!=CFI_type_other: yes
