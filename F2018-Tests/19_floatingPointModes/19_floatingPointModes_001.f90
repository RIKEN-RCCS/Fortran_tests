! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.2 [S1, S2, S3]


program floatingPointModes_001
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  type(ieee_modes_type) :: saved
  type(ieee_round_type) :: round_before, round_after
  logical :: underflow_before, underflow_after
  logical :: halting_before, halting_after
  logical :: uc_supported, halt_supported
  real :: x

  x = 1.0 + command_argument_count()
  uc_supported = ieee_support_underflow_control(x)
  halt_supported = ieee_support_halting(ieee_overflow)
  write(*,'(A,L1)') 'underflow_control_supported=', uc_supported
  write(*,'(A,L1)') 'halting_supported=', halt_supported

  underflow_before = .false.
  halting_before = .false.
  call ieee_get_rounding_mode(round_before)
  if (uc_supported) call ieee_get_underflow_mode(underflow_before)
  if (halt_supported) call ieee_get_halting_mode(ieee_overflow, halting_before)

  call ieee_get_modes(saved)

  call ieee_set_rounding_mode(ieee_to_zero)
  if (uc_supported) call ieee_set_underflow_mode(.not. underflow_before)
  if (halt_supported) call ieee_set_halting_mode(ieee_overflow, .not. halting_before)

  call ieee_set_modes(saved)

  call ieee_get_rounding_mode(round_after)
  underflow_after = underflow_before
  halting_after = halting_before
  if (uc_supported) call ieee_get_underflow_mode(underflow_after)
  if (halt_supported) call ieee_get_halting_mode(ieee_overflow, halting_after)

  write(*,'(A,L1)') 'rounding_restored=', round_after == round_before
  write(*,'(A,L1)') 'underflow_restored=', underflow_after .eqv. underflow_before
  write(*,'(A,L1)') 'halting_restored=', halting_after .eqv. halting_before
end program floatingPointModes_001
! CHECK: underflow_control_supported=T
! CHECK-NEXT: halting_supported=T
! CHECK-NEXT: rounding_restored=T
! CHECK-NEXT: underflow_restored=T
! CHECK-NEXT: halting_restored=T
