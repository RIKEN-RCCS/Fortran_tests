! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.18 [S1]

program impliedDoVariableKind_002
  implicit none
  integer, parameter :: ik18 = selected_int_kind(18)
  integer, parameter :: p(3) = [(2*i, integer(ik18) :: i = 1, 3)]

  write(*,'(A,I0,1X,I0,1X,I0)') 'parameter=', p
end program impliedDoVariableKind_002

! CHECK: parameter=2 4 6
