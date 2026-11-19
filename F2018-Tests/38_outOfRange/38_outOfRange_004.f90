! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S2, S3, S6]


program outOfRange_004
  use, intrinsic :: ieee_arithmetic, only: ieee_support_inf, ieee_support_nan, &
       ieee_value, ieee_positive_inf, ieee_negative_inf, ieee_quiet_nan
  implicit none
  real :: pinf, ninf, qnan, z
  logical :: inf_supported, nan_supported

  z = real(command_argument_count())
  inf_supported = ieee_support_inf(1.0)
  nan_supported = ieee_support_nan(1.0)
  write(*,'(A,L1)') 'inf_supported=', inf_supported
  write(*,'(A,L1)') 'nan_supported=', nan_supported
  if (inf_supported) then
    pinf = ieee_value(z, ieee_positive_inf)
    ninf = ieee_value(z, ieee_negative_inf)
    write(*,'(A,L1)') '+inf_to_int=', out_of_range(pinf, 0)
    write(*,'(A,L1)') '-inf_to_int=', out_of_range(ninf, 0)
  else
    write(*,'(A)') '+inf_to_int=UNSUPPORTED'
    write(*,'(A)') '-inf_to_int=UNSUPPORTED'
  end if
  if (nan_supported) then
    qnan = ieee_value(z, ieee_quiet_nan)
    write(*,'(A,L1)') 'nan_to_int=', out_of_range(qnan, 0)
  else
    write(*,'(A)') 'nan_to_int=UNSUPPORTED'
  end if
  if (inf_supported) then
    write(*,'(A,L1)') '+inf_to_int_round=', out_of_range(pinf, 0, .true.)
    write(*,'(A,L1)') '+inf_to_real=', out_of_range(pinf, 1.0)
  else
    write(*,'(A)') '+inf_to_int_round=UNSUPPORTED'
    write(*,'(A)') '+inf_to_real=UNSUPPORTED'
  end if
  if (nan_supported) then
    write(*,'(A,L1)') 'nan_to_real=', out_of_range(qnan, 1.0)
  else
    write(*,'(A)') 'nan_to_real=UNSUPPORTED'
  end if
end program outOfRange_004
! CHECK: inf_supported=T
! CHECK-NEXT: nan_supported=T
! CHECK-NEXT: +inf_to_int=T
! CHECK-NEXT: -inf_to_int=T
! CHECK-NEXT: nan_to_int=T
! CHECK-NEXT: +inf_to_int_round=T
! CHECK-NEXT: +inf_to_real=F
! CHECK-NEXT: nan_to_real=F
