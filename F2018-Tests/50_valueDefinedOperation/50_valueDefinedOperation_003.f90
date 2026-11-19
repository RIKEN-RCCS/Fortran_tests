! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.24 [S2, S3]

module m_v
  implicit none
  type :: t
    integer :: n
  end type t
  interface assignment(=)
    module procedure assign_t
  end interface
contains
  subroutine assign_t(lhs, rhs)
    type(t), intent(out) :: lhs
    integer, value :: rhs
    rhs = rhs * 10
    lhs%n = rhs
  end subroutine assign_t
end module m_v

program valueDefinedOperation_003
  use m_v
  implicit none
  type(t) :: w
  integer :: k

  k = 2 + command_argument_count()
  w = k
  write(*,'(A,I0)') 'assigned=', w%n
  write(*,'(A,I0)') 'k_unchanged=', k
end program valueDefinedOperation_003

! CHECK: assigned=20
! CHECK-NEXT: k_unchanged=2
