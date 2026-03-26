! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran -std=f2008 %s -o %t && %t | FileCheck %s

! SPEC: F2008 R437,C440

program main
  implicit none

  type :: A
    type(B), allocatable :: bcomp
  end type A

  type :: B
     integer :: data
  end type B

  type(A)    :: a1

  allocate(a1%bcomp)
  a1%bcomp%data = 20

  print *, a1%bcomp%data

end program

! CHECK: 20
