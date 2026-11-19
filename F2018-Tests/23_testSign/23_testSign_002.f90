! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S6]


program testSign_002
  use ieee_arithmetic
  implicit none
  real :: x, pos_inf, neg_inf
  logical :: supported, inf_supported

  x = 1.0 + command_argument_count()
  supported = ieee_support_datatype(x)
  write(*,'(A,L1)') 'datatype_supported=', supported
  inf_supported = ieee_support_inf(x)
  write(*,'(A,L1)') 'inf_supported=', inf_supported
  if (supported .and. inf_supported) then
    pos_inf = ieee_value(x, ieee_positive_inf)
    neg_inf = ieee_value(x, ieee_negative_inf)
    write(*,'(A,L1)') 'signbit(+inf)=', ieee_signbit(pos_inf)
    write(*,'(A,L1)') 'signbit(-inf)=', ieee_signbit(neg_inf)
    write(*,'(A,L1)') 'elemental_rank1=', &
         all(ieee_signbit([x, -x, pos_inf, neg_inf]) .eqv. [.false., .true., .false., .true.])
  else
    write(*,'(A)') 'signbit(+inf)=UNSUPPORTED'
    write(*,'(A)') 'signbit(-inf)=UNSUPPORTED'
    write(*,'(A)') 'elemental_rank1=UNSUPPORTED'
  end if
end program testSign_002
! CHECK: datatype_supported=T
! CHECK-NEXT: inf_supported=T
! CHECK-NEXT: signbit(+inf)=F
! CHECK-NEXT: signbit(-inf)=T
! CHECK-NEXT: elemental_rank1=T
