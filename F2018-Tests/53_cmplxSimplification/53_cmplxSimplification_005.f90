! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.27 [S1, S2, S3]

program cmplxSimplification_005
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  complex :: z
  complex(dp) :: zd
  integer :: n
  logical :: differ
  complex :: za(2)

  n = command_argument_count()
  z = cmplx(1.5 + n, -2.5 - n)
  zd = cmplx(1.5_dp + n, -2.5_dp - n, dp)
  differ = kind(1.0) /= dp
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    za = [z, conjg(z)]
    write(*,'(A,L1)') 'array_kind=', kind(cmplx(za, dp)) == dp
    write(*,'(A,L1)') 'array_value=', all(cmplx(za, dp) == [zd, conjg(zd)])
  else
    write(*,'(A)') 'array_kind=UNSUPPORTED'
    write(*,'(A)') 'array_value=UNSUPPORTED'
  end if
end program cmplxSimplification_005

! CHECK: kinds_differ=T
! CHECK-NEXT: array_kind=T
! CHECK-NEXT: array_value=T
