! RUN: %if flang %{ %cc -c %S/07_CFI_functions_008.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_008.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_008.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S28, S29, S30]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_section_rank1(a) bind(c)
      import :: c_int
      integer(c_int), intent(in) :: a(:)
    end subroutine
    subroutine c_section_rank2(b) bind(c)
      import :: c_int
      integer(c_int), intent(in) :: b(:,:)
    end subroutine
  end interface
contains
  subroutine f_show(stride, s) bind(c)
    integer(c_int), value :: stride
    integer(c_int), intent(in) :: s(:)
    print '(a,i0,a,i0,a,*(1x,i0))', 'stride=', stride, ': size=', size(s), ' values', s
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  integer(c_int) :: a(10), b(3,4), i
  a = [(i, i = 1, 10)]
  b = reshape([(i, i = 1, 12)], [3, 4])
  call c_section_rank1(a)
  call c_section_rank2(b)
end program

! CHECK: CFI_section stride=3 rc=0
! CHECK-NEXT: stride=3: size=3 values 2 5 8
! CHECK-NEXT: CFI_section stride=-3 rc=0
! CHECK-NEXT: stride=-3: size=3 values 9 6 3
! CHECK-NEXT: CFI_section stride=0 rc=0 rank=1
! CHECK-NEXT: stride=0: size=4 values 2 5 8 11
