! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.19 [S1, S2, S8]

program doConcurrentLocality_005
  implicit none
  type :: holder
    integer :: n
  end type holder
  real, save :: w(2) = [1.5, 2.5]
  type(holder) :: h
  integer :: i, n, r(4)

  n = command_argument_count()
  h%n = 7 + n
  do concurrent (i = 1:4) local(w, h)
    w = real(i)
    h%n = i
    r(i) = int(sum(w)) + h%n
  end do
  write(*,'(A,3(I0,1X),I0)') 'r=', r
  write(*,'(A,L1)') 'outer_w_unchanged=', all(w == [1.5, 2.5])
  write(*,'(A,I0)') 'outer_h=', h%n
end program doConcurrentLocality_005

! CHECK: r=3 6 9 12
! CHECK-NEXT: outer_w_unchanged=T
! CHECK-NEXT: outer_h=7
