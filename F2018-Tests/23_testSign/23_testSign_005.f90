! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S6]


program testSign_005
  use ieee_arithmetic
  implicit none
  double precision :: pos, neg, zero, neg_zero
  logical :: r, supported

  pos = 1.5d0 + command_argument_count()
  supported = ieee_support_datatype(pos)
  write(*,'(A,L1)') 'dp_datatype_supported=', supported
  if (supported) then
    neg = -1.5d0 - command_argument_count()
    zero = 0.0d0 + command_argument_count()
    neg_zero = ieee_value(zero, ieee_negative_zero)
    r = ieee_signbit(pos)
    write(*,'(A,L1)') 'dp_signbit(+1.5)=', r
    write(*,'(A,L1)') 'dp_signbit(-1.5)=', ieee_signbit(neg)
    write(*,'(A,L1)') 'dp_signbit(+0.0)=', ieee_signbit(zero)
    write(*,'(A,L1)') 'dp_signbit(-0.0)=', ieee_signbit(neg_zero)
    write(*,'(A,L1)') 'dp_result_is_default_logical=', kind(r) == kind(.true.)
  else
    write(*,'(A)') 'dp_signbit(+1.5)=UNSUPPORTED'
    write(*,'(A)') 'dp_signbit(-1.5)=UNSUPPORTED'
    write(*,'(A)') 'dp_signbit(+0.0)=UNSUPPORTED'
    write(*,'(A)') 'dp_signbit(-0.0)=UNSUPPORTED'
    write(*,'(A)') 'dp_result_is_default_logical=UNSUPPORTED'
  end if
end program testSign_005
! CHECK: dp_datatype_supported=T
! CHECK-NEXT: dp_signbit(+1.5)=F
! CHECK-NEXT: dp_signbit(-1.5)=T
! CHECK-NEXT: dp_signbit(+0.0)=F
! CHECK-NEXT: dp_signbit(-0.0)=T
! CHECK-NEXT: dp_result_is_default_logical=T
