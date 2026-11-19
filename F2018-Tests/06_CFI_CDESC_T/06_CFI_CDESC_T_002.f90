! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.6 [S2, S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine rank_15() bind(c, name="rank_15")
    end subroutine
  end interface
  call rank_15()
end program main

! CHECK: CFI_CDESC_T(15) size>=need=1
! CHECK-NEXT: CFI_CDESC_T(15) align>=CFI_cdesc_t=1
! CHECK-NEXT: rank15 establish==CFI_SUCCESS=1 rank=15 dim14.extent=3
