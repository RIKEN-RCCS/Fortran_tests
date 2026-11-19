! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.19 [S1, S2]

program doConcurrentLocality_002
  implicit none
  integer :: i, n, s, r(4)

  n = command_argument_count()
  s = 10 + n
  do concurrent (i = 1:4) local_init(s)
    s = s + i
    r(i) = s
  end do
  write(*,'(A,3(I0,1X),I0)') 'r=', r
  write(*,'(A,I0)') 'outer_s=', s
end program doConcurrentLocality_002

! CHECK: r=11 12 13 14
! CHECK-NEXT: outer_s=10
