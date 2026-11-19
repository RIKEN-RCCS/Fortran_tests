! RUN: %if flang %{ %cc -c %S/08_procInterop_007.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/08_procInterop_007.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/08_procInterop_007.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.8 [S1, S5]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_call() bind(c)
    end subroutine
  end interface
contains
  subroutine f_show(s) bind(c)
    character(kind=c_char, len=*), intent(in) :: s
    print '(a,i0,a,a)', 'assumed_len len=', len(s), ' text=', s
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  call c_call()
end program

! CHECK: assumed_len len=4 text=wxyz
