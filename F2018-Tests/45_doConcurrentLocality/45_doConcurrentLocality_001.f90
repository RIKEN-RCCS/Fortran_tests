! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.19 [S1, S2]

program doConcurrentLocality_001
  implicit none
  integer :: i, n, t, r(4)

  n = command_argument_count()
  t = 99 + n
  do concurrent (i = 1:4) local(t)
    t = i * 2
    r(i) = t
  end do
  write(*,'(A,3(I0,1X),I0)') 'r=', r
  write(*,'(A,I0)') 'outer_t=', t
end program doConcurrentLocality_001

! CHECK: r=2 4 6 8
! CHECK-NEXT: outer_t=99
