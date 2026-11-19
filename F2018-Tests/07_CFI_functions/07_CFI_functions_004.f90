! RUN: %if flang %{ %cc -c %S/07_CFI_functions_004.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_004.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_004.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S11]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  type, bind(c) :: pt
    integer(c_int) :: i
    real(c_double) :: d
  end type
  interface
    subroutine c_establish_elem_len() bind(c)
    end subroutine
  end interface
contains
  subroutine f_char(s) bind(c)
    character(kind=c_char, len=*), intent(in) :: s
    print '(a,i0,1x,a)', 'char len=', len(s), s
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
  call c_establish_elem_len()
end program

! CHECK: char rc=0 elem_len=5 type_ok=1
! CHECK-NEXT: char len=5 hello
! CHECK-NEXT: struct rc=0 elem_len_ok=1 type_ok=1
! CHECK-NEXT: struct size=2 1 0.5 2 1.5
! CHECK-NEXT: int elem_len=0 rc=0 elem_len_ok=1
