! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.8 [S1]


program remainderFunction_002
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real :: a
  real(real64) :: b

  a = 5.0 + command_argument_count()
  b = 3.0_real64 + command_argument_count()

  write(*,'(A,I0)') 'radix_real64=', radix(b)
  write(*,'(A,L1)') 'mixed_kind_same_radix=', radix(a) == radix(b)
  write(*,'(A,L1)') 'mixed_kind_rem_eq_minus1=', ieee_rem(a, b) == -1.0_real64
end program remainderFunction_002
! CHECK: radix_real64=2
! CHECK-NEXT: mixed_kind_same_radix=T
! CHECK-NEXT: mixed_kind_rem_eq_minus1=T
