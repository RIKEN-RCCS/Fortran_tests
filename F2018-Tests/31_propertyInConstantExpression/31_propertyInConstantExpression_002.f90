! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.3 [S1]

program propertyInConstantExpression_002
  implicit none
  integer :: j
  integer :: sq(6) = [(j*j, j = 1, size(sq))]
  write(*,'(A,6(1X,I0))') 'sq=', sq
end program propertyInConstantExpression_002

! CHECK: sq= 1 4 9 16 25 36
