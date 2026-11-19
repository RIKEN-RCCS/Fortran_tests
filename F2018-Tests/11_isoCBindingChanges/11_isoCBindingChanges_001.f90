! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.11 [S1]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  type :: noninterop
    character(len=3) :: label
    integer :: v
  end type
end module

program main
  use m
  implicit none
  type(noninterop), target :: a(2)
  type(c_ptr) :: p1, p2, p3
  integer :: n

  n = command_argument_count()
  a(1) = noninterop('abc', 10 + n)
  a(2) = noninterop('def', 20 + n)
  p1 = c_loc(a)
  p2 = c_loc(a(1))
  p3 = c_loc(a(2))
  print '(a,l1)', 'c_loc_first=', c_associated(p1, p2)
  print '(a,l1)', 'c_loc_second=', c_associated(p1, p3)
end program

! CHECK: c_loc_first=T
! CHECK-NEXT: c_loc_second=F
