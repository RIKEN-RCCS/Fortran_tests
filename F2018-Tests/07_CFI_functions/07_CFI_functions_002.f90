! RUN: %if flang %{ %cc -c %S/07_CFI_functions_002.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_002.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_002.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S8]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_establish_null() bind(c)
    end subroutine
  end interface
contains
  subroutine f_alloc(a) bind(c)
    integer(c_int), allocatable, intent(inout) :: a(:)
    print '(a,l1)', 'allocated=', allocated(a)
    flush(output_unit)
  end subroutine
  subroutine f_ptr(p) bind(c)
    integer(c_int), pointer, intent(inout) :: p(:)
    print '(a,l1)', 'associated=', associated(p)
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  call c_establish_null()
end program

! CHECK: allocatable rc=0 base_addr_null=1 attribute_ok=1
! CHECK-NEXT: allocated=F
! CHECK-NEXT: pointer rc=0 base_addr_null=1 attribute_ok=1
! CHECK-NEXT: associated=F
