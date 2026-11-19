! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S4, S5]

module m
  implicit none
contains
  subroutine inspect(tag, x)
    character(*), intent(in) :: tag
    type(*), intent(in) :: x(*)
    print '(2a,l1)', tag, ' is_contiguous=', is_contiguous(x)
    print '(2a,*(i0,:,","))', tag, ' lbound=', lbound(x)
  end subroutine
end module

program main
  use m
  use, intrinsic :: iso_c_binding, only: c_double
  implicit none
  real(c_double) :: a(6) = 0.0_c_double
  call inspect('contig', a(1:3))
  call inspect('strided', a(1:6:2))
end program

! CHECK: contig is_contiguous=T
! CHECK-NEXT: contig lbound=1
! CHECK-NEXT: strided is_contiguous=T
! CHECK-NEXT: strided lbound=1
