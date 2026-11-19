! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.15 [S1, S2]

program signIntrinsic_003
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: ik18 = selected_int_kind(18)
  integer :: n
  logical :: differ

  n = command_argument_count()
  differ = range(0_ik) < range(0_ik18)
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    write(*,'(A,3(1X,I0))') 'array_array=', sign([1, 2, 3] + n, [-1_ik18, 1_ik18, -1_ik18] * (n + 1))
    write(*,'(A,2(1X,I0))') 'scalar_array=', sign(4 + n, [-1_ik18, 1_ik18] * (n + 1))
  else
    write(*,'(A)') 'array_array=UNSUPPORTED'
    write(*,'(A)') 'scalar_array=UNSUPPORTED'
  end if
end program signIntrinsic_003

! CHECK: kinds_differ=T
! CHECK-NEXT: array_array= -1 2 -3
! CHECK-NEXT: scalar_array= -4 4
