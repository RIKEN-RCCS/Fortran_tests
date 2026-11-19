! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S1, S2, S4, S8]


program outOfRange_001
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: lk = selected_int_kind(18)
  integer(lk) :: n, x
  logical :: range_ok

  n = command_argument_count()
  range_ok = range(0_ik) < range(0_lk)
  write(*,'(A,L1)') 'range_ok=', range_ok
  if (range_ok) then
    x = int(huge(0_ik), lk) + n
    write(*,'(A,L1)') 'huge_ik=', out_of_range(x, 0_ik)
    write(*,'(A,L1)') 'huge_ik+1=', out_of_range(x + 1, 0_ik)
    write(*,'(A,L1)') '-2*huge_ik=', out_of_range(-2 * x, 0_ik)
    write(*,'(A,L1)') 'huge_lk_same_kind=', out_of_range(huge(0_lk) - n, 0_lk)
    write(*,'(A,L1)') 'result_is_default_logical=', kind(out_of_range(x, 0_ik)) == kind(.true.)
  else
    write(*,'(A)') 'huge_ik=UNSUPPORTED'
    write(*,'(A)') 'huge_ik+1=UNSUPPORTED'
    write(*,'(A)') '-2*huge_ik=UNSUPPORTED'
    write(*,'(A)') 'huge_lk_same_kind=UNSUPPORTED'
    write(*,'(A)') 'result_is_default_logical=UNSUPPORTED'
  end if
end program outOfRange_001
! CHECK: range_ok=T
! CHECK-NEXT: huge_ik=F
! CHECK-NEXT: huge_ik+1=T
! CHECK-NEXT: -2*huge_ik=T
! CHECK-NEXT: huge_lk_same_kind=F
! CHECK-NEXT: result_is_default_logical=T
