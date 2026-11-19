! RUN: %if flang %{ %cc -c %S/07_CFI_functions_006.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_006.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_006.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S22, S24, S26]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_allocate(a) bind(c)
      import :: c_int
      integer(c_int), allocatable, intent(inout) :: a(:)
    end subroutine
    subroutine c_deallocate(a) bind(c)
      import :: c_int
      integer(c_int), allocatable, intent(inout) :: a(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), allocatable :: a(:)

  call c_allocate(a)
  print '(a,l1)', 'allocated=', allocated(a)
  print '(a,i0,1x,i0)', 'bounds=', lbound(a, 1), ubound(a, 1)
  print '(a,4(1x,i0))', 'values', a
  flush(output_unit)

  call c_deallocate(a)
  print '(a,l1)', 'deallocated: allocated=', allocated(a)
  flush(output_unit)

  allocate(a(3))
  a = [7, 8, 9]
  call c_deallocate(a)
  print '(a,l1)', 'Fortran allocate then CFI_deallocate: allocated=', allocated(a)
end program

! CHECK: CFI_allocate rc=0
! CHECK-NEXT: allocated=T
! CHECK-NEXT: bounds=2 5
! CHECK-NEXT: values 10 20 30 40
! CHECK-NEXT: CFI_deallocate rc=0 base_addr_null=1
! CHECK-NEXT: deallocated: allocated=F
! CHECK-NEXT: CFI_deallocate rc=0 base_addr_null=1
! CHECK-NEXT: Fortran allocate then CFI_deallocate: allocated=F
