! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.10 [S1, S2, S3, S4]


program adjacentNumbers_005
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real(real64) :: x, y
  logical :: supported

  x = 1.0_real64 + command_argument_count()
  y = -2.5_real64 - command_argument_count()
  supported = ieee_support_datatype(x)
  write(*,'(A,L1)') 'datatype_supported_real64=', supported
  write(*,'(A,L1)') 'result_kind_real64=', kind(ieee_next_up(x)) == real64
  write(*,'(A,L1)') 'next_up(1)_step_eq_spacing=', ieee_next_up(x) - x == spacing(x)
  write(*,'(A,L1)') 'next_down(1)_step_eq_half_spacing=', x - ieee_next_down(x) == spacing(x) / 2
  write(*,'(A,L1)') 'next_up(-2.5)_eq_nearest=', ieee_next_up(y) == nearest(y, 1.0_real64)
  write(*,'(A,L1)') 'next_down(-2.5)_eq_nearest=', ieee_next_down(y) == nearest(y, -1.0_real64)
end program adjacentNumbers_005
! CHECK: datatype_supported_real64=T
! CHECK-NEXT: result_kind_real64=T
! CHECK-NEXT: next_up(1)_step_eq_spacing=T
! CHECK-NEXT: next_down(1)_step_eq_half_spacing=T
! CHECK-NEXT: next_up(-2.5)_eq_nearest=T
! CHECK-NEXT: next_down(-2.5)_eq_nearest=T
