! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.18 [S1, S4]

program impliedDoVariableKind_003
  implicit none
  integer, parameter :: ik18 = selected_int_kind(18)
  real :: i = 0.5
  integer(ik18), allocatable :: v(:)
  integer :: n

  n = command_argument_count()
  v = [((i/2)*2 + n, integer(ik18) :: i = 1, 3)]
  write(*,'(A,I0,1X,I0,1X,I0)') 'values=', v
  write(*,'(A,L1)') 'outer_i_is_0.5=', i == 0.5
end program impliedDoVariableKind_003

! CHECK: values=0 2 2
! CHECK-NEXT: outer_i_is_0.5=T
