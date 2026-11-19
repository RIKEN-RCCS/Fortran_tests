! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.1 [S4, S7, S9], 2.3, 2.4

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine stride3(a) bind(c, name="stride3")
      import :: c_double
      real(c_double) :: a(:,:,:)
    end subroutine
  end interface
  real(c_double) :: arr(2,3,4)
  arr = 0
  call stride3(arr)
end program main

! CHECK: type==CFI_type_double: yes
! CHECK-NEXT: elem_len: 8
! CHECK-NEXT: dim[0].extent: 2
! CHECK-NEXT: dim[0].sm: 8
! CHECK-NEXT: dim[1].extent: 3
! CHECK-NEXT: dim[1].sm: 16
! CHECK-NEXT: dim[2].extent: 4
! CHECK-NEXT: dim[2].sm: 48
