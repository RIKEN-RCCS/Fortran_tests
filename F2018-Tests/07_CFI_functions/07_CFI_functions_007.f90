! RUN: %if flang %{ %cc -c %S/07_CFI_functions_007.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_007.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_007.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S22, S24, S25]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_allocate_pointer(p) bind(c)
      import :: c_double
      real(c_double), pointer, intent(inout) :: p(:,:)
    end subroutine
    subroutine c_allocate_char(s) bind(c)
      import :: c_char
      character(kind=c_char, len=:), allocatable, intent(inout) :: s
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  real(c_double), pointer :: p(:,:)
  character(kind=c_char, len=:), allocatable :: s

  p => null()
  call c_allocate_pointer(p)
  print '(a,l1)', 'pointer: associated=', associated(p)
  print '(a,2(1x,i0),a,2(1x,i0))', 'pointer: lbound=', lbound(p), ' ubound=', ubound(p)
  flush(output_unit)

  call c_allocate_char(s)
  print '(a,l1,a,i0,a,a)', 'char: allocated=', allocated(s), ' len=', len(s), ' value=', s
end program

! CHECK: pointer CFI_allocate rc=0
! CHECK-NEXT: pointer: associated=T
! CHECK-NEXT: pointer: lbound= 1 0 ubound= 3 2
! CHECK-NEXT: char CFI_allocate rc=0 elem_len=7
! CHECK-NEXT: char: allocated=T len=7 value=abcdefg
