! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.9 [S4]


program maxMinValues_006
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: x, qnan, r
  logical :: supported, invalid_flag, halting

  x = 2.0 + command_argument_count()
  supported = ieee_support_nan(x)
  write(*,'(A,L1)') 'nan_supported=', supported

  if (supported) then
    qnan = ieee_value(x, ieee_quiet_nan)
  else
    qnan = x
  end if

  call ieee_get_halting_mode(ieee_invalid, halting)
  call ieee_set_halting_mode(ieee_invalid, .false.)

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_max_num(qnan, qnan)
  call ieee_get_flag(ieee_invalid, invalid_flag)
  write(*,'(A,L1,A,L1)') 'max_num(qnan,qnan) invalid=', invalid_flag, ' result_nan=', ieee_is_nan(r)

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_min_num(qnan, qnan)
  call ieee_get_flag(ieee_invalid, invalid_flag)
  write(*,'(A,L1,A,L1)') 'min_num(qnan,qnan) invalid=', invalid_flag, ' result_nan=', ieee_is_nan(r)

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_max_num_mag(qnan, qnan)
  call ieee_get_flag(ieee_invalid, invalid_flag)
  write(*,'(A,L1,A,L1)') 'max_num_mag(qnan,qnan) invalid=', invalid_flag, ' result_nan=', ieee_is_nan(r)

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_min_num_mag(qnan, qnan)
  call ieee_get_flag(ieee_invalid, invalid_flag)
  write(*,'(A,L1,A,L1)') 'min_num_mag(qnan,qnan) invalid=', invalid_flag, ' result_nan=', ieee_is_nan(r)

  call ieee_set_halting_mode(ieee_invalid, halting)
end program maxMinValues_006
! CHECK: nan_supported=T
! CHECK-NEXT: max_num(qnan,qnan) invalid=F result_nan=T
! CHECK-NEXT: min_num(qnan,qnan) invalid=F result_nan=T
! CHECK-NEXT: max_num_mag(qnan,qnan) invalid=F result_nan=T
! CHECK-NEXT: min_num_mag(qnan,qnan) invalid=F result_nan=T
