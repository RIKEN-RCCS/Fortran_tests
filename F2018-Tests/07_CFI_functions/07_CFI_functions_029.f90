! RUN: %if flang %{ %cc -c %S/07_CFI_functions_029.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_029.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_029.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S18]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_setpointer_char(p, q) bind(c)
      import :: c_char
      character(kind=c_char, len=:), pointer, intent(inout) :: p(:)
      character(kind=c_char, len=:), pointer, intent(in) :: q(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  character(kind=c_char, len=5), target :: t(2) = [character(kind=c_char, len=5) :: 'hello', 'world']
  character(kind=c_char, len=:), pointer :: p(:), q(:)
  q => t
  p => null()
  call c_setpointer_char(p, q)
  print '(a,l1,a,i0)', 'associated=', associated(p), ' len=', len(p)
  print '(a,*(1x,a))', 'values', p
  flush(output_unit)
end program

! CHECK: CFI_setpointer rc=0 elem_len=5
! CHECK-NEXT: associated=T len=5
! CHECK-NEXT: values hello world
