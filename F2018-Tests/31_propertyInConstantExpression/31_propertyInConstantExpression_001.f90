! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.3 [S1]

program propertyInConstantExpression_001
  implicit none
  integer, parameter :: dp = selected_real_kind(15)
  integer :: nd = digits(nd)
  real(dp), parameter :: tol = sqrt(epsilon(tol))
  write(*,'(A,L1)') 'digits_self=', nd == digits(0)
  write(*,'(A,L1)') 'epsilon_self=', tol == sqrt(epsilon(1.0_dp))
end program propertyInConstantExpression_001

! CHECK: digits_self=T
! CHECK-NEXT: epsilon_self=T
