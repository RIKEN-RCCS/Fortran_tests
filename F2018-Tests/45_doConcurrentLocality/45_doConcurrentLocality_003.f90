! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.19 [S1, S3, S4]

program doConcurrentLocality_003
  implicit none
  integer :: i, n, c(4), d(4)

  n = command_argument_count()
  do concurrent (i = 1:4) shared(c)
    c(i) = i * 3 + n
  end do
  do concurrent (i = 1:4)
    d(i) = i * 3 + n
  end do
  write(*,'(A,3(I0,1X),I0)') 'shared=', c
  write(*,'(A,3(I0,1X),I0)') 'unspecified=', d
end program doConcurrentLocality_003

! CHECK: shared=3 6 9 12
! CHECK-NEXT: unspecified=3 6 9 12
