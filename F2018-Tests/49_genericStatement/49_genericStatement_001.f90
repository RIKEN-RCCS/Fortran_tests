! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.23 [S1, S2, S5]

module m_g
  implicit none
  type :: circle
    real :: r
  end type circle
  type :: square
    real :: a
  end type square
  generic :: area => area_c
  generic :: area => area_s
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

program genericStatement_001
  use m_g
  implicit none
  real :: x
  x = real(command_argument_count())
  write(*,'(A,F0.2)') 'area_circle=', area(circle(1.5 + x))
  write(*,'(A,F0.1)') 'area_square=', area(square(2.0 + x))
end program genericStatement_001

! CHECK: area_circle=2.25
! CHECK-NEXT: area_square=4.0
