! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.27 [S1, S2, S3]

program cmplxSimplification_001
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
    write(*,'(A,L1)') 'positional_kind=', kind(cmplx(z, dp)) == dp
    write(*,'(A,L1)') 'positional_value=', cmplx(z, dp) == zd
    write(*,'(A,L1)') 'no_kind=', kind(cmplx(z)) == kind(1.0)
    write(*,'(A,L1)') 'keyword_kind=', kind(cmplx(z, kind=dp)) == dp
    write(*,'(A,L1)') 'dp_to_default=', cmplx(zd, kind(1.0)) == z
  else
    write(*,'(A)') 'positional_kind=UNSUPPORTED'
    write(*,'(A)') 'positional_value=UNSUPPORTED'
    write(*,'(A)') 'no_kind=UNSUPPORTED'
    write(*,'(A)') 'keyword_kind=UNSUPPORTED'
    write(*,'(A)') 'dp_to_default=UNSUPPORTED'
  end if
end program cmplxSimplification_001

! CHECK: kinds_differ=T
! CHECK-NEXT: positional_kind=T
! CHECK-NEXT: positional_value=T
! CHECK-NEXT: no_kind=T
! CHECK-NEXT: keyword_kind=T
! CHECK-NEXT: dp_to_default=T
