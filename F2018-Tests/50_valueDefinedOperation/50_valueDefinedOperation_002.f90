! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.24 [S1, S3]

module m_v
  implicit none
  type :: t
    integer :: n
  end type t
  interface operator(.add.)
    module procedure add_t
  end interface
contains
  function add_t(a, b) result(r)
    type(t), value :: a
    type(t), intent(in) :: b
    type(t) :: r
    a%n = a%n + b%n
    r = a
  end function add_t
end module m_v

program valueDefinedOperation_002
  use m_v
  implicit none
  type(t) :: x, y, z
  integer :: n

  n = command_argument_count()
  x = t(3 + n)
  y = t(4 + n)
  z = x .add. y
  write(*,'(A,I0)') 'add=', z%n
  write(*,'(A,I0)') 'left_unchanged=', x%n
end program valueDefinedOperation_002

! CHECK: add=7
! CHECK-NEXT: left_unchanged=3
