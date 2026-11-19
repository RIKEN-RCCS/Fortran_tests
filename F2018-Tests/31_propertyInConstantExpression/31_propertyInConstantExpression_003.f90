! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.3 [S1]

program propertyInConstantExpression_003
  implicit none
  integer :: j
  integer :: idx(-2:3) = [(lbound(idx, 1) + j, j = 0, 5)]
  write(*,'(A,6(1X,I0))') 'idx=', idx
end program propertyInConstantExpression_003

! CHECK: idx= -2 -1 0 1 2 3
