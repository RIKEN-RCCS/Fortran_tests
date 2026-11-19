! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.18 [S1, S3]

program impliedDoVariableKind_006
  implicit none
  integer :: b(3,2), j
  data ((b(i,j), integer :: i = 1, 3), j = 1, 2) /6*1/

  write(*,'(A,I0)') 'nested_sum=', sum(b)
end program impliedDoVariableKind_006

! CHECK: nested_sum=6
