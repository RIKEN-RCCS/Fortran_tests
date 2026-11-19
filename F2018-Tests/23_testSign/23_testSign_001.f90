! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S6]


program testSign_001
  use ieee_arithmetic
  implicit none
  real :: pos, neg, zero, neg_zero
  logical :: r, supported

  pos = 1.5 + command_argument_count()
  supported = ieee_support_datatype(pos)
  write(*,'(A,L1)') 'datatype_supported=', supported
  if (supported) then
    neg = -1.5 - command_argument_count()
    zero = 0.0 + command_argument_count()
    neg_zero = ieee_value(zero, ieee_negative_zero)
    r = ieee_signbit(pos)
    write(*,'(A,L1)') 'signbit(+1.5)=', r
    write(*,'(A,L1)') 'signbit(-1.5)=', ieee_signbit(neg)
    write(*,'(A,L1)') 'signbit(+0.0)=', ieee_signbit(zero)
    write(*,'(A,L1)') 'signbit(-0.0)=', ieee_signbit(neg_zero)
    write(*,'(A,L1)') 'result_is_default_logical=', kind(r) == kind(.true.)
  else
    write(*,'(A)') 'signbit(+1.5)=UNSUPPORTED'
    write(*,'(A)') 'signbit(-1.5)=UNSUPPORTED'
    write(*,'(A)') 'signbit(+0.0)=UNSUPPORTED'
    write(*,'(A)') 'signbit(-0.0)=UNSUPPORTED'
    write(*,'(A)') 'result_is_default_logical=UNSUPPORTED'
  end if
end program testSign_001
! CHECK: datatype_supported=T
! CHECK-NEXT: signbit(+1.5)=F
! CHECK-NEXT: signbit(-1.5)=T
! CHECK-NEXT: signbit(+0.0)=F
! CHECK-NEXT: signbit(-0.0)=T
! CHECK-NEXT: result_is_default_logical=T
