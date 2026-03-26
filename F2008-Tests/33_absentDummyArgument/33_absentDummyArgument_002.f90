! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 Introduction, 12.5.2.12, C544

subroutine sub1(x, y, z, sum)
  implicit none
  integer, intent(in) :: x, y
  integer, optional, allocatable, intent(in) :: z(:)
  integer, intent(out) :: sum

  print *, 'present(z) = ', present(z)
  if (.not. present(z)) then
    sum = x + y
  else 
    sum = x + y + z(1)
  end if
end subroutine sub1

program main
  implicit none

  interface
    subroutine sub1(x, y, z, sum)
      integer, intent(in) :: x, y
      integer, optional, allocatable, intent(in) :: z(:)
      integer, intent(out) :: sum
    end subroutine sub1
  end interface

  integer :: a, b, res
  integer, allocatable :: c(:)

  a = 10
  b = 5

  ! ====================
  ! A-1 subroutine
  ! B-1 optional
  ! C-2 allocatable
  ! D-2 allocated
  ! ====================
  allocate(c(5))
  c = 30
  call sub1(a, b, c, res)
  print *, "sum 1:", res

end program main

! CHECK: present(z) = T
! CHECK-NEXT: sum 1: 45
