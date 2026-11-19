! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.3 [S1]


program roundingModes_001
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved
  real :: a, b, c
  logical :: supported

  a = 2.5 + command_argument_count()
  b = 4.5 + command_argument_count()
  c = -2.5 - command_argument_count()

  supported = ieee_support_rounding(ieee_away, a)
  write(*,'(A,L1)') 'away_supported=', supported

  call ieee_get_rounding_mode(saved)
  if (supported) then
    call ieee_set_rounding_mode(ieee_away)
    write(*,'(A,F0.1)') 'away rint(2.5)=', ieee_rint(a)
    write(*,'(A,F0.1)') 'away rint(4.5)=', ieee_rint(b)
    write(*,'(A,F0.1)') 'away rint(-2.5)=', ieee_rint(c)
  else
    write(*,'(A)') 'away rint(2.5)=UNSUPPORTED'
    write(*,'(A)') 'away rint(4.5)=UNSUPPORTED'
    write(*,'(A)') 'away rint(-2.5)=UNSUPPORTED'
  end if

  call ieee_set_rounding_mode(ieee_nearest)
  write(*,'(A,F0.1)') 'nearest rint(2.5)=', ieee_rint(a)
  write(*,'(A,F0.1)') 'nearest rint(4.5)=', ieee_rint(b)
  call ieee_set_rounding_mode(saved)
end program roundingModes_001
! CHECK: away_supported=T
! CHECK-NEXT: away rint(2.5)=3.0
! CHECK-NEXT: away rint(4.5)=5.0
! CHECK-NEXT: away rint(-2.5)=-3.0
! CHECK-NEXT: nearest rint(2.5)=2.0
! CHECK-NEXT: nearest rint(4.5)=4.0
