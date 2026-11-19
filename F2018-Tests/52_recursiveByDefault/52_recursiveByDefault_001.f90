! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.26 [S1]

module m_r
  implicit none
contains
  function fact(n) result(r)
    integer, intent(in) :: n
    integer :: r
    integer :: k
    k = n
    if (n > 1) then
      r = fact(n - 1)
      r = r * k
    else
      r = 1
    end if
  end function fact
end module m_r

program recursiveByDefault_001
  use m_r
  implicit none
  integer :: n

  n = 5 + command_argument_count()
  write(*,'(A,I0)') 'fact5=', fact(n)
end program recursiveByDefault_001

! CHECK: fact5=120
