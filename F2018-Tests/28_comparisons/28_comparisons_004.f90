! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S2, S4]


program comparisons_004
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: a, snan
  logical :: supported, r, flag, halting

  a = 1.0 + command_argument_count()
  supported = ieee_support_nan(a)
  write(*,'(A,L1)') 'nan_supported=', supported
  if (supported) then
    snan = ieee_value(a, ieee_signaling_nan)
  else
    snan = a
  end if

  call ieee_get_halting_mode(ieee_invalid, halting)
  call ieee_set_halting_mode(ieee_invalid, .false.)

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_quiet_eq(a, snan)
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'quiet_eq(1,snan) result=', r, ' invalid=', flag

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_signaling_eq(a, snan)
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'signaling_eq(1,snan) result=', r, ' invalid=', flag

  call ieee_set_halting_mode(ieee_invalid, halting)
end program comparisons_004
! CHECK: nan_supported=T
! CHECK-NEXT: quiet_eq(1,snan) result=F invalid=T
! CHECK-NEXT: signaling_eq(1,snan) result=F invalid=T
