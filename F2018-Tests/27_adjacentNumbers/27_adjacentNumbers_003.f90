! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.10 [S2, S3]


program adjacentNumbers_003
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: ieee_exceptions
  implicit none
  real :: x, snan, r
  logical :: datatype_supported, nan_supported, invalid_flag, halting

  x = 1.0 + command_argument_count()
  datatype_supported = ieee_support_datatype(x)
  nan_supported = ieee_support_nan(x)
  write(*,'(A,L1)') 'datatype_supported=', datatype_supported
  write(*,'(A,L1)') 'nan_supported=', nan_supported

  if (nan_supported) then
    snan = ieee_value(x, ieee_signaling_nan)
  else
    snan = x
  end if

  call ieee_get_halting_mode(ieee_invalid, halting)
  call ieee_set_halting_mode(ieee_invalid, .false.)

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_next_up(snan)
  call ieee_get_flag(ieee_invalid, invalid_flag)
  write(*,'(A,L1,A,L1)') 'next_up(snan) invalid=', invalid_flag, ' result_nan=', ieee_is_nan(r)

  call ieee_set_flag(ieee_invalid, .false.)
  r = ieee_next_up(x)
  call ieee_get_flag(ieee_invalid, invalid_flag)
  write(*,'(A,L1)') 'next_up(normal) invalid=', invalid_flag

  call ieee_set_halting_mode(ieee_invalid, halting)
end program adjacentNumbers_003
! CHECK: datatype_supported=T
! CHECK-NEXT: nan_supported=T
! CHECK-NEXT: next_up(snan) invalid=T result_nan=T
! CHECK-NEXT: next_up(normal) invalid=F
