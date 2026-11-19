! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.27 [S1, S2, S3]

program cmplxSimplification_004
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  complex :: z
  complex(dp) :: zd
  integer :: n
  logical :: differ
  complex(dp), parameter :: p = cmplx((1.5, -2.5), dp)

  n = command_argument_count()
  z = cmplx(1.5 + n, -2.5 - n)
  zd = cmplx(1.5_dp + n, -2.5_dp - n, dp)
  differ = kind(1.0) /= dp
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    write(*,'(A,L1)') 'parameter_value=', p == zd
  else
    write(*,'(A)') 'parameter_value=UNSUPPORTED'
  end if
end program cmplxSimplification_004

! CHECK: kinds_differ=T
! CHECK-NEXT: parameter_value=T
