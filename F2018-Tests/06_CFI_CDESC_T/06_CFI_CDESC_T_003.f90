! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.6 [S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine roundtrip() bind(c, name="roundtrip")
    end subroutine
  end interface
  call roundtrip()
end program main

! CHECK: dim1.extent=99
! CHECK-NEXT: dim0.extent=2
