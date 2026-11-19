! RUN: %if flang %{ %cc -c %S/07_CFI_functions_009.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_009.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_009.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S28, S31]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_section_defaults(a) bind(c)
      import :: c_int
      integer(c_int), intent(in) :: a(:)
    end subroutine
  end interface
contains
  subroutine f_show(label, s) bind(c)
    integer(c_int), value :: label
    integer(c_int), intent(in) :: s(:)
    character(17), parameter :: names(4) = [character(17) :: &
        'lower_bounds=NULL', 'upper_bounds=NULL', 'strides=NULL', 'all NULL']
    print '(a,a,i0,a,*(1x,i0))', trim(names(label)), ': size=', size(s), ' values', s
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  integer(c_int) :: a(6), i
  a = [(i, i = 1, 6)]
  call c_section_defaults(a)
end program

! CHECK: CFI_section lower_bounds=NULL rc=0
! CHECK-NEXT: lower_bounds=NULL: size=3 values 1 3 5
! CHECK-NEXT: CFI_section upper_bounds=NULL rc=0
! CHECK-NEXT: upper_bounds=NULL: size=3 values 2 4 6
! CHECK-NEXT: CFI_section strides=NULL rc=0
! CHECK-NEXT: strides=NULL: size=3 values 2 3 4
! CHECK-NEXT: CFI_section all NULL rc=0
! CHECK-NEXT: all NULL: size=6 values 1 2 3 4 5 6
