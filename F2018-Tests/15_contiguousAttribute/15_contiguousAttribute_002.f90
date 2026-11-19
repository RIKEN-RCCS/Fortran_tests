! RUN: %if flang %{ %cc -c %S/15_contiguousAttribute_002.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/15_contiguousAttribute_002.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/15_contiguousAttribute_002.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.15 [S2]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_show(a) bind(c)
      import :: c_int
      integer(c_int), contiguous, intent(in) :: a(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int) :: v(6) = [1, 2, 3, 4, 5, 6]
  call c_show(v(1:5:2))
end program

! CHECK: is_contiguous=1
! CHECK-NEXT: values 1 3 5
