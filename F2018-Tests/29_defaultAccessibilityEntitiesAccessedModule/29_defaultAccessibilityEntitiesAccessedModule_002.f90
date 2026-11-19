! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.1 [S1, S3]

module m_b
  implicit none
  integer :: x = 1
  integer :: y = 2
end module m_b

module m_a
  use m_b
  implicit none
  private :: m_b
  public :: y
end module m_a

program defaultAccessibility_002
  use m_a
  implicit none
  write(*,'(A,I0)') 'y=', y
end program defaultAccessibility_002

! CHECK: y=2
