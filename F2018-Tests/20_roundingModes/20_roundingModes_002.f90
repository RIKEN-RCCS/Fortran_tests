! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.3 [S2, S3]


program roundingModes_002
  use, intrinsic :: ieee_arithmetic
  implicit none
  type(ieee_round_type) :: saved, omitted, radix2, after2, after_omitted
  integer :: radix

  radix = 2 + command_argument_count()

  call ieee_get_rounding_mode(saved)
  call ieee_get_rounding_mode(omitted)
  call ieee_get_rounding_mode(radix2, radix)
  write(*,'(A,L1)') 'get_radix2_eq_omitted=', radix2 == omitted

  call ieee_set_rounding_mode(ieee_up, radix)
  call ieee_get_rounding_mode(after2, radix)
  call ieee_get_rounding_mode(after_omitted)
  write(*,'(A,L1)') 'set_radix2_effective=', after2 == ieee_up
  write(*,'(A,L1)') 'omitted_follows_radix2=', after_omitted == ieee_up

  call ieee_set_rounding_mode(saved)
end program roundingModes_002
! CHECK: get_radix2_eq_omitted=T
! CHECK-NEXT: set_radix2_effective=T
! CHECK-NEXT: omitted_follows_radix2=T
