! RUN: %if flang %{ %cc -c %S/07_CFI_functions_003.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_003.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_003.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S5, S16]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_establish_pointer() bind(c)
    end subroutine
  end interface
contains
  subroutine f_ptr(p) bind(c)
    integer(c_int), pointer, intent(inout) :: p(:)
    print '(a,l1)', 'associated=', associated(p)
    print '(a,i0,1x,i0)', 'bounds=', lbound(p, 1), ubound(p, 1)
    print '(a,4(1x,i0))', 'values', p
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  call c_establish_pointer()
end program

! CHECK: CFI_establish rc=0 lower_bound=0 extent=4
! CHECK-NEXT: associated=T
! CHECK-NEXT: bounds=0 3
! CHECK-NEXT: values 11 12 13 14
