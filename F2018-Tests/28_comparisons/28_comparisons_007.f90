! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S1, S3]


program comparisons_007
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a, b

  a = 2.0 + command_argument_count()
  b = 2.0 + command_argument_count()
  write(*,'(A,6L2)') 'quiet(2,2) eq ge gt le lt ne=', &
       ieee_quiet_eq(a, b), ieee_quiet_ge(a, b), ieee_quiet_gt(a, b), &
       ieee_quiet_le(a, b), ieee_quiet_lt(a, b), ieee_quiet_ne(a, b)
  write(*,'(A,6L2)') 'signaling(2,2) eq ge gt le lt ne=', &
       ieee_signaling_eq(a, b), ieee_signaling_ge(a, b), ieee_signaling_gt(a, b), &
       ieee_signaling_le(a, b), ieee_signaling_lt(a, b), ieee_signaling_ne(a, b)
end program comparisons_007
! CHECK: quiet(2,2) eq ge gt le lt ne= T T F T F F
! CHECK-NEXT: signaling(2,2) eq ge gt le lt ne= T T F T F F
