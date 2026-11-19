! RUN: %if flang %{ %cc -c %S/07_CFI_functions_023.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_023.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_023.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S28, S29, S30]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_section_pointer(p, a) bind(c)
      import :: c_int
      integer(c_int), pointer, intent(inout) :: p(:)
      integer(c_int), allocatable, intent(in) :: a(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), allocatable :: a(:)
  integer(c_int), pointer :: p(:)
  integer :: i
  allocate(a(2:9))
  a = [(10 * i, i = 1, 8)]
  p => null()
  call c_section_pointer(p, a)
  print '(a,l1,a,i0)', 'section pointer: associated=', associated(p), ' size=', size(p)
  print '(a,*(1x,i0))', 'section pointer: values', p
  flush(output_unit)
end program

! CHECK: section into pointer: rc=0
! CHECK-NEXT: section pointer: associated=T size=3
! CHECK-NEXT: section pointer: values 20 40 60
