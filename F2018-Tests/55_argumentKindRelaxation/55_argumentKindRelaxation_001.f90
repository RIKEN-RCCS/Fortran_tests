! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.29 [S1, S4]

program argumentKindRelaxation_001
  implicit none
  integer, parameter :: ik18 = selected_int_kind(18)
  integer(ik18) :: v(8)
  logical :: wider

  wider = range(0_ik18) > range(0)
  write(*,'(A,L1)') 'ik18_wider=', wider
  if (wider) then
    call date_and_time(values=v)
    write(*,'(A,L1)') 'year_plausible=', v(1) >= 2018 .or. v(1) == -huge(v)
    write(*,'(A,L1)') 'month_valid=', (v(2) >= 1 .and. v(2) <= 12) .or. v(2) == -huge(v)
  else
    write(*,'(A)') 'year_plausible=UNSUPPORTED'
    write(*,'(A)') 'month_valid=UNSUPPORTED'
  end if
end program argumentKindRelaxation_001

! CHECK: ik18_wider=T
! CHECK-NEXT: year_plausible=T
! CHECK-NEXT: month_valid=T
