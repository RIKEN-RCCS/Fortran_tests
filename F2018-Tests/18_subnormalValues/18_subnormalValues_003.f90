! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.1 [S3]


program subnormalValues_003
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x
  real :: a(2)

  x = 1.0 + command_argument_count()
  a = [x, -x]

  write(*,'(A,L1)') 'support_noarg_eq_denormal=', &
       ieee_support_subnormal() .eqv. ieee_support_denormal()
  write(*,'(A,L1)') 'support_scalar_eq_denormal=', &
       ieee_support_subnormal(x) .eqv. ieee_support_denormal(x)
  write(*,'(A,L1)') 'support_array_eq_denormal=', &
       ieee_support_subnormal(a) .eqv. ieee_support_denormal(a)
end program subnormalValues_003
! CHECK: support_noarg_eq_denormal=T
! CHECK-NEXT: support_scalar_eq_denormal=T
! CHECK-NEXT: support_array_eq_denormal=T
