! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 R1001, R1002, R1005, C1002

program main
    implicit none
    real rarray(6)
    integer :: i
    real :: x = 123.4567

    do i = 1,6
        rarray(i) = x * i
    enddo

    ! ====================
    ! A-3
    ! B-1
    ! C-2
    ! ====================
     write(*, 100), x, rarray

100 format('x =', (f10.2), /, 'rarray = ', *(1p f12.4, :, " /"))

end program main

! CHECK:  x =    123.46
! CHECK-NEXT: rarray =    1234.5670 /   2469.1341 /   3703.7012 /   4938.2681 /   6172.8351 /   7407.4023