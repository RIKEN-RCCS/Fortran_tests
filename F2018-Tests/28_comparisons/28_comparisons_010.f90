! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S1, S2, S3, S4]


program comparisons_010
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: a, snan
  logical :: supported, halting
  logical :: r(5), flag(5)

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
  r(1) = ieee_quiet_ge(a, snan)
  call ieee_get_flag(ieee_invalid, flag(1))
  call ieee_set_flag(ieee_invalid, .false.)
  r(2) = ieee_quiet_gt(a, snan)
  call ieee_get_flag(ieee_invalid, flag(2))
  call ieee_set_flag(ieee_invalid, .false.)
  r(3) = ieee_quiet_le(a, snan)
  call ieee_get_flag(ieee_invalid, flag(3))
  call ieee_set_flag(ieee_invalid, .false.)
  r(4) = ieee_quiet_lt(a, snan)
  call ieee_get_flag(ieee_invalid, flag(4))
  call ieee_set_flag(ieee_invalid, .false.)
  r(5) = ieee_quiet_ne(a, snan)
  call ieee_get_flag(ieee_invalid, flag(5))
  write(*,'(A,5L2,A,5L2)') 'quiet(1,snan) ge gt le lt ne result=', r, ' invalid=', flag

  call ieee_set_flag(ieee_invalid, .false.)
  r(1) = ieee_signaling_ge(a, snan)
  call ieee_get_flag(ieee_invalid, flag(1))
  call ieee_set_flag(ieee_invalid, .false.)
  r(2) = ieee_signaling_gt(a, snan)
  call ieee_get_flag(ieee_invalid, flag(2))
  call ieee_set_flag(ieee_invalid, .false.)
  r(3) = ieee_signaling_le(a, snan)
  call ieee_get_flag(ieee_invalid, flag(3))
  call ieee_set_flag(ieee_invalid, .false.)
  r(4) = ieee_signaling_lt(a, snan)
  call ieee_get_flag(ieee_invalid, flag(4))
  call ieee_set_flag(ieee_invalid, .false.)
  r(5) = ieee_signaling_ne(a, snan)
  call ieee_get_flag(ieee_invalid, flag(5))
  write(*,'(A,5L2,A,5L2)') 'signaling(1,snan) ge gt le lt ne result=', r, ' invalid=', flag
  call ieee_set_halting_mode(ieee_invalid, halting)
end program comparisons_010
! CHECK: nan_supported=T
! CHECK-NEXT: quiet(1,snan) ge gt le lt ne result= F F F F T invalid= T T T T T
! CHECK-NEXT: signaling(1,snan) ge gt le lt ne result= F F F F T invalid= T T T T T
