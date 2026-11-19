! RUN: %if flang %{ %cc -c %S/16_optionalArguments_001.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/16_optionalArguments_001.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/16_optionalArguments_001.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.16 [S1]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_take(x) bind(c)
      import :: c_int
      integer(c_int), intent(in), optional :: x
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int) :: v = 7
  call c_take(v)
  call c_take()
end program

! CHECK: c_take present null=0 value=7
! CHECK-NEXT: c_take absent null=1
