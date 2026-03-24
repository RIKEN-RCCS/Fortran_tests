! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran -std=f2008 %s -o %t && %t | FileCheck %s

! SPEC: F2008 R437,C440

program main
  implicit none

  type :: Node
    integer :: value
    type(Node), allocatable :: next
  end type Node

  type :: A
    type(B), allocatable :: bcomp
  end type A

  type :: B
     integer :: data
  end type B

  type :: X
    type(Y), allocatable :: ycomp
  end type X

  type :: Y
    type(X), allocatable :: xcomp
    integer :: yval
  end type Y

  type(Node) :: n1
  type(A)    :: a1
  type(X)    :: x1

  allocate(n1%next)
  n1%next%value = 10

  allocate(a1%bcomp)
  a1%bcomp%data = 20

  allocate(x1%ycomp)
  x1%ycomp%yval = 30

  allocate(x1%ycomp%xcomp)

  allocate(x1%ycomp%xcomp%ycomp)
  x1%ycomp%xcomp%ycomp%yval = 40

  print *, n1%next%value, a1%bcomp%data, x1%ycomp%yval, x1%ycomp%xcomp%ycomp%yval

end program

! CHECK: 10 20 30 40
