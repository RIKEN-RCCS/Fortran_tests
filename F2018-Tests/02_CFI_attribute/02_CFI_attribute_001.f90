! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/02_CFI_attribute_check_attr.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/02_CFI_attribute_check_attr.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/02_CFI_attribute_check_attr.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.2 [S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine check_attr(a, expect) bind(c, name="check_attr")
      import :: c_int
      integer(c_int), allocatable :: a(:)
      integer(c_int) :: expect
    end subroutine
  end interface
  integer(c_int), allocatable :: x(:)
  integer(c_int) :: expect_allocatable = 1
  allocate(x(2))
  x = 0
  call check_attr(x, expect_allocatable)
end program main

! CHECK: attribute: allocatable
! CHECK-NEXT: matches_expected: yes
