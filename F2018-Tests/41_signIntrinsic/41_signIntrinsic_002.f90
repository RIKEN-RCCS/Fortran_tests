! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.15 [S1, S2]

program signIntrinsic_002
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  real :: x
  real(dp) :: y
  integer :: n
  logical :: differ

  n = command_argument_count()
  differ = kind(1.0) /= kind(1.0_dp)
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    x = 2.0 + n
    y = -1.0_dp - n
    write(*,'(A,L1)') 'sign(2.0,-1.0_dp)_is_-2=', sign(x, y) == -2.0
    write(*,'(A,L1)') 'kind_is_a(default)=', kind(sign(2.0, -1.0_dp)) == kind(1.0)
    y = 2.0_dp + n
    x = -3.0 - n
    write(*,'(A,L1)') 'sign(2.0_dp,-3.0)_is_-2=', sign(y, x) == -2.0_dp
    write(*,'(A,L1)') 'kind_is_a(dp)=', kind(sign(2.0_dp, -3.0)) == dp
    y = -2.0_dp - n
    x = 3.0 + n
    write(*,'(A,L1)') 'sign(-2.0_dp,3.0)_is_2=', sign(y, x) == 2.0_dp
    x = 2.0 + n
    write(*,'(A,L1)') 'sign(2.0,-1.0)_is_-2=', sign(x, -1.0 - n) == -2.0
  else
    write(*,'(A)') 'sign(2.0,-1.0_dp)_is_-2=UNSUPPORTED'
    write(*,'(A)') 'kind_is_a(default)=UNSUPPORTED'
    write(*,'(A)') 'sign(2.0_dp,-3.0)_is_-2=UNSUPPORTED'
    write(*,'(A)') 'kind_is_a(dp)=UNSUPPORTED'
    write(*,'(A)') 'sign(-2.0_dp,3.0)_is_2=UNSUPPORTED'
    write(*,'(A)') 'sign(2.0,-1.0)_is_-2=UNSUPPORTED'
  end if
end program signIntrinsic_002

! CHECK: kinds_differ=T
! CHECK-NEXT: sign(2.0,-1.0_dp)_is_-2=T
! CHECK-NEXT: kind_is_a(default)=T
! CHECK-NEXT: sign(2.0_dp,-3.0)_is_-2=T
! CHECK-NEXT: kind_is_a(dp)=T
! CHECK-NEXT: sign(-2.0_dp,3.0)_is_2=T
! CHECK-NEXT: sign(2.0,-1.0)_is_-2=T
