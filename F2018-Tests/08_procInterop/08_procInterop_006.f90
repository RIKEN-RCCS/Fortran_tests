! RUN: %if flang %{ %cc -c %S/08_procInterop_006.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/08_procInterop_006.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/08_procInterop_006.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.8 [S2, S4, S5]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_call() bind(c)
    end subroutine
  end interface
contains
  subroutine f_alloc_char(s) bind(c)
    character(kind=c_char, len=:), allocatable, intent(out) :: s
    s = 'fortran'
  end subroutine
  subroutine f_point(p) bind(c)
    integer(c_int), pointer, intent(out) :: p(:)
    allocate(p(3:5))
    p = [30, 40, 50]
  end subroutine
end module

program main
  use m
  implicit none
  call c_call()
end program

! CHECK: allocatable_char base_addr_null=0 elem_len=7 text=fortran
! CHECK-NEXT: pointer_int base_addr_null=0 lower_bound=3 extent=3 values 30 40 50
