! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.25 [S1]

module m_pure
  implicit none
contains
  pure function safe_sqrt(x) result(r)
    real, intent(in) :: x
    real :: r
    if (x < 0.0) error stop 'negative argument'
    r = sqrt(x)
  end function safe_sqrt

  pure subroutine check(n)
    integer, intent(in) :: n
    if (n < 0) error stop 'negative count'
  end subroutine check

  elemental function half(n) result(r)
    integer, intent(in) :: n
    integer :: r
    if (n < 0) error stop 'negative element'
    r = n / 2
  end function half
end module m_pure

program pureProcedureAnomalies_001
  use m_pure
  implicit none
  integer :: n

  n = command_argument_count()
  write(*,'(A,L1)') 'pure_function=', safe_sqrt(4.0 + n) == 2.0
  call check(3 + n)
  write(*,'(A)') 'pure_subroutine=ok'
  write(*,'(A,3(1X,I0))') 'elemental=', half([2, 4, 6] + n)
end program pureProcedureAnomalies_001

! CHECK: pure_function=T
! CHECK-NEXT: pure_subroutine=ok
! CHECK-NEXT: elemental= 1 2 3
