! RUN: %if flang %{ %cc -c %S/07_CFI_functions_030.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_030.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_030.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S17]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_setpointer_scalar(p, q) bind(c)
      import :: c_int
      integer(c_int), pointer, intent(inout) :: p
      integer(c_int), pointer, intent(in) :: q
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), target :: t = 42
  integer(c_int), pointer :: p, q
  q => t
  p => null()
  call c_setpointer_scalar(p, q)
  print '(a,l1,1x,l1)', 'associated=', associated(p), associated(p, t)
  print '(a,i0)', 'value=', p
  flush(output_unit)
end program

! CHECK: CFI_setpointer rc=0
! CHECK-NEXT: associated=T T
! CHECK-NEXT: value=42
