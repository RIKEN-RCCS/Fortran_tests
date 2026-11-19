! RUN: %if flang %{ %cc -c %S/16_optionalArguments_002.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/16_optionalArguments_002.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/16_optionalArguments_002.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.16 [S2]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_call() bind(c)
    end subroutine
  end interface
contains
  subroutine f_check(x) bind(c)
    integer(c_int), intent(in), optional :: x
    print '(a,l1)', 'f_check present=', present(x)
    if (present(x)) print '(a,i0)', 'f_check value=', x
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  call c_call()
end program

! CHECK: f_check present=T
! CHECK-NEXT: f_check value=13
! CHECK-NEXT: f_check present=F
