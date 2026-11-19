! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.28 [S1, S2, S4]

program dimArgumentRestriction_001
  implicit none
  integer :: a(2, 3)
  logical :: m(2, 3)
  real :: r(2, 3)

  a = reshape([1, 2, 3, 4, 5, 6], [2, 3]) + command_argument_count()
  m = mod(a, 2) == 0
  r = real(a)
  call run(1)
  call run(2)

contains
  subroutine run(d)
    integer, optional, intent(in) :: d
    if (d == 1) then
      write(*,'(A,*(L1,:,1X))') 'all_d1=', all(m, d)
      write(*,'(A,*(L1,:,1X))') 'any_d1=', any(m, d)
      write(*,'(A,*(L1,:,1X))') 'parity_d1=', parity(m, d)
    else
      write(*,'(A,*(L1,:,1X))') 'all_d2=', all(m, d)
      write(*,'(A,*(L1,:,1X))') 'any_d2=', any(m, d)
      write(*,'(A,*(L1,:,1X))') 'parity_d2=', parity(m, d)
    end if
  end subroutine
end program dimArgumentRestriction_001

! CHECK: all_d1=F F F
! CHECK-NEXT: any_d1=T T T
! CHECK-NEXT: parity_d1=T T T
! CHECK-NEXT: all_d2=F T
! CHECK-NEXT: any_d2=F T
! CHECK-NEXT: parity_d2=F T
