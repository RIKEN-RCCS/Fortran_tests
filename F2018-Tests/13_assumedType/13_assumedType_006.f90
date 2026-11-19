! RUN: %if flang %{ %cc -c %S/13_assumedType_006.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/13_assumedType_006.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/13_assumedType_006.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S2, S4, S6]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_peek(p) bind(c)
      import :: c_ptr
      type(c_ptr), value :: p
    end subroutine
  end interface
contains
  subroutine pass(x)
    type(*), target :: x
    call c_peek(c_loc(x))
  end subroutine
end module

program main
  use m
  implicit none
  integer(c_int), target :: i = 42_c_int
  call pass(i)
end program

! CHECK: c_loc int=42
