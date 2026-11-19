! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.4 [S1, S2, S3]


program roundedConversions_001
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real32, real64
  implicit none
  real :: x
  integer :: n

  x = 3.5 + command_argument_count()
  n = 7 + command_argument_count()

  write(*,'(A,L1)') 'kind_from_real_omitted=', kind(ieee_real(x)) == kind(0.0)
  write(*,'(A,L1)') 'kind_from_integer_omitted=', kind(ieee_real(n)) == kind(0.0)
  write(*,'(A,L1)') 'kind_from_real_real32=', kind(ieee_real(x, real32)) == real32
  write(*,'(A,L1)') 'kind_from_real_real64=', kind(ieee_real(x, real64)) == real64
  write(*,'(A,L1)') 'kind_from_integer_real64=', kind(ieee_real(n, real64)) == real64
  write(*,'(A,L1)') 'elemental_applies=', &
       all(ieee_real([n, n+1, n+2]) == [ieee_real(n), ieee_real(n+1), ieee_real(n+2)])
end program roundedConversions_001
! CHECK: kind_from_real_omitted=T
! CHECK-NEXT: kind_from_integer_omitted=T
! CHECK-NEXT: kind_from_real_real32=T
! CHECK-NEXT: kind_from_real_real64=T
! CHECK-NEXT: kind_from_integer_real64=T
! CHECK-NEXT: elemental_applies=T
