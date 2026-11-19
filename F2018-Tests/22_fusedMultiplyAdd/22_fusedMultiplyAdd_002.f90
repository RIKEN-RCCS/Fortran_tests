! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.5 [S2]


program fusedMultiplyAdd_002
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved
  real, volatile :: a, b, c, an

  a = 4097.0 + command_argument_count()
  b = 4097.0 + command_argument_count()
  c = 0.0 + command_argument_count()
  an = -4097.0 - command_argument_count()

  write(*,'(A,L1)') 'rounding_supported=', ieee_support_rounding(ieee_nearest, a) .and. &
      ieee_support_rounding(ieee_to_zero, a) .and. ieee_support_rounding(ieee_up, a) .and. &
      ieee_support_rounding(ieee_down, a)

  call ieee_get_rounding_mode(saved)

  call ieee_set_rounding_mode(ieee_nearest)
  write(*,'(A,F0.1,A,F0.1)') 'nearest fma=', ieee_fma(a, b, c), ' neg=', ieee_fma(an, b, c)
  call ieee_set_rounding_mode(ieee_to_zero)
  write(*,'(A,F0.1,A,F0.1)') 'to_zero fma=', ieee_fma(a, b, c), ' neg=', ieee_fma(an, b, c)
  call ieee_set_rounding_mode(ieee_up)
  write(*,'(A,F0.1,A,F0.1)') 'up fma=', ieee_fma(a, b, c), ' neg=', ieee_fma(an, b, c)
  call ieee_set_rounding_mode(ieee_down)
  write(*,'(A,F0.1,A,F0.1)') 'down fma=', ieee_fma(a, b, c), ' neg=', ieee_fma(an, b, c)

  call ieee_set_rounding_mode(saved)
end program fusedMultiplyAdd_002
! CHECK: rounding_supported=T
! CHECK-NEXT: nearest fma=16785408.0 neg=-16785408.0
! CHECK-NEXT: to_zero fma=16785408.0 neg=-16785408.0
! CHECK-NEXT: up fma=16785410.0 neg=-16785408.0
! CHECK-NEXT: down fma=16785408.0 neg=-16785410.0
