! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.3 [S1], 4.5 [S2]


program roundingModes_005
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved
  real :: a, b, c
  logical :: supported

  a = 4097.0 + command_argument_count()
  b = 4097.0 + command_argument_count()
  c = 0.0 + command_argument_count()

  supported = ieee_support_rounding(ieee_away, a)
  write(*,'(A,L1)') 'away_supported=', supported

  call ieee_get_rounding_mode(saved)
  if (supported) then
    call ieee_set_rounding_mode(ieee_away)
    write(*,'(A,F0.1)') 'away ieee_fma(4097,4097,0)=', ieee_fma(a, b, c)
  else
    write(*,'(A)') 'away ieee_fma(4097,4097,0)=UNSUPPORTED'
  end if
  call ieee_set_rounding_mode(saved)
end program roundingModes_005
! CHECK: away_supported=T
! CHECK-NEXT: away ieee_fma(4097,4097,0)=16785410.0
