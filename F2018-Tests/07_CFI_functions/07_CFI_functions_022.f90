! RUN: %if flang %{ %cc -c %S/07_CFI_functions_022.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_022.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_022.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S17]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_setpointer_rank2(p, q) bind(c)
      import :: c_int
      integer(c_int), pointer, intent(inout) :: p(:,:)
      integer(c_int), pointer, intent(in) :: q(:,:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), target :: t(2, 3)
  integer(c_int), pointer :: p(:,:), q(:,:)
  t = reshape([1, 2, 3, 4, 5, 6], [2, 3])
  q => t
  p => null()
  call c_setpointer_rank2(p, q)
  print '(a,l1,1x,l1)', 'rank 2 source: associated=', associated(p), associated(p, t)
  print '(a,4(1x,i0))', 'rank 2 source: bounds', lbound(p), ubound(p)
  print '(a,6(1x,i0))', 'rank 2 source: values', p
  flush(output_unit)
end program

! CHECK: rank 2 source: rc=0
! CHECK-NEXT: rank 2 source: associated=T T
! CHECK-NEXT: rank 2 source: bounds -1 5 0 7
! CHECK-NEXT: rank 2 source: values 1 2 3 4 5 6
