! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.2 [S2, S3]


module floatingPointModes_003_m
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
contains
  subroutine change_and_restore(round_value)
    type(ieee_round_type), intent(in) :: round_value
    type(ieee_modes_type) :: local_saved
    call ieee_get_modes(local_saved)
    call ieee_set_rounding_mode(round_value)
    call ieee_set_modes(local_saved)
  end subroutine change_and_restore
end module floatingPointModes_003_m

program floatingPointModes_003
  use floatingPointModes_003_m
  implicit none
  type(ieee_modes_type) :: snap1, snap2
  type(ieee_round_type) :: round_orig, round_now

  call ieee_get_rounding_mode(round_orig)
  call ieee_get_modes(snap1)
  call ieee_set_rounding_mode(ieee_up)
  call ieee_get_modes(snap2)
  call ieee_set_rounding_mode(ieee_to_zero)

  call ieee_set_modes(snap1)
  call ieee_get_rounding_mode(round_now)
  write(*,'(A,L1)') 'restore_snap1_eq_orig=', round_now == round_orig
  call ieee_set_modes(snap2)
  call ieee_get_rounding_mode(round_now)
  write(*,'(A,L1)') 'restore_snap2_eq_up=', round_now == ieee_up

  call ieee_set_modes(snap1)
  call change_and_restore(ieee_up)
  call ieee_get_rounding_mode(round_now)
  write(*,'(A,L1)') 'caller_unchanged_after_callee_restore=', round_now == round_orig
end program floatingPointModes_003
! CHECK: restore_snap1_eq_orig=T
! CHECK-NEXT: restore_snap2_eq_up=T
! CHECK-NEXT: caller_unchanged_after_callee_restore=T
