! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S5, S6]


program testSign_004
  use ieee_arithmetic
  implicit none
  real, volatile :: x, snan, neg_snan
  logical, volatile :: r
  logical :: supported, nan_supported, flag_supported, flag

  x = 1.0 + command_argument_count()
  supported = ieee_support_datatype(x)
  write(*,'(A,L1)') 'datatype_supported=', supported
  nan_supported = ieee_support_nan(x)
  write(*,'(A,L1)') 'nan_supported=', nan_supported
  flag_supported = ieee_support_flag(ieee_invalid, x)
  write(*,'(A,L1)') 'invalid_flag_supported=', flag_supported
  if (supported .and. nan_supported .and. flag_supported) then
    if (ieee_support_halting(ieee_invalid)) call ieee_set_halting_mode(ieee_invalid, .false.)
    snan = ieee_value(x, ieee_signaling_nan)
    neg_snan = ieee_copy_sign(snan, -x)
    call ieee_set_flag(ieee_invalid, .false.)
    r = ieee_signbit(neg_snan)
    call ieee_get_flag(ieee_invalid, flag)
    write(*,'(A,L1)') 'signbit(-snan)=', r
    write(*,'(A,L1)') 'invalid_not_signaled=', .not. flag
  else
    write(*,'(A)') 'signbit(-snan)=UNSUPPORTED'
    write(*,'(A)') 'invalid_not_signaled=UNSUPPORTED'
  end if
end program testSign_004
! CHECK: datatype_supported=T
! CHECK-NEXT: nan_supported=T
! CHECK-NEXT: invalid_flag_supported=T
! CHECK-NEXT: signbit(-snan)=T
! CHECK-NEXT: invalid_not_signaled=T
