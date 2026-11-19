! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S3, S4, S5]

module m
  implicit none
contains
  subroutine inspect(tag, x, y)
    character(*), intent(in) :: tag
    type(*), intent(in) :: x(:)
    type(*), intent(in), optional :: y(:)
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
  use, intrinsic :: iso_c_binding, only: c_double
  implicit none
  real(c_double) :: a(6) = 0.0_c_double
  call inspect('contig', a(1:3))
  call inspect('strided', a(1:6:2), a(1:2))
end program

! CHECK: contig rank=1
! CHECK-NEXT: contig present y=F
! CHECK-NEXT: contig lbound=1
! CHECK-NEXT: contig ubound=3
! CHECK-NEXT: contig shape=3
! CHECK-NEXT: contig size=3
! CHECK-NEXT: contig is_contiguous=T
! CHECK-NEXT: strided rank=1
! CHECK-NEXT: strided present y=T
! CHECK-NEXT: strided lbound=1
! CHECK-NEXT: strided ubound=3
! CHECK-NEXT: strided shape=3
! CHECK-NEXT: strided size=3
! CHECK-NEXT: strided is_contiguous={{[TF]}}
