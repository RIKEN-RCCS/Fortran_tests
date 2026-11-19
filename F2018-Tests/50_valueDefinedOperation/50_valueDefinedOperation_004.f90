! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.24 [S1, S2, S3]

module m_v
  implicit none
  type :: t
    integer :: n
  contains
    procedure :: add_tb
    procedure :: assign_tb
    generic :: operator(.add.) => add_tb
    generic :: assignment(=) => assign_tb
  end type t
contains
  function add_tb(a, b) result(r)
    class(t), intent(in) :: a
    type(t), value :: b
    type(t) :: r
    b%n = b%n + a%n
    r = t(b%n)
  end function add_tb
  subroutine assign_tb(lhs, rhs)
    class(t), intent(out) :: lhs
    integer, value :: rhs
    rhs = rhs * 10
    lhs%n = rhs
  end subroutine assign_tb
end module m_v

program valueDefinedOperation_004
  use m_v
  implicit none
  type(t) :: x, y, z, w
  integer :: n, k

  n = command_argument_count()
  x = t(3 + n)
  y = t(4 + n)
  z = x .add. y
  write(*,'(A,I0)') 'tb_add=', z%n
  write(*,'(A,I0)') 'tb_right_unchanged=', y%n
  k = 2 + n
  w = k
  write(*,'(A,I0)') 'tb_assigned=', w%n
  write(*,'(A,I0)') 'tb_k_unchanged=', k
end program valueDefinedOperation_004

! CHECK: tb_add=7
! CHECK-NEXT: tb_right_unchanged=4
! CHECK-NEXT: tb_assigned=20
! CHECK-NEXT: tb_k_unchanged=2
