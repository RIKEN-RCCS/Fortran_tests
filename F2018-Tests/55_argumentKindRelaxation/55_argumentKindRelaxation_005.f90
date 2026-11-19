! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.29 [S1, S6]

program argumentKindRelaxation_005
  implicit none
  integer, parameter :: ik18 = selected_int_kind(18)
  integer(ik18) :: n, s
  logical :: wider

  wider = range(0_ik18) > range(0)
  write(*,'(A,L1)') 'ik18_wider=', wider
  if (wider) then
    call get_environment_variable('F2018_TEST_NO_SUCH_VARIABLE_055', length=n, status=s)
    write(*,'(A,I0)') 'status=', s
    write(*,'(A,I0)') 'length=', n
  else
    write(*,'(A)') 'status=UNSUPPORTED'
    write(*,'(A)') 'length=UNSUPPORTED'
  end if
end program argumentKindRelaxation_005

! CHECK: ik18_wider=T
! CHECK-NEXT: status=1
! CHECK-NEXT: length=0
