! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.3 [S1]

program propertyInConstantExpression_007
  implicit none
  type :: pt(k)
    integer, kind :: k
    integer :: v
  end type pt
  type(pt(4)), parameter :: z = pt(4)(z%k * 10)
  write(*,'(A,I0)') 'kind_self_param=', z%v
end program propertyInConstantExpression_007

! CHECK: kind_self_param=40
