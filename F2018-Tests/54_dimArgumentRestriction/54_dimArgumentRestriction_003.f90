! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.28 [S1, S2, S4]

program dimArgumentRestriction_003
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
      write(*,'(A,*(I0,:,1X))') 'maxloc_d1=', maxloc(a, dim=d)
      write(*,'(A,*(I0,:,1X))') 'minloc_d1=', minloc(a, dim=d)
      write(*,'(A,*(I0,:,1X))') 'findloc_d1=', findloc(a, 4, dim=d)
    else
      write(*,'(A,*(I0,:,1X))') 'maxloc_d2=', maxloc(a, dim=d)
      write(*,'(A,*(I0,:,1X))') 'findloc_d2=', findloc(a, 4, dim=d)
    end if
  end subroutine
end program dimArgumentRestriction_003

! CHECK: maxloc_d1=2 2 2
! CHECK-NEXT: minloc_d1=1 1 1
! CHECK-NEXT: findloc_d1=0 2 0
! CHECK-NEXT: maxloc_d2=3 3
! CHECK-NEXT: findloc_d2=0 2
