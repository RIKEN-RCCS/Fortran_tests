! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.1 [S1, S5]

module m_b
  implicit none
  integer :: x = 1
  integer :: y = 2
end module m_b

module m_a
  use m_b, z => x
  implicit none
  private :: m_b
  integer :: v = 4
end module m_a

program defaultAccessibility_003
  use m_a
  implicit none
  write(*,'(A,I0)') 'v=', v
end program defaultAccessibility_003

! CHECK: v=4
