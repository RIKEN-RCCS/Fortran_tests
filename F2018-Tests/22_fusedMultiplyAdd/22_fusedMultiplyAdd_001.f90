! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.5 [S1, S2]


program fusedMultiplyAdd_001
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real :: a, b, c
  real(real64) :: a64, b64, c64

  a = 3.0 + command_argument_count()
  b = 5.0 + command_argument_count()
  c = 7.0 + command_argument_count()
  a64 = 3.0_real64 + command_argument_count()
  b64 = 5.0_real64 + command_argument_count()
  c64 = 7.0_real64 + command_argument_count()

  write(*,'(A,F0.1)') 'fma(3,5,7)=', ieee_fma(a, b, c)
  write(*,'(A,L1)') 'kind_default=', kind(ieee_fma(a, b, c)) == kind(0.0)
  write(*,'(A,L1)') 'kind_real64=', kind(ieee_fma(a64, b64, c64)) == real64
  write(*,'(A,L1)') 'elemental_applies=', all(ieee_fma([a, b], [b, c], [c, a]) == [22.0, 38.0])
end program fusedMultiplyAdd_001
! CHECK: fma(3,5,7)=22.0
! CHECK-NEXT: kind_default=T
! CHECK-NEXT: kind_real64=T
! CHECK-NEXT: elemental_applies=T
