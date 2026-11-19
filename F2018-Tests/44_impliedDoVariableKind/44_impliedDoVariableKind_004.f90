! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.18 [S1, S4]

program impliedDoVariableKind_004
  implicit none
  integer :: i = 99
  integer, allocatable :: v(:)
  integer :: n

  n = command_argument_count()
  v = [(i*10 + n, integer :: i = 1, 3)]
  write(*,'(A,I0,1X,I0,1X,I0)') 'values=', v
  write(*,'(A,I0)') 'outer_i=', i
end program impliedDoVariableKind_004

! CHECK: values=10 20 30
! CHECK-NEXT: outer_i=99
