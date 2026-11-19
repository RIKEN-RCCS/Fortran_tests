! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.4 [S4]


program roundedConversions_002
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real :: x
  integer :: n

  x = 3.5 + command_argument_count()
  n = 7 + command_argument_count()

  write(*,'(A,L1)') 'real_value_preserved=', ieee_real(x) == x
  write(*,'(A,L1)') 'integer_value_preserved=', ieee_real(n) == real(n)
  write(*,'(A,L1)') 'real_to_real64_preserved=', ieee_real(x, real64) == real(x, real64)
end program roundedConversions_002
! CHECK: real_value_preserved=T
! CHECK-NEXT: integer_value_preserved=T
! CHECK-NEXT: real_to_real64_preserved=T
