! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.3 [S1, S5]

program propertyInConstantExpression_004
  implicit none
  character(len=4), parameter :: bar = repeat('#', len(bar))
  write(*,'(A,A,A)') 'bar=[', bar, ']'
end program propertyInConstantExpression_004

! CHECK: bar=[####]
