! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 Introduction, Table 2.2

! ====================
! A-1 empty contains
! B-2 module
! ====================
module mod2
    implicit none
    integer :: x = 42

! Empty contains section
contains

end module mod2

program main
    use mod2
    implicit none

    print *, "x =", x
    print *, "Empty contains test done!"

end program main

! CHECK: x = 42
! CHECK-NEXT: Empty contains test done!