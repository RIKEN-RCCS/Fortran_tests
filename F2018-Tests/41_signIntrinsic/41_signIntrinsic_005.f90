! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.15 [S1, S2]

program signIntrinsic_005
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: ik18 = selected_int_kind(18)
  integer :: n
  logical :: differ

  n = command_argument_count()
  differ = range(0_ik) < range(0_ik18)
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    write(*,'(A,I0)') 'keyword=', sign(b=-1_ik18 - n, a=9 + n)
  else
    write(*,'(A)') 'keyword=UNSUPPORTED'
  end if
end program signIntrinsic_005

! CHECK: kinds_differ=T
! CHECK-NEXT: keyword=-9
