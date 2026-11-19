! RUN: %if flang %{ %cc -c %S/08_procInterop_008.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/08_procInterop_008.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/08_procInterop_008.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.8 [S5]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  type :: t
    integer(c_int) :: i
    real(c_double) :: d
  end type
  interface
    subroutine c_relay(x) bind(c)
      type(*), dimension(..) :: x
    end subroutine
  end interface
contains
  subroutine f_recv(x) bind(c)
    type(*), dimension(..) :: x
    print '(a,i0,a,i0,a,i0)', 'f_recv rank=', rank(x), ' size=', size(x), ' lbound=', lbound(x, 1)
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  type(t) :: a(3)
  a = t(0, 0.0_c_double)
  call c_relay(a)
end program

! CHECK: relay type_other=1 rank=1
! CHECK-NEXT: f_recv rank=1 size=3 lbound=1
