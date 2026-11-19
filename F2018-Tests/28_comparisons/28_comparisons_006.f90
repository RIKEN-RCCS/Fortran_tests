! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S6]


program comparisons_006
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: a
  complex :: z, znan
  logical :: supported, r, flag, halting

  a = 1.0 + command_argument_count()
  supported = ieee_support_nan(a)
  write(*,'(A,L1)') 'nan_supported=', supported
  z = cmplx(a, a)
  if (supported) then
    znan = cmplx(ieee_value(a, ieee_quiet_nan), a)
  else
    znan = z
  end if

  call ieee_get_halting_mode(ieee_invalid, halting)
  call ieee_set_halting_mode(ieee_invalid, .false.)

  call ieee_set_flag(ieee_invalid, .false.)
  r = z == znan
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1)') 'complex_eq invalid=', flag

  call ieee_set_flag(ieee_invalid, .false.)
  r = z /= znan
  call ieee_get_flag(ieee_invalid, flag)
  write(*,'(A,L1)') 'complex_ne invalid=', flag

  call ieee_set_halting_mode(ieee_invalid, halting)
end program comparisons_006
! CHECK: nan_supported=T
! CHECK-NEXT: complex_eq invalid=F
! CHECK-NEXT: complex_ne invalid=F
