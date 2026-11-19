! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.3 [S3]

program propertyInConstantExpression_005
  implicit none
  integer :: w(4) = 0, nw = size(w)
  write(*,'(A,I0)') 'nw=', nw
end program propertyInConstantExpression_005

! CHECK: nw=4
