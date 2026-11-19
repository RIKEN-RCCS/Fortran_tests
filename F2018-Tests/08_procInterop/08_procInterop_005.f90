! RUN: %if flang %{ %cc -c %S/08_procInterop_005.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/08_procInterop_005.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/08_procInterop_005.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.8 [S5]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  type, bind(c) :: pt
    integer(c_int) :: i
    real(c_double) :: d
  end type
  interface
    subroutine c_call() bind(c)
    end subroutine
  end interface
contains
  subroutine f_double(a) bind(c)
    real(c_double), intent(in) :: a(:)
    print '(a,i0,3(1x,f3.1))', 'double size=', size(a), a
    flush(output_unit)
  end subroutine
  subroutine f_struct(a) bind(c)
    type(pt), intent(in) :: a(:)
    print '(a,i0,2(1x,i0,1x,f3.1))', 'struct size=', size(a), a(1)%i, a(1)%d, a(2)%i, a(2)%d
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  call c_call()
end program

! CHECK: double size=3 1.0 2.0 3.0
! CHECK-NEXT: struct size=2 1 0.5 2 1.5
