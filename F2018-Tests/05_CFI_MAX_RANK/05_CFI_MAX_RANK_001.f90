! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.5 [S1, S2]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine constants() bind(c, name="constants")
    end subroutine
  end interface
  call constants()
end program main

! CHECK: CFI_VERSION defined=1
! CHECK-NEXT: CFI_MAX_RANK defined=1
! CHECK-NEXT: CFI_MAX_RANK>=15=1
