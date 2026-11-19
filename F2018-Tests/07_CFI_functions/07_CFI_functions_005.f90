! RUN: %if flang %{ %cc -c %S/07_CFI_functions_005.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_005.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_005.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S17]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_setpointer(p, q, mode) bind(c)
      import :: c_int
      integer(c_int), pointer, intent(inout) :: p(:)
      integer(c_int), pointer, intent(in) :: q(:)
      integer(c_int), value :: mode
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), target :: t(5) = [1, 2, 3, 4, 5]
  integer(c_int), pointer :: p(:), q(:)

  q(4:) => t
  p => null()
  call c_setpointer(p, q, 1)
  print '(a,l1,1x,l1)', 'lower_bounds=-2: associated=', associated(p), associated(p, t)
  print '(a,i0,1x,i0)', 'lower_bounds=-2: bounds=', lbound(p, 1), ubound(p, 1)
  print '(a,5(1x,i0))', 'lower_bounds=-2: values', p
  flush(output_unit)

  p => null()
  call c_setpointer(p, q, 2)
  print '(a,l1,1x,l1)', 'lower_bounds=NULL: associated=', associated(p), associated(p, t)
  flush(output_unit)

  call c_setpointer(p, q, 3)
  print '(a,l1)', 'source=NULL: associated=', associated(p)
  flush(output_unit)
end program

! CHECK: CFI_setpointer lower_bounds=-2: rc=0
! CHECK-NEXT: lower_bounds=-2: associated=T T
! CHECK-NEXT: lower_bounds=-2: bounds=-2 2
! CHECK-NEXT: lower_bounds=-2: values 1 2 3 4 5
! CHECK-NEXT: CFI_setpointer lower_bounds=NULL: rc=0
! CHECK-NEXT: lower_bounds=NULL: associated=T T
! CHECK-NEXT: CFI_setpointer source=NULL: rc=0
! CHECK-NEXT: source=NULL: associated=F
