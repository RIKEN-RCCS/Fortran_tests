! RUN: %if flang %{ %cc -c %S/14_allocatableIntentOut_002.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/14_allocatableIntentOut_002.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/14_allocatableIntentOut_002.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.14 [S1]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_call() bind(c)
    end subroutine
  end interface
contains
  subroutine f_reset(a) bind(c)
    integer(c_int), allocatable, intent(out) :: a(:)
    print '(a,l1)', 'on entry: allocated=', allocated(a)
    flush(output_unit)
    allocate(a(2))
    a = [9, 9]
  end subroutine
end module

program main
  use m
  implicit none
  call c_call()
end program

! CHECK: on entry: allocated=F
! CHECK-NEXT: base_addr_null before call=0
! CHECK-NEXT: base_addr_null after return=0
