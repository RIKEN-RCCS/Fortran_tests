! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.3 [S1, S2]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine type_facts() bind(c, name="type_facts")
    end subroutine
  end interface
  call type_facts()
end program main

! CHECK: CFI_index_t_standard_signed_integer_type: yes{{$}}
! CHECK-NEXT: pointer_difference_forward: 99999{{$}}
! CHECK-NEXT: pointer_difference_backward: -99999{{$}}
! CHECK-NEXT: dim_members_are_CFI_index_t: yes{{$}}
