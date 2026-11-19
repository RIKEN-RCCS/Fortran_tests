! RUN: %if flang %{ %cc -c %S/13_assumedType_009.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/13_assumedType_009.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/13_assumedType_009.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S2, S3, S4, S6]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_peek_first(p, form) bind(c)
      import :: c_ptr, c_int
      type(c_ptr), value :: p
      integer(c_int), value :: form
    end subroutine
  end interface
contains
  subroutine pass_size(x)
    type(*), target :: x(*)
    call c_peek_first(c_loc(x), 0_c_int)
  end subroutine
  subroutine pass_shape(x)
    type(*), target :: x(:)
    call c_peek_first(c_loc(x), 1_c_int)
  end subroutine
  subroutine pass_rank(x)
    type(*), target :: x(..)
    call c_peek_first(c_loc(x), 2_c_int)
  end subroutine
end module

program main
  use m
  implicit none
  integer(c_int), target :: v(3) = [7_c_int, 8_c_int, 9_c_int]
  integer(c_int), target :: w(2,2) = reshape([10_c_int, 20_c_int, 30_c_int, 40_c_int], [2,2])
  call pass_size(v)
  call pass_shape(v)
  call pass_rank(w)
end program

! CHECK: c_loc size first=7
! CHECK-NEXT: c_loc shape first=7
! CHECK-NEXT: c_loc rank first=10
