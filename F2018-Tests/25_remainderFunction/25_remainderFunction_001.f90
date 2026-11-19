! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.8 [S1]


program remainderFunction_001
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a, b

  a = 5.0 + command_argument_count()
  b = 3.0 + command_argument_count()

  write(*,'(A,I0)') 'radix_default_real=', radix(a)
  write(*,'(A,L1)') 'arguments_same_radix=', radix(a) == radix(b)
  write(*,'(A,F0.1)') 'rem(5.0,3.0)=', ieee_rem(a, b)
end program remainderFunction_001
! CHECK: radix_default_real=2
! CHECK-NEXT: arguments_same_radix=T
! CHECK-NEXT: rem(5.0,3.0)=-1.0
