! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.26 [S1, S3]

module m_r
  implicit none
contains
  elemental function fib(n) result(r)
    integer, intent(in) :: n
    integer :: r
    if (n <= 2) then
      r = 1
    else
      r = fib(n - 1) + fib(n - 2)
    end if
  end function fib
end module m_r

program recursiveByDefault_003
  use m_r
  implicit none
  integer :: v(6), i

  v = [(i + command_argument_count(), i = 1, 6)]
  write(*,'(A,*(I0,:,1X))') 'fib=', fib(v)
end program recursiveByDefault_003

! CHECK: fib=1 1 2 3 5 8
