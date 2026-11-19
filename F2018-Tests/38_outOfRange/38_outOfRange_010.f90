! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S4, S5, S9]


program outOfRange_010
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: lk = selected_int_kind(18)
  integer, parameter :: dp = kind(1.0d0)
  integer(lk) :: n, k
  real(dp) :: h
  logical :: range_ok, precision_ok

  n = command_argument_count()
  range_ok = range(0_ik) < range(0_lk)
  h = real(huge(0_ik), dp) + real(n, dp)
  precision_ok = (h + 1.5_dp) - h == 1.5_dp
  write(*,'(A,L1)') 'range_ok=', range_ok
  write(*,'(A,L1)') 'precision_ok=', precision_ok
  if (range_ok) then
    k = -int(huge(0_ik), lk) - n
    write(*,'(A,L1)') 'int(-huge-1)=', out_of_range(k - 1, 0_ik)
    write(*,'(A,L1)') 'int(-huge-2)=', out_of_range(k - 2, 0_ik)
  else
    write(*,'(A)') 'int(-huge-1)=UNSUPPORTED'
    write(*,'(A)') 'int(-huge-2)=UNSUPPORTED'
  end if
  if (range_ok .and. precision_ok) then
    write(*,'(A,L1)') 'trunc(-(h+1.9))=', out_of_range(-(h + 1.9_dp), 0_ik)
    write(*,'(A,L1)') 'round_true(-(h+0.9))=', out_of_range(-(h + 0.9_dp), 0_ik, .true.)
    write(*,'(A,L1)') 'round_true(-(h+1.5))=', out_of_range(-(h + 1.5_dp), 0_ik, .true.)
  else
    write(*,'(A)') 'trunc(-(h+1.9))=UNSUPPORTED'
    write(*,'(A)') 'round_true(-(h+0.9))=UNSUPPORTED'
    write(*,'(A)') 'round_true(-(h+1.5))=UNSUPPORTED'
  end if
end program outOfRange_010
! CHECK: range_ok=T
! CHECK-NEXT: precision_ok=T
! CHECK-NEXT: int(-huge-1)=F
! CHECK-NEXT: int(-huge-2)=T
! CHECK-NEXT: trunc(-(h+1.9))=F
! CHECK-NEXT: round_true(-(h+0.9))=F
! CHECK-NEXT: round_true(-(h+1.5))=T
