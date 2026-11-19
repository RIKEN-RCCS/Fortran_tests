! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.26 [S1]

module m_r
  implicit none
contains
  subroutine ping(n, acc)
    integer, intent(in) :: n
    integer, intent(inout) :: acc
    if (n <= 0) return
    acc = acc + n
    call pong(n - 1, acc)
  end subroutine ping
  subroutine pong(n, acc)
    integer, intent(in) :: n
    integer, intent(inout) :: acc
    if (n <= 0) return
    acc = acc + n
    call ping(n - 1, acc)
  end subroutine pong
end module m_r

program recursiveByDefault_002
  use m_r
  implicit none
  integer :: acc, n

  n = 5 + command_argument_count()
  acc = 0
  call ping(n, acc)
  write(*,'(A,I0)') 'ping_pong=', acc
end program recursiveByDefault_002

! CHECK: ping_pong=15
