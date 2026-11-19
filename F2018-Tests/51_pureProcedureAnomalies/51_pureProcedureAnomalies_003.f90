! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.25 [S3]

module m_val
  implicit none
contains
  pure function twice_plus_one(n) result(r)
    integer, value :: n
    integer :: r
    n = n * 2
    r = n + 1
  end function twice_plus_one
end module m_val

program pureProcedureAnomalies_003
  use m_val
  implicit none
  integer :: m

  m = 5 + command_argument_count()
  write(*,'(A,I0)') 'result=', twice_plus_one(m)
  write(*,'(A,I0)') 'm_unchanged=', m
end program pureProcedureAnomalies_003

! CHECK: result=11
! CHECK-NEXT: m_unchanged=5
