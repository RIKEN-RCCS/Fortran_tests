! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.23 [S1, S3]

module m_g
  implicit none
  type :: circle
    real :: r
  end type circle
  generic :: operator(.plus.) => plus_c
  generic :: assignment(=) => assign_c
contains
  type(circle) function plus_c(p, q)
    type(circle), intent(in) :: p, q
    plus_c%r = p%r + q%r
  end function plus_c
  subroutine assign_c(c, k)
    type(circle), intent(out) :: c
    integer, intent(in) :: k
    c%r = real(k)
  end subroutine assign_c
end module m_g

program genericStatement_003
  use m_g
  implicit none
  type(circle) :: c
  real :: x
  x = real(command_argument_count())
  c = circle(1.5 + x) .plus. circle(2.5)
  write(*,'(A,F0.1)') 'plus=', c%r
  c = 3 + command_argument_count()
  write(*,'(A,F0.1)') 'assign=', c%r
end program genericStatement_003

! CHECK: plus=4.0
! CHECK-NEXT: assign=3.0
