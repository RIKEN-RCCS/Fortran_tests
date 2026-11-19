! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.26 [S1, S2]

module m_r
  implicit none
contains
  recursive function sumto(n) result(r)
    integer, intent(in) :: n
    integer :: r
    if (n <= 0) then
      r = 0
    else
      r = n + sumto(n - 1)
    end if
  end function sumto
  non_recursive function square(n) result(r)
    integer, intent(in) :: n
    integer :: r
    r = n * n
  end function square
end module m_r

program recursiveByDefault_004
  use m_r
  implicit none
  integer :: n

  n = command_argument_count()
  write(*,'(A,I0)') 'recursive=', sumto(10 + n)
  write(*,'(A,I0)') 'non_recursive=', square(7 + n)
end program recursiveByDefault_004

! CHECK: recursive=55
! CHECK-NEXT: non_recursive=49
