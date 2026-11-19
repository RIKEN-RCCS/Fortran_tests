! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.9 [S4]


program maxMinValues_002
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x, qnan
  logical :: supported

  x = 2.0 + command_argument_count()
  supported = ieee_support_nan(x)
  write(*,'(A,L1)') 'nan_supported=', supported

  if (supported) then
    qnan = ieee_value(x, ieee_quiet_nan)
  else
    qnan = x
  end if

  write(*,'(A,F0.1)') 'max_num(2,qnan)=', ieee_max_num(x, qnan)
  write(*,'(A,F0.1)') 'max_num(qnan,2)=', ieee_max_num(qnan, x)
  write(*,'(A,F0.1)') 'min_num(2,qnan)=', ieee_min_num(x, qnan)
  write(*,'(A,F0.1)') 'max_num_mag(2,qnan)=', ieee_max_num_mag(x, qnan)
  write(*,'(A,F0.1)') 'min_num_mag(2,qnan)=', ieee_min_num_mag(x, qnan)
end program maxMinValues_002
! CHECK: nan_supported=T
! CHECK-NEXT: max_num(2,qnan)=2.0
! CHECK-NEXT: max_num(qnan,2)=2.0
! CHECK-NEXT: min_num(2,qnan)=2.0
! CHECK-NEXT: max_num_mag(2,qnan)=2.0
! CHECK-NEXT: min_num_mag(2,qnan)=2.0
