! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S2, S4, S5, S8]


program outOfRange_002
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: dp = kind(1.0d0)
  real(dp) :: h, z
  logical :: precision_ok

  z = real(command_argument_count(), dp)
  h = real(huge(0_ik), dp) + z
  precision_ok = (h + 0.5_dp) - h == 0.5_dp
  write(*,'(A,L1)') 'precision_ok=', precision_ok
  if (precision_ok) then
    write(*,'(A,L1)') 'trunc(h+0.9)=', out_of_range(h + 0.9_dp, 0_ik)
    write(*,'(A,L1)') 'round_false(h+0.9)=', out_of_range(h + 0.9_dp, 0_ik, .false.)
    write(*,'(A,L1)') 'round_true(h+0.9)=', out_of_range(h + 0.9_dp, 0_ik, .true.)
    write(*,'(A,L1)') 'round_true(h+0.5)=', out_of_range(h + 0.5_dp, 0_ik, .true.)
    write(*,'(A,L1)') 'round_true(2.5)=', out_of_range(2.5_dp + z, 0_ik, .true.)
    write(*,'(A,L1)') 'trunc(-2h)=', out_of_range(-2 * h, 0_ik)
  else
    write(*,'(A)') 'trunc(h+0.9)=UNSUPPORTED'
    write(*,'(A)') 'round_false(h+0.9)=UNSUPPORTED'
    write(*,'(A)') 'round_true(h+0.9)=UNSUPPORTED'
    write(*,'(A)') 'round_true(h+0.5)=UNSUPPORTED'
    write(*,'(A)') 'round_true(2.5)=UNSUPPORTED'
    write(*,'(A)') 'trunc(-2h)=UNSUPPORTED'
  end if
end program outOfRange_002
! CHECK: precision_ok=T
! CHECK-NEXT: trunc(h+0.9)=F
! CHECK-NEXT: round_false(h+0.9)=F
! CHECK-NEXT: round_true(h+0.9)=T
! CHECK-NEXT: round_true(h+0.5)=T
! CHECK-NEXT: round_true(2.5)=F
! CHECK-NEXT: trunc(-2h)=T
