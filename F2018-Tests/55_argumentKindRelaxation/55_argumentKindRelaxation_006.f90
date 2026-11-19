! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.29 [S3]

program argumentKindRelaxation_006
  use, intrinsic :: iso_fortran_env, only: logical_kinds
  use, intrinsic :: ieee_arithmetic
  implicit none
  integer, parameter :: nk = size(logical_kinds)
  integer, parameter :: lgk1 = logical_kinds(min(1, nk))
  integer, parameter :: lgk2 = logical_kinds(min(2, nk))
  integer, parameter :: lgk3 = logical_kinds(min(3, nk))
  integer, parameter :: lgk4 = logical_kinds(min(4, nk))
  integer, parameter :: lgk5 = logical_kinds(min(5, nk))
  integer, parameter :: lgk6 = logical_kinds(min(6, nk))
  integer, parameter :: lgk7 = logical_kinds(min(7, nk))
  integer, parameter :: lgk8 = logical_kinds(min(8, nk))
  logical(lgk1) :: l1
  logical(lgk2) :: l2
  logical(lgk3) :: l3
  logical(lgk4) :: l4
  logical(lgk5) :: l5
  logical(lgk6) :: l6
  logical(lgk7) :: l7
  logical(lgk8) :: l8
  logical :: covered, supported, all_true, any_true

  covered = nk <= 8
  supported = ieee_support_flag(ieee_overflow)
  write(*,'(A,L1)') 'kinds_covered=', covered
  write(*,'(A,L1)') 'flag_supported=', supported
  if (covered .and. supported) then
    all_true = .true.
    any_true = .false.
    if (nk >= 1) then
      call ieee_set_flag(ieee_overflow, .true._lgk1)
      call ieee_get_flag(ieee_overflow, l1)
      all_true = all_true .and. l1
      call ieee_set_flag(ieee_overflow, .false._lgk1)
      call ieee_get_flag(ieee_overflow, l1)
      any_true = any_true .or. l1
    end if
    if (nk >= 2) then
      call ieee_set_flag(ieee_overflow, .true._lgk2)
      call ieee_get_flag(ieee_overflow, l2)
      all_true = all_true .and. l2
      call ieee_set_flag(ieee_overflow, .false._lgk2)
      call ieee_get_flag(ieee_overflow, l2)
      any_true = any_true .or. l2
    end if
    if (nk >= 3) then
      call ieee_set_flag(ieee_overflow, .true._lgk3)
      call ieee_get_flag(ieee_overflow, l3)
      all_true = all_true .and. l3
      call ieee_set_flag(ieee_overflow, .false._lgk3)
      call ieee_get_flag(ieee_overflow, l3)
      any_true = any_true .or. l3
    end if
    if (nk >= 4) then
      call ieee_set_flag(ieee_overflow, .true._lgk4)
      call ieee_get_flag(ieee_overflow, l4)
      all_true = all_true .and. l4
      call ieee_set_flag(ieee_overflow, .false._lgk4)
      call ieee_get_flag(ieee_overflow, l4)
      any_true = any_true .or. l4
    end if
    if (nk >= 5) then
      call ieee_set_flag(ieee_overflow, .true._lgk5)
      call ieee_get_flag(ieee_overflow, l5)
      all_true = all_true .and. l5
      call ieee_set_flag(ieee_overflow, .false._lgk5)
      call ieee_get_flag(ieee_overflow, l5)
      any_true = any_true .or. l5
    end if
    if (nk >= 6) then
      call ieee_set_flag(ieee_overflow, .true._lgk6)
      call ieee_get_flag(ieee_overflow, l6)
      all_true = all_true .and. l6
      call ieee_set_flag(ieee_overflow, .false._lgk6)
      call ieee_get_flag(ieee_overflow, l6)
      any_true = any_true .or. l6
    end if
    if (nk >= 7) then
      call ieee_set_flag(ieee_overflow, .true._lgk7)
      call ieee_get_flag(ieee_overflow, l7)
      all_true = all_true .and. l7
      call ieee_set_flag(ieee_overflow, .false._lgk7)
      call ieee_get_flag(ieee_overflow, l7)
      any_true = any_true .or. l7
    end if
    if (nk >= 8) then
      call ieee_set_flag(ieee_overflow, .true._lgk8)
      call ieee_get_flag(ieee_overflow, l8)
      all_true = all_true .and. l8
      call ieee_set_flag(ieee_overflow, .false._lgk8)
      call ieee_get_flag(ieee_overflow, l8)
      any_true = any_true .or. l8
    end if
    write(*,'(A,L1)') 'set_true_get_all=', all_true
    write(*,'(A,L1)') 'set_false_get_any=', any_true
  else
    write(*,'(A)') 'set_true_get_all=UNSUPPORTED'
    write(*,'(A)') 'set_false_get_any=UNSUPPORTED'
  end if
end program argumentKindRelaxation_006

! CHECK: kinds_covered=T
! CHECK-NEXT: flag_supported=T
! CHECK-NEXT: set_true_get_all=T
! CHECK-NEXT: set_false_get_any=F
