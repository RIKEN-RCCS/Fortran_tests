! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.1 [S1, S2]


program subnormalValues_001
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_features, only: ieee_subnormal
  implicit none

  write(*,'(A,L1)') 'negative_subnormal_eq_denormal=', &
       ieee_negative_subnormal == ieee_negative_denormal
  write(*,'(A,L1)') 'positive_subnormal_eq_denormal=', &
       ieee_positive_subnormal == ieee_positive_denormal
  write(*,'(A,L1)') 'ieee_subnormal_referenced=', .true.
end program subnormalValues_001
! CHECK: negative_subnormal_eq_denormal=T
! CHECK-NEXT: positive_subnormal_eq_denormal=T
! CHECK-NEXT: ieee_subnormal_referenced=T
