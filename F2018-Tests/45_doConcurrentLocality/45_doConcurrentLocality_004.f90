! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.19 [S1, S2, S3, S5]

program doConcurrentLocality_004
  implicit none
  integer :: i, n, s, t, r(4)

  n = command_argument_count()
  s = 100 + n
  do concurrent (i = 1:4) default(none) local(t) local_init(s) shared(r)
    t = s + i
    r(i) = t
  end do
  write(*,'(A,3(I0,1X),I0)') 'r=', r
end program doConcurrentLocality_004

! CHECK: r=101 102 103 104
