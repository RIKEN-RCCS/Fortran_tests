! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.27 [S1, S2, S3]

program cmplxSimplification_003
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  complex :: z
  complex(dp) :: zd
  integer :: n
  logical :: differ
  integer :: i

  n = command_argument_count()
  z = cmplx(1.5 + n, -2.5 - n)
  zd = cmplx(1.5_dp + n, -2.5_dp - n, dp)
  differ = kind(1.0) /= dp
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    i = 3 + n
    write(*,'(A,L1)') 'int_second_is_y=', cmplx(i, 4 + n) == (3.0, 4.0)
  else
    write(*,'(A)') 'int_second_is_y=UNSUPPORTED'
  end if
end program cmplxSimplification_003

! CHECK: kinds_differ=T
! CHECK-NEXT: int_second_is_y=T
