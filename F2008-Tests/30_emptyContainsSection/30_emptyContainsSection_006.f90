! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 Introduction, Table 2.2

! ====================
! A-1 empty contains
! B-6 type
! ====================
module mod6
    implicit none

    type :: t1
        real :: val

    ! Empty contains section
    contains

    end type t1

contains

end module mod6

program main
    use mod6
    implicit none
    type(t1) :: a

    a%val = 5.0

    print "(a, f6.2)", "a =", a
    print *, "Done!"

end program main

! CHECK: a =  5.00
! CHECK-NEXT: Done!