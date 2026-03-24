! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 12.7 / 12.8.1

program main
  implicit none
  real :: arr(3)
  real, save :: seed = 12345.0
  integer :: i

  call random(arr)

  write(*,'(A,3F6.2)') "arr =", arr

contains
  impure elemental subroutine random(x)
    real, intent(out) :: x
    seed = mod(seed*3 + 1.0, 100.0)
    x = seed / 100.0
    write(*,'(A,F6.2)') "seed =", seed 
  end subroutine

end program

! CHECK: seed = 36.00
! CHECK-NEXT: seed =  9.00
! CHECK-NEXT: seed = 28.00
! CHECK-NEXT: arr =  0.36  0.09  0.28
