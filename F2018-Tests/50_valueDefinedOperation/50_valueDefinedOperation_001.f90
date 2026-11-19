! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.24 [S1, S3]

module m_v
  implicit none
  type :: t
    integer :: n
  end type t
  interface operator(.neg.)
    module procedure neg_t
  end interface
contains
  function neg_t(a) result(r)
    type(t), value :: a
    type(t) :: r
    a%n = -a%n
    r = a
  end function neg_t
end module m_v

program valueDefinedOperation_001
  use m_v
  implicit none
  type(t) :: x, y
  integer :: n

  n = command_argument_count()
  x = t(5 + n)
  y = .neg. x
  write(*,'(A,I0)') 'neg=', y%n
  write(*,'(A,I0)') 'x_unchanged=', x%n
end program valueDefinedOperation_001

! CHECK: neg=-5
! CHECK-NEXT: x_unchanged=5
