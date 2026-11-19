! RUN: %if flang %{ %cc -c %S/15_contiguousAttribute_003.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/15_contiguousAttribute_003.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/15_contiguousAttribute_003.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.15 [S3]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_call() bind(c)
    end subroutine
  end interface
contains
  subroutine f_show(a) bind(c)
    integer(c_int), contiguous, intent(in) :: a(:)
    print '(a,i0)', 'contiguous: size=', size(a)
    print '(a,3(1x,i0))', 'contiguous: values', a
  end subroutine
  subroutine f_show_nc(a) bind(c)
    integer(c_int), intent(in) :: a(:)
    print '(a,i0)', 'no contiguous: size=', size(a)
    print '(a,3(1x,i0))', 'no contiguous: values', a
  end subroutine
end module

program main
  use m
  implicit none
  call c_call()
end program

! CHECK: is_contiguous=0
! CHECK-NEXT: contiguous: size=3
! CHECK-NEXT: contiguous: values 1 3 5
! CHECK-NEXT: no contiguous: size=3
! CHECK-NEXT: no contiguous: values 1 3 5
