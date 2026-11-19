! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S2, S4]

module m
  implicit none
contains
  subroutine inspect(tag, x, y)
    character(*), intent(in) :: tag
    type(*), intent(in) :: x
    type(*), intent(in), optional :: y
    print '(2a,i0)', tag, ' rank=', rank(x)
    print '(2a,l1)', tag, ' present y=', present(y)
    print '(2a,i0)', tag, ' shape size=', size(shape(x))
  end subroutine
end module

program main
  use m
  use, intrinsic :: iso_c_binding, only: c_int
  implicit none
  integer(c_int) :: i = 1_c_int
  call inspect('absent', i)
  call inspect('given', i, i)
end program

! CHECK: absent rank=0
! CHECK-NEXT: absent present y=F
! CHECK-NEXT: absent shape size=0
! CHECK-NEXT: given rank=0
! CHECK-NEXT: given present y=T
! CHECK-NEXT: given shape size=0
