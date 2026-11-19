! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S1, S2]


program comparisons_001
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a, b

  a = 1.0 + command_argument_count()
  b = 2.0 + command_argument_count()

  write(*,'(A,L1)') 'quiet_eq(1,2)=', ieee_quiet_eq(a, b)
  write(*,'(A,L1)') 'quiet_ge(1,2)=', ieee_quiet_ge(a, b)
  write(*,'(A,L1)') 'quiet_gt(1,2)=', ieee_quiet_gt(a, b)
  write(*,'(A,L1)') 'quiet_le(1,2)=', ieee_quiet_le(a, b)
  write(*,'(A,L1)') 'quiet_lt(1,2)=', ieee_quiet_lt(a, b)
  write(*,'(A,L1)') 'quiet_ne(1,2)=', ieee_quiet_ne(a, b)
  write(*,'(A,L1)') 'result_kind=', kind(ieee_quiet_eq(a, b)) == kind(.true.)
  write(*,'(A,L1)') 'elemental_applies=', &
       all(ieee_quiet_lt([a, b], [b, a]) .eqv. [ieee_quiet_lt(a, b), ieee_quiet_lt(b, a)])
end program comparisons_001
! CHECK: quiet_eq(1,2)=F
! CHECK-NEXT: quiet_ge(1,2)=F
! CHECK-NEXT: quiet_gt(1,2)=F
! CHECK-NEXT: quiet_le(1,2)=T
! CHECK-NEXT: quiet_lt(1,2)=T
! CHECK-NEXT: quiet_ne(1,2)=T
! CHECK-NEXT: result_kind=T
! CHECK-NEXT: elemental_applies=T
