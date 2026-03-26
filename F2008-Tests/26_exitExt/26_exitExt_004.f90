! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 R850

! ====================
! A-3 select case
! B-1 self construct
! C-1 with construct-name
! ====================

program main
  implicit none
  integer,parameter :: i = 1
  integer :: st = 0

  outer: select case(i)
  case (1)
    st = 1
    exit outer
    st = -1
  case default
    st = 0
  end select outer

  write(*,*)  "st =",st

end program

! CHECK: st = 1
