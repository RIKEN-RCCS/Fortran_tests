! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.28 [S1, S2, S4]

program dimArgumentRestriction_004
  implicit none
  integer :: a(2, 3)
  logical :: m(2, 3)
  real :: r(2, 3)

  a = reshape([1, 2, 3, 4, 5, 6], [2, 3]) + command_argument_count()
  m = mod(a, 2) == 0
  r = real(a)
  call run(1)
  call run(2)
  call run()

contains
  subroutine run(d)
    integer, optional, intent(in) :: d
    if (present(d)) then
      if (d == 1) then
        write(*,'(A,*(I0,:,1X))') 'present_d1=', sum(a, dim=d)
      else
        write(*,'(A,*(I0,:,1X))') 'present_d2=', sum(a, dim=d)
      end if
    else
      write(*,'(A,*(I0,:,1X))') 'absent=', sum(a)
    end if
  end subroutine
end program dimArgumentRestriction_004

! CHECK: present_d1=3 7 11
! CHECK-NEXT: present_d2=9 12
! CHECK-NEXT: absent=21
