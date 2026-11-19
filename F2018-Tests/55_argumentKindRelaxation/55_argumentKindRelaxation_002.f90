! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.29 [S1, S2, S3, S5]

program argumentKindRelaxation_002
  use, intrinsic :: iso_fortran_env, only: logical_kinds
  implicit none
  integer, parameter :: ik18 = selected_int_kind(18)
  integer, parameter :: nk = size(logical_kinds)
  integer, parameter :: lgk1 = logical_kinds(min(1, nk))
  integer, parameter :: lgk2 = logical_kinds(min(2, nk))
  integer, parameter :: lgk3 = logical_kinds(min(3, nk))
  integer, parameter :: lgk4 = logical_kinds(min(4, nk))
  integer, parameter :: lgk5 = logical_kinds(min(5, nk))
  integer, parameter :: lgk6 = logical_kinds(min(6, nk))
  integer, parameter :: lgk7 = logical_kinds(min(7, nk))
  integer, parameter :: lgk8 = logical_kinds(min(8, nk))
  integer(ik18) :: es, cs, cs_first
  logical :: wider, covered, all3

  wider = range(0_ik18) > range(0)
  covered = nk <= 8
  write(*,'(A,L1)') 'ik18_wider=', wider
  write(*,'(A,L1)') 'kinds_covered=', covered
  if (wider .and. covered) then
    cs_first = 0
    all3 = .true.
    if (nk >= 1) then
      call execute_command_line('exit 3', wait=.true._lgk1, exitstat=es, cmdstat=cs)
      call record()
    end if
    if (nk >= 2) then
      call execute_command_line('exit 3', wait=.true._lgk2, exitstat=es, cmdstat=cs)
      call record()
    end if
    if (nk >= 3) then
      call execute_command_line('exit 3', wait=.true._lgk3, exitstat=es, cmdstat=cs)
      call record()
    end if
    if (nk >= 4) then
      call execute_command_line('exit 3', wait=.true._lgk4, exitstat=es, cmdstat=cs)
      call record()
    end if
    if (nk >= 5) then
      call execute_command_line('exit 3', wait=.true._lgk5, exitstat=es, cmdstat=cs)
      call record()
    end if
    if (nk >= 6) then
      call execute_command_line('exit 3', wait=.true._lgk6, exitstat=es, cmdstat=cs)
      call record()
    end if
    if (nk >= 7) then
      call execute_command_line('exit 3', wait=.true._lgk7, exitstat=es, cmdstat=cs)
      call record()
    end if
    if (nk >= 8) then
      call execute_command_line('exit 3', wait=.true._lgk8, exitstat=es, cmdstat=cs)
      call record()
    end if
    write(*,'(A,I0)') 'cmdstat_all=', cs_first
    write(*,'(A,L1)') 'exitstat_all_3=', all3
  else
    write(*,'(A)') 'cmdstat_all=UNSUPPORTED'
    write(*,'(A)') 'exitstat_all_3=UNSUPPORTED'
  end if

contains
  subroutine record()
    if (cs /= 0 .and. cs_first == 0) cs_first = cs
    all3 = all3 .and. es == 3
  end subroutine record
end program argumentKindRelaxation_002

! CHECK: ik18_wider=T
! CHECK-NEXT: kinds_covered=T
! CHECK-NEXT: cmdstat_all=0
! CHECK-NEXT: exitstat_all_3=T
