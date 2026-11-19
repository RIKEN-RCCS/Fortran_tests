! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.30 [S5]

program hexadecimalEditing_005
  use, intrinsic :: ieee_arithmetic, only: ieee_value, ieee_support_inf, &
      ieee_support_nan, ieee_positive_inf, ieee_negative_inf, ieee_quiet_nan
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  character(40) :: buf
  real(dp) :: x
  logical :: supported

  x = 0.0_dp
  supported = ieee_support_inf(x) .and. ieee_support_nan(x)
  write(*,'(A,L1)') 'support=', supported
  if (supported) then
    x = ieee_value(x, ieee_positive_inf)
    write(buf,'(ss,ex0.1)') x
    write(*,'(A)') 'ex0.1_inf=[' // trim(buf) // ']'
    x = ieee_value(x, ieee_negative_inf)
    write(buf,'(ss,ex0.1)') x
    write(*,'(A)') 'ex0.1_-inf=[' // trim(buf) // ']'
    x = ieee_value(x, ieee_quiet_nan)
    write(buf,'(ss,ex0.1)') x
    write(*,'(A)') 'ex0.1_nan=[' // trim(buf) // ']'
  else
    write(*,'(A)') 'ex0.1_inf=UNSUPPORTED'
    write(*,'(A)') 'ex0.1_-inf=UNSUPPORTED'
    write(*,'(A)') 'ex0.1_nan=UNSUPPORTED'
  end if
end program hexadecimalEditing_005

! CHECK: support=T
! CHECK-NEXT: ex0.1_inf=[Inf]
! CHECK-NEXT: ex0.1_-inf=[-Inf]
! CHECK-NEXT: ex0.1_nan=[NaN]
