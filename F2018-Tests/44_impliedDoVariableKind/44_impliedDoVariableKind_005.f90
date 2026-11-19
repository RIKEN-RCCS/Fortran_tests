! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.18 [S1]

program impliedDoVariableKind_005
  implicit none
  integer, parameter :: ik18 = selected_int_kind(18)
  integer :: a(5)
  data (a(i), integer(ik18) :: i = 1, 5, 2) /3*7/
  data (a(i), integer(ik18) :: i = 2, 4, 2) /2*8/

  write(*,'(A,4(I0,1X),I0)') 'data_values=', a
end program impliedDoVariableKind_005

! CHECK: data_values=7 8 7 8 7
