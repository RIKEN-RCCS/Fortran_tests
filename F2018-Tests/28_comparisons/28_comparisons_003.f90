! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S2, S4]


program comparisons_003
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: a, qnan
  logical :: supported, r, flag, halting

  a = 1.0 + command_argument_count()
  supported = ieee_support_nan(a)
  write(*,'(A,L1)') 'nan_supported=', supported
  if (supported) then
    qnan = ieee_value(a, ieee_quiet_nan)
  else
    qnan = a
  end if

  call ieee_get_halting_mode(ieee_invalid, halting)
  call ieee_set_halting_mode(ieee_invalid, .false.)

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_quiet_eq(a, qnan)
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'quiet_eq(1,qnan) result=', r, ' invalid=', flag

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_quiet_lt(a, qnan)
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'quiet_lt(1,qnan) result=', r, ' invalid=', flag

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_signaling_eq(a, qnan)
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'signaling_eq(1,qnan) result=', r, ' invalid=', flag

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_signaling_lt(a, qnan)
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'signaling_lt(1,qnan) result=', r, ' invalid=', flag

  call ieee_set_halting_mode(ieee_invalid, halting)
end program comparisons_003
! CHECK: nan_supported=T
! CHECK-NEXT: quiet_eq(1,qnan) result=F invalid=F
! CHECK-NEXT: quiet_lt(1,qnan) result=F invalid=F
! CHECK-NEXT: signaling_eq(1,qnan) result=F invalid=T
! CHECK-NEXT: signaling_lt(1,qnan) result=F invalid=T
