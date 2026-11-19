! RUN: %if flang %{ %cc -c %S/08_procInterop_004.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/08_procInterop_004.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/08_procInterop_004.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.8 [S3]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_show_scalar(x, kind) bind(c)
      import :: c_int
      type(*), intent(in) :: x
      integer(c_int), value :: kind
    end subroutine
    subroutine c_show_array(x, n) bind(c)
      import :: c_int
      type(*), intent(in) :: x(*)
      integer(c_int), value :: n
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int) :: i = 42, v(3) = [4, 5, 6]
  real(c_double) :: d = 1.5_c_double
  call c_show_scalar(i, 0)
  call c_show_scalar(d, 1)
  call c_show_array(v, 3)
end program

! CHECK: int scalar=42
! CHECK-NEXT: double scalar=1.5
! CHECK-NEXT: int array 4 5 6
