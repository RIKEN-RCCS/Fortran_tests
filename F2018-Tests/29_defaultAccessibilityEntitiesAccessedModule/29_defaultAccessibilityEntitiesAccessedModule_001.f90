! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.1 [S1, S4]

module m_b
  implicit none
  integer :: x = 1
  integer :: y = 2
end module m_b

module m_a
  use m_b
  implicit none
  private
  public :: m_b
  integer :: w = 3
end module m_a

program defaultAccessibility_001
  use m_a
  implicit none
  write(*,'(A,I0)') 'x=', x
  write(*,'(A,I0)') 'y=', y
end program defaultAccessibility_001

! CHECK: x=1
! CHECK-NEXT: y=2
