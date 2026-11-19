! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.1 [S5, S6], 2.5 [S1, S3], 2.6 [S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine establish_version_rank() bind(c, name="establish_version_rank")
    end subroutine
  end interface
  call establish_version_rank()
end program main

! CHECK: establish rank 0: success=yes rank=0 version==CFI_VERSION=yes
! CHECK-NEXT: establish rank 1: success=yes rank=1 version==CFI_VERSION=yes
! CHECK-NEXT: establish rank 7: success=yes rank=7 version==CFI_VERSION=yes
