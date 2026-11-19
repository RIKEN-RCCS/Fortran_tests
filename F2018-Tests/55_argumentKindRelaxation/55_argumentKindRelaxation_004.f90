! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.29 [S1, S3]

program argumentKindRelaxation_004
  implicit none
  integer, parameter :: ik18 = selected_int_kind(18)
  integer(ik18) :: n, s
  logical :: wider

  wider = range(0_ik18) > range(0)
  write(*,'(A,L1)') 'ik18_wider=', wider
  if (wider) then
    call get_command_argument(0_ik18, length=n, status=s)
    write(*,'(A,I0)') 'status=', s
    write(*,'(A,L1)') 'length_positive=', n > 0
  else
    write(*,'(A)') 'status=UNSUPPORTED'
    write(*,'(A)') 'length_positive=UNSUPPORTED'
  end if
end program argumentKindRelaxation_004

! CHECK: ik18_wider=T
! CHECK-NEXT: status=0
! CHECK-NEXT: length_positive=T
