! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.27 [S1, S2, S3]

program cmplxSimplification_006
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  complex :: z
  complex(dp) :: zd
  integer :: n
  logical :: differ

  n = command_argument_count()
  z = cmplx(1.5 + n, -2.5 - n)
  zd = cmplx(1.5_dp + n, -2.5_dp - n, dp)
  differ = kind(1.0) /= dp
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    write(*,'(A,L1)') 'kind_expr=', kind(cmplx(z, kind(1.0_dp))) == dp
  else
    write(*,'(A)') 'kind_expr=UNSUPPORTED'
  end if
end program cmplxSimplification_006

! CHECK: kinds_differ=T
! CHECK-NEXT: kind_expr=T
