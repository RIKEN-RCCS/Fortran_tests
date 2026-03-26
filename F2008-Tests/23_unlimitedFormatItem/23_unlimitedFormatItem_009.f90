! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 R1001, R1002, R1005, C1002

program main
    implicit none
    real rarray(6)
    integer :: i
    real :: x = 123.4567

    do i = 1,6
        rarray(i) = x / i
    enddo

    ! ====================
    ! A-3
    ! B-1
    ! C-2
    ! ====================
     write(*, 100), x, rarray

100 format('x = ', (f10.2), / *(1p f12.4, :, " /"))

end program main

! CHECK: x =     123.46
! CHECK-NEXT: 1234.5670 /    617.2835 /    411.5223 /    308.6418 /    246.9134 /    205.7612