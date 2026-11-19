! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/05_CFI_MAX_RANK.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.5 [S1]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine version_member(a) bind(c, name="version_member")
      import :: c_double
      real(c_double) :: a(:)
    end subroutine
  end interface
  real(c_double) :: arr(3)
  arr = 0
  call version_member(arr)
end program main

! CHECK: version==CFI_VERSION=1
