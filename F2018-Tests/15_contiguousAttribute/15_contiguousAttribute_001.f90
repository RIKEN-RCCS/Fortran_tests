! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.15 [S1]

module m
  implicit none
contains
  subroutine req(label, a)
    character(*), intent(in) :: label
    integer, contiguous, intent(in) :: a(..)
    print '(a,a,l1)', label, ' is_contiguous=', is_contiguous(a)
    print '(a,a,i0)', label, ' rank=', rank(a)
    print '(a,a,i0)', label, ' size=', size(a)
  end subroutine
end module

program main
  use m
  implicit none
  integer :: v(4) = [1, 2, 3, 4]
  call req('whole', v)
  call req('section', v(1:3))
end program

! CHECK: whole is_contiguous=T
! CHECK-NEXT: whole rank=1
! CHECK-NEXT: whole size=4
! CHECK-NEXT: section is_contiguous=T
! CHECK-NEXT: section rank=1
! CHECK-NEXT: section size=3
