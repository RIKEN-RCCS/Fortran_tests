! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.28 [S4, S5]

program dimArgumentRestriction_005
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
      write(*,'(A,*(I0,:,1X))') 'reduce_d1=', reduce(a, add, d)
    else
      write(*,'(A,*(I0,:,1X))') 'reduce_d2=', reduce(a, add, d)
    end if
  end subroutine
  pure function add(x, y) result(z)
    integer, intent(in) :: x, y
    integer :: z
    z = x + y
  end function
end program dimArgumentRestriction_005

! CHECK: reduce_d1=3 7 11
! CHECK-NEXT: reduce_d2=9 12
