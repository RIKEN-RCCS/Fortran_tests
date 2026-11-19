! RUN: %if flang %{ %cc -c %S/13_assumedType_001.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/13_assumedType_001.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/13_assumedType_001.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S1, S2]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_show_int(x) bind(c)
      type(*), intent(in) :: x
    end subroutine
    subroutine c_show_double(x) bind(c)
      type(*), intent(in) :: x
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int) :: i = 42
  real(c_double) :: d = 3.5_c_double
  call c_show_int(i)
  call c_show_double(d)
end program

! CHECK: int=42
! CHECK-NEXT: double=3.5
