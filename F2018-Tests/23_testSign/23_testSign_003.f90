! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S6]


program testSign_003
  use ieee_arithmetic
  implicit none
  real :: x, qnan, pos_nan, neg_nan
  logical :: supported, nan_supported

  x = 1.0 + command_argument_count()
  supported = ieee_support_datatype(x)
  write(*,'(A,L1)') 'datatype_supported=', supported
  nan_supported = ieee_support_nan(x)
  write(*,'(A,L1)') 'nan_supported=', nan_supported
  if (supported .and. nan_supported) then
    qnan = ieee_value(x, ieee_quiet_nan)
    pos_nan = ieee_copy_sign(qnan, x)
    neg_nan = ieee_copy_sign(qnan, -x)
    write(*,'(A,L1)') 'signbit(+nan)=', ieee_signbit(pos_nan)
    write(*,'(A,L1)') 'signbit(-nan)=', ieee_signbit(neg_nan)
  else
    write(*,'(A)') 'signbit(+nan)=UNSUPPORTED'
    write(*,'(A)') 'signbit(-nan)=UNSUPPORTED'
  end if
end program testSign_003
! CHECK: datatype_supported=T
! CHECK-NEXT: nan_supported=T
! CHECK-NEXT: signbit(+nan)=F
! CHECK-NEXT: signbit(-nan)=T
