! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S2, S4, S5]


program outOfRange_007
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: dp = kind(1.0d0)
  real(dp) :: h

  h = real(huge(0_ik), dp) + real(command_argument_count(), dp)
  write(*,'(A,L1)') 'keyword_round_true=', out_of_range(round=.true., mold=0_ik, x=h + 0.9_dp)
  write(*,'(A,L1)') 'keyword_no_round=', out_of_range(mold=0_ik, x=h + 0.9_dp)
end program outOfRange_007
! CHECK: keyword_round_true=T
! CHECK-NEXT: keyword_no_round=F
