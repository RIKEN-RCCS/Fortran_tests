! RUN: %if flang %{ %cc -c %S/13_assumedType_003.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/13_assumedType_003.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/13_assumedType_003.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S3]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_show_shape(x) bind(c)
      type(*), intent(in) :: x(:)
    end subroutine
    subroutine c_show_rank(x) bind(c)
      type(*), intent(in) :: x(..)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  real(c_double) :: v(3) = [1.5, 2.5, 3.5]
  integer(c_int) :: w(2,2) = reshape([10,20,30,40],[2,2])
  call c_show_shape(v)
  call c_show_rank(w)
end program

! CHECK: shape: type_ok=1 v(1)=1.5
! CHECK-NEXT: rank: rank=2 type_ok=1 first=10
