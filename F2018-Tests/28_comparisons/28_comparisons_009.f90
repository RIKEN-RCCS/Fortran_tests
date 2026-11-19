! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S2, S4, S5]


program comparisons_009
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
  r = ieee_quiet_ne(a, qnan)
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'quiet_ne(1,qnan) result=', r, ' invalid=', flag
  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_signaling_ne(a, qnan)
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'signaling_ne(1,qnan) result=', r, ' invalid=', flag
  call ieee_set_flag(ieee_invalid, .false.)
  r = a /= qnan
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1,A,L1)') 'ne_operator(1,qnan) result=', r, ' invalid=', flag
  call ieee_set_halting_mode(ieee_invalid, halting)
end program comparisons_009
! CHECK: nan_supported=T
! CHECK-NEXT: quiet_ne(1,qnan) result=T invalid=F
! CHECK-NEXT: signaling_ne(1,qnan) result=T invalid=T
! CHECK-NEXT: ne_operator(1,qnan) result=T invalid=F
