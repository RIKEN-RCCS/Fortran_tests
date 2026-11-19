! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S2, S7, S8]


program outOfRange_005
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: lk = selected_int_kind(18)
  integer(lk) :: n, x
  logical :: range_ok

  n = command_argument_count()
  range_ok = range(0_ik) < range(0_lk)
  write(*,'(A,L1)') 'range_ok=', range_ok
  x = huge(0_lk) - n
  if (range_ok .and. range(1.0) >= 37) then
    write(*,'(A,L1)') 'huge_lk_to_sp=', out_of_range(x, 1.0)
  else
    write(*,'(A)') 'huge_lk_to_sp=UNSUPPORTED'
  end if
  if (range_ok) then
    write(*,'(A,L1)') 'huge_lk_to_dp=', out_of_range(x, 1.0d0)
  else
    write(*,'(A)') 'huge_lk_to_dp=UNSUPPORTED'
  end if
end program outOfRange_005
! CHECK: range_ok=T
! CHECK-NEXT: huge_lk_to_sp=F
! CHECK-NEXT: huge_lk_to_dp=F
