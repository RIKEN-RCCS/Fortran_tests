! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S3, S4]


program comparisons_002
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a, b

  a = 1.0 + command_argument_count()
  b = 2.0 + command_argument_count()

  write(*,'(A,L1)') 'signaling_eq(1,2)=', ieee_signaling_eq(a, b)
  write(*,'(A,L1)') 'signaling_ge(1,2)=', ieee_signaling_ge(a, b)
  write(*,'(A,L1)') 'signaling_gt(1,2)=', ieee_signaling_gt(a, b)
  write(*,'(A,L1)') 'signaling_le(1,2)=', ieee_signaling_le(a, b)
  write(*,'(A,L1)') 'signaling_lt(1,2)=', ieee_signaling_lt(a, b)
  write(*,'(A,L1)') 'signaling_ne(1,2)=', ieee_signaling_ne(a, b)
  write(*,'(A,L1)') 'result_kind=', kind(ieee_signaling_eq(a, b)) == kind(.true.)
end program comparisons_002
! CHECK: signaling_eq(1,2)=F
! CHECK-NEXT: signaling_ge(1,2)=F
! CHECK-NEXT: signaling_gt(1,2)=F
! CHECK-NEXT: signaling_le(1,2)=T
! CHECK-NEXT: signaling_lt(1,2)=T
! CHECK-NEXT: signaling_ne(1,2)=T
! CHECK-NEXT: result_kind=T
