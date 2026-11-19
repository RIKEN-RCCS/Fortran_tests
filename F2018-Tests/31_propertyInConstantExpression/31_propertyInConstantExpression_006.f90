! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.3 [S1]

program propertyInConstantExpression_006
  implicit none
  type :: pt(k)
    integer, kind :: k
    integer :: v
  end type pt
  type(pt(8)) :: y = pt(8)(y%k)
  write(*,'(A,I0)') 'kind_self_var=', y%v
end program propertyInConstantExpression_006

! CHECK: kind_self_var=8
