! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.3 [S1], 4.4 [S4]


program roundingModes_004
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved
  integer :: n
  real :: x
  logical :: supported

  n = 16777217 + command_argument_count()
  x = 1.0 + command_argument_count()

  supported = ieee_support_rounding(ieee_away, x)
  write(*,'(A,L1)') 'away_supported=', supported

  call ieee_get_rounding_mode(saved)
  if (supported) then
    call ieee_set_rounding_mode(ieee_away)
    write(*,'(A,F0.1)') 'away ieee_real(16777217)=', ieee_real(n)
  else
    write(*,'(A)') 'away ieee_real(16777217)=UNSUPPORTED'
  end if
  call ieee_set_rounding_mode(saved)
end program roundingModes_004
! CHECK: away_supported=T
! CHECK-NEXT: away ieee_real(16777217)=16777218.0
