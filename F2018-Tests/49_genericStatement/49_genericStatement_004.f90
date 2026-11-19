! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.23 [S4]

module m_g
  implicit none
  type :: circle
    real :: r
  end type circle
  type :: square
    real :: a
  end type square
contains
  real function area_c(c)
    type(circle), intent(in) :: c
    area_c = c%r**2
  end function area_c
  real function area_s(s)
    type(square), intent(in) :: s
    area_s = s%a**2
  end function area_s
end module m_g

program genericStatement_004
  use m_g
  implicit none
  generic :: myarea => area_c, area_s
  real :: x
  x = real(command_argument_count())
  write(*,'(A,F0.2,1X,F0.1)') 'main_generic=', myarea(circle(1.5 + x)), myarea(square(2.0 + x))
end program genericStatement_004

! CHECK: main_generic=2.25 4.0
