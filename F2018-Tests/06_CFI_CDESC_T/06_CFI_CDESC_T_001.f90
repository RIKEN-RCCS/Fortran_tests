! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/06_CFI_CDESC_T.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.6 [S1, S2, S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine macro_defined() bind(c, name="macro_defined")
    end subroutine
    subroutine ranks_0_1_7() bind(c, name="ranks_0_1_7")
    end subroutine
  end interface
  call macro_defined()
  call ranks_0_1_7()
end program main

! CHECK: CFI_CDESC_T defined=1
! CHECK-NEXT: CFI_CDESC_T(0) size>=need=1
! CHECK-NEXT: CFI_CDESC_T(0) align>=CFI_cdesc_t=1
! CHECK-NEXT: CFI_CDESC_T(1) size>=need=1
! CHECK-NEXT: CFI_CDESC_T(1) align>=CFI_cdesc_t=1
! CHECK-NEXT: CFI_CDESC_T(7) size>=need=1
! CHECK-NEXT: CFI_CDESC_T(7) align>=CFI_cdesc_t=1
! CHECK-NEXT: rank0 establish==CFI_SUCCESS=1 rank=0
! CHECK-NEXT: rank1 establish==CFI_SUCCESS=1 rank=1 dim0.extent=5
! CHECK-NEXT: rank7 establish==CFI_SUCCESS=1 rank=7 dim6.extent=3
