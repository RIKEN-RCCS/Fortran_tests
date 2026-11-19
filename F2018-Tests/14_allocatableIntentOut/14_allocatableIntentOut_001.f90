! RUN: %if flang %{ %cc -c %S/14_allocatableIntentOut_001.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/14_allocatableIntentOut_001.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/14_allocatableIntentOut_001.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.14 [S2]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_take(a) bind(c)
      import :: c_int
      integer(c_int), allocatable, intent(out) :: a(:)
    end subroutine
  end interface
end module

program main
  use m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  integer(c_int), allocatable :: a(:)
  allocate(a(5))
  a = 1
  print '(a,l1)', 'allocated before call=', allocated(a)
  flush(output_unit)
  call c_take(a)
  print '(a,l1)', 'allocated=', allocated(a)
end program

! CHECK: allocated before call=T
! CHECK-NEXT: base_addr_null on entry=1
! CHECK-NEXT: descriptor on entry: attribute_ok=1 rank=1 type_ok=1 version_ok=1
! CHECK-NEXT: allocated=F
