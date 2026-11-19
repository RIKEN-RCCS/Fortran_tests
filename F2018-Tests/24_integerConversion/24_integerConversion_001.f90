! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.7 [S1, S2, S3]


program integerConversion_001
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: int32, int64
  implicit none
  real :: a

  a = 2.5 + command_argument_count()

  write(*,'(A,L1)') 'kind_omitted=', kind(ieee_int(a, ieee_nearest)) == kind(0)
  write(*,'(A,L1)') 'kind_int64=', kind(ieee_int(a, ieee_nearest, int64)) == int64
  write(*,'(A,L1)') 'kind_int32=', kind(ieee_int(a, ieee_nearest, int32)) == int32
  write(*,'(A,L1)') 'elemental_applies=', &
       all(ieee_int([a, a + 1.0], ieee_to_zero) == [2, 3])
end program integerConversion_001
! CHECK: kind_omitted=T
! CHECK-NEXT: kind_int64=T
! CHECK-NEXT: kind_int32=T
! CHECK-NEXT: elemental_applies=T
