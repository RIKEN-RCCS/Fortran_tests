! RUN: %if flang %{ %cc -c %S/07_CFI_functions_012.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_012.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_012.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S36, S38]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_address_alloc(a) bind(c)
      import :: c_int
      integer(c_int), allocatable, intent(in) :: a(:,:)
    end subroutine
    subroutine c_address_other(b) bind(c)
      import :: c_int
      integer(c_int), intent(in) :: b(:)
    end subroutine
    subroutine c_address_scalar(x) bind(c)
      import :: c_int
      integer(c_int), allocatable, intent(in) :: x
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), allocatable :: a(:,:), x
  integer(c_int) :: b(4) = [5, 6, 7, 8]
  allocate(a(2:4, 0:1))
  a = reshape([21, 31, 41, 20, 30, 40], [3, 2])
  allocate(x)
  x = 99
  call c_address_alloc(a)
  call c_address_other(b)
  call c_address_scalar(x)
end program

! CHECK: allocatable lower_bounds=2 0
! CHECK-NEXT: a(2,0)=21 a(4,0)=41 a(3,1)=30
! CHECK-NEXT: other lower_bound=0
! CHECK-NEXT: b(0)=5 b(3)=8
! CHECK-NEXT: scalar NULL subscripts=99
