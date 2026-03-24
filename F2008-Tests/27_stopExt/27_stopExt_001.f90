! RUN: %flang %s -o %t && not %t 2>&1 | FileCheck %s
! RUN: %gfortran %s -o %t && not %t 2>&1 | FileCheck %s

! SPEC: F2008 R855,R857

! ====================
! A-1 stop
! B-1 integer
! C-1 scala
! D-1 constant
! E-1 default
! ====================

program main
  implicit none
  integer, parameter :: val = 5
  integer :: i, r

  do i = 1, 10
    r = i * i
    if (r == 25) then
      stop val
    end if
  end do

end program

! CHECK: STOP
! CHECKP-SAME: 5
