! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.18 [S1]

program impliedDoVariableKind_001
  implicit none
  integer, parameter :: ik18 = selected_int_kind(18)
  integer(ik18), allocatable :: v(:)
  integer :: n
  logical :: wider

  n = command_argument_count()
  wider = range(0) < range(0_ik18)
  write(*,'(A,L1)') 'ik18_wider=', wider
  if (wider) then
    v = [(i - huge(0) + n, integer(ik18) :: i = huge(0) + 1_ik18, huge(0) + 3_ik18)]
    write(*,'(A,I0,1X,I0,1X,I0)') 'beyond_default=', v
  else
    write(*,'(A)') 'beyond_default=UNSUPPORTED'
  end if
end program impliedDoVariableKind_001

! CHECK: ik18_wider=T
! CHECK-NEXT: beyond_default=1 2 3
