! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.28 [S1, S2, S4, S5]

program dimArgumentRestriction_002
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
      write(*,'(A,*(I0,:,1X))') 'sum_d1=', sum(a, d)
      write(*,'(A,*(I0,:,1X))') 'product_d1=', product(a, d)
      write(*,'(A,*(I0,:,1X))') 'maxval_d1=', maxval(a, d)
      write(*,'(A,*(I0,:,1X))') 'iall_d1=', iall(a, d)
      write(*,'(A,*(I0,:,1X))') 'iany_d1=', iany(a, d)
      write(*,'(A,*(I0,:,1X))') 'iparity_d1=', iparity(a, d)
      write(*,'(A,L1)') 'norm2_d1_ok=', all(abs(norm2(r, d) - sqrt(sum(r**2, 1))) <= 4 * epsilon(1.0) * sqrt(sum(r**2, 1)))
    else
      write(*,'(A,*(I0,:,1X))') 'sum_d2=', sum(a, d)
      write(*,'(A,*(I0,:,1X))') 'product_d2=', product(a, d)
      write(*,'(A,*(I0,:,1X))') 'minval_d2=', minval(a, d)
      write(*,'(A,L1)') 'norm2_d2_ok=', all(abs(norm2(r, d) - sqrt(sum(r**2, 2))) <= 4 * epsilon(1.0) * sqrt(sum(r**2, 2)))
    end if
  end subroutine
end program dimArgumentRestriction_002

! CHECK: sum_d1=3 7 11
! CHECK-NEXT: product_d1=2 12 30
! CHECK-NEXT: maxval_d1=2 4 6
! CHECK-NEXT: iall_d1=0 0 4
! CHECK-NEXT: iany_d1=3 7 7
! CHECK-NEXT: iparity_d1=3 7 3
! CHECK-NEXT: norm2_d1_ok=T
! CHECK-NEXT: sum_d2=9 12
! CHECK-NEXT: product_d2=15 48
! CHECK-NEXT: minval_d2=1 2
! CHECK-NEXT: norm2_d2_ok=T
