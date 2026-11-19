! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.5 [S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine rank_member(a) bind(c, name="rank_member")
      import :: c_double
      real(c_double) :: a(..)
    end subroutine
  end interface
  real(c_double) :: s
  s = 0
  call rank_member(s)
end program main

! CHECK: rank=0
! CHECK-NEXT: rank<=CFI_MAX_RANK=1
