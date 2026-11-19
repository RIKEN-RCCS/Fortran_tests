! RUN: %if flang %{ %cc -c %S/09_lifetimes_001.c -o %t.o && %flang %s %t.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/09_lifetimes_001.c -o %t.o && %gfortran %s %t.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/09_lifetimes_001.c -o %t.o && %nvfortran %s %t.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.9 [S1, S4]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_use_then_free(a) bind(c)
      import :: c_int
      integer(c_int), allocatable, intent(inout) :: a(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), allocatable :: a(:)
  allocate(a(3))
  a = [1, 2, 3]
  call c_use_then_free(a)
  print '(a,l1)', 'allocated(a)=', allocated(a)
end program

! CHECK: CFI_address a= 1 2 3
! CHECK-NEXT: CFI_deallocate rc=0 base_addr_null=1
! CHECK-NEXT: allocated(a)=F
