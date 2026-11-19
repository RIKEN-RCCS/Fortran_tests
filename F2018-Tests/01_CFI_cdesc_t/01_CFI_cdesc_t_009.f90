! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t_interaction.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.1 [S2, S6, S7], 2.3, 2.5 [S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine rank15(a) bind(c, name="rank15")
      import :: c_double
      real(c_double) :: a(:,:,:,:,:,:,:,:,:,:,:,:,:,:,:)
    end subroutine
  end interface
  real(c_double) :: a15(2,1,1,1,1,1,1,1,1,1,1,1,1,1,3)
  a15 = 0
  call rank15(a15)
end program main

! CHECK: rank: 15
! CHECK-NEXT: rank<=CFI_MAX_RANK: yes
! CHECK-NEXT: dim[0].extent: 2
! CHECK-NEXT: dim[1:13].extent==1: yes
! CHECK-NEXT: dim[14].extent: 3
