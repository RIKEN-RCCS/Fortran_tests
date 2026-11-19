! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.27 [S1, S2, S3]

program cmplxSimplification_002
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  complex :: z
  complex(dp) :: zd
  integer :: n
  logical :: differ
  complex :: c
  real :: x

  n = command_argument_count()
  z = cmplx(1.5 + n, -2.5 - n)
  zd = cmplx(1.5_dp + n, -2.5_dp - n, dp)
  differ = kind(1.0) /= dp
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    x = 1.0 + n
    c = cmplx(x, dp)
    write(*,'(A,L1)') 'second_is_y=', kind(c) == kind(1.0) .and. aimag(c) == real(dp)
    write(*,'(A,L1)') 'three_args=', cmplx(1.5 + n, -2.5 - n, dp) == zd
  else
    write(*,'(A)') 'second_is_y=UNSUPPORTED'
    write(*,'(A)') 'three_args=UNSUPPORTED'
  end if
end program cmplxSimplification_002

! CHECK: kinds_differ=T
! CHECK-NEXT: second_is_y=T
! CHECK-NEXT: three_args=T
