! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S6]


program testSign_006
  use ieee_arithmetic
  implicit none
  real :: x, pos_sub, neg_sub
  logical :: supported, sub_supported

  x = 1.0 + command_argument_count()
  supported = ieee_support_datatype(x)
  write(*,'(A,L1)') 'datatype_supported=', supported
  sub_supported = ieee_support_subnormal(x)
  write(*,'(A,L1)') 'subnormal_supported=', sub_supported
  if (supported .and. sub_supported) then
    pos_sub = ieee_value(x, ieee_positive_subnormal)
    neg_sub = ieee_value(x, ieee_negative_subnormal)
    write(*,'(A,L1)') 'signbit(+subnormal)=', ieee_signbit(pos_sub)
    write(*,'(A,L1)') 'signbit(-subnormal)=', ieee_signbit(neg_sub)
  else
    write(*,'(A)') 'signbit(+subnormal)=UNSUPPORTED'
    write(*,'(A)') 'signbit(-subnormal)=UNSUPPORTED'
  end if
end program testSign_006
! CHECK: datatype_supported=T
! CHECK-NEXT: subnormal_supported=T
! CHECK-NEXT: signbit(+subnormal)=F
! CHECK-NEXT: signbit(-subnormal)=T
