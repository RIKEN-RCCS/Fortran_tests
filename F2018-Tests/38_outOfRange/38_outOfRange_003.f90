! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S2, S7, S8]


program outOfRange_003
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  real(dp) :: g, z
  real :: s
  logical :: range_ok

  z = real(command_argument_count(), dp)
  range_ok = range(1.0_dp) > range(1.0)
  write(*,'(A,L1)') 'range_ok=', range_ok
  if (range_ok) then
    g = real(huge(1.0), dp) + z
    s = huge(1.0) + real(z)
    write(*,'(A,L1)') 'huge_sp=', out_of_range(g, 1.0)
    write(*,'(A,L1)') '2*huge_sp=', out_of_range(2 * g, 1.0)
    write(*,'(A,L1)') '-2*huge_sp=', out_of_range(-2 * g, 1.0)
    write(*,'(A,L1)') 'tiny_sp/1024=', out_of_range(real(tiny(1.0), dp) / 1024 + z, 1.0)
    write(*,'(A,L1)') 'sp_to_dp=', out_of_range(s, 1.0_dp)
  else
    write(*,'(A)') 'huge_sp=UNSUPPORTED'
    write(*,'(A)') '2*huge_sp=UNSUPPORTED'
    write(*,'(A)') '-2*huge_sp=UNSUPPORTED'
    write(*,'(A)') 'tiny_sp/1024=UNSUPPORTED'
    write(*,'(A)') 'sp_to_dp=UNSUPPORTED'
  end if
end program outOfRange_003
! CHECK: range_ok=T
! CHECK-NEXT: huge_sp=F
! CHECK-NEXT: 2*huge_sp=T
! CHECK-NEXT: -2*huge_sp=T
! CHECK-NEXT: tiny_sp/1024=F
! CHECK-NEXT: sp_to_dp=F
