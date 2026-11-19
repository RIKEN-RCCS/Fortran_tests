! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S3, S4, S5]

module m
  implicit none
contains
  subroutine inspect(tag, x, y)
    character(*), intent(in) :: tag
    type(*), intent(in) :: x(..)
    type(*), intent(in), optional :: y(..)
    print '(2a,i0)', tag, ' rank=', rank(x)
    print '(2a,l1)', tag, ' present y=', present(y)
    print '(2a,*(i0,:,","))', tag, ' lbound=', lbound(x)
    print '(2a,*(i0,:,","))', tag, ' ubound=', ubound(x)
    print '(2a,*(i0,:,","))', tag, ' shape=', shape(x)
    print '(2a,i0)', tag, ' size=', size(x)
    print '(2a,l1)', tag, ' is_contiguous=', is_contiguous(x)
  end subroutine
end module

program main
  use m
  use, intrinsic :: iso_c_binding, only: c_int
  implicit none
  integer(c_int) :: w(2,3) = 0_c_int
  call inspect('contig', w)
  call inspect('strided', w(:,1:3:2), w(:,1))
end program

! CHECK: contig rank=2
! CHECK-NEXT: contig present y=F
! CHECK-NEXT: contig lbound=1,1
! CHECK-NEXT: contig ubound=2,3
! CHECK-NEXT: contig shape=2,3
! CHECK-NEXT: contig size=6
! CHECK-NEXT: contig is_contiguous=T
! CHECK-NEXT: strided rank=2
! CHECK-NEXT: strided present y=T
! CHECK-NEXT: strided lbound=1,1
! CHECK-NEXT: strided ubound=2,2
! CHECK-NEXT: strided shape=2,2
! CHECK-NEXT: strided size=4
! CHECK-NEXT: strided is_contiguous={{[TF]}}
