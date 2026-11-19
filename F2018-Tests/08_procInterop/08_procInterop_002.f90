! RUN: %if flang %{ %cc -c %S/08_procInterop_002.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/08_procInterop_002.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/08_procInterop_002.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.8 [S2]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_show_shape(a) bind(c)
      import :: c_double
      real(c_double), intent(in) :: a(:,:)
    end subroutine
    subroutine c_show_rank(a) bind(c)
      import :: c_double
      real(c_double), intent(in) :: a(..)
    end subroutine
    subroutine c_show_alloc(a, id) bind(c)
      import :: c_int
      integer(c_int), allocatable, intent(in) :: a(:)
      integer(c_int), value :: id
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  real(c_double) :: a(2:3, 4) = reshape([1, 2, 3, 4, 5, 6, 7, 8], [2, 4])
  integer(c_int), allocatable :: b(:)
  call c_show_shape(a)
  call c_show_rank(a)
  call c_show_alloc(b, 0)
  allocate(b(2:4))
  b = [20, 30, 40]
  call c_show_alloc(b, 1)
end program

! CHECK: assumed_shape attribute_ok=1 type_ok=1 rank=2
! CHECK-NEXT: assumed_shape lower_bounds=0 0 extents=2 4 values 1 2 3 4 5 6 7 8
! CHECK-NEXT: assumed_rank attribute_ok=1 type_ok=1 rank=2
! CHECK-NEXT: assumed_rank lower_bounds=0 0 extents=2 4
! CHECK-NEXT: allocatable_unallocated attribute_ok=1 base_addr_null=1
! CHECK-NEXT: allocatable_allocated attribute_ok=1 base_addr_null=0 lower_bound=2 extent=3 values 20 30 40
