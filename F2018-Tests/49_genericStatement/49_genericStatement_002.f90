! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.23 [S1, S6]

module m_g
  implicit none
  private
  public :: circle
  type :: circle
    real :: r
  end type circle
  generic, public :: perim => perim_c
contains
  real function perim_c(c)
    type(circle), intent(in) :: c
    perim_c = 2 * c%r
  end function perim_c
end module m_g

program genericStatement_002
  use m_g
  implicit none
  real :: x
  x = real(command_argument_count())
  write(*,'(A,F0.1)') 'perim_circle=', perim(circle(1.5 + x))
end program genericStatement_002

! CHECK: perim_circle=3.0
