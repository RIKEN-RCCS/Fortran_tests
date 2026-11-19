! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.15 [S1, S2]

program signIntrinsic_004
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: ik18 = selected_int_kind(18)
  integer :: n
  logical :: differ
  integer, parameter :: p = sign(7, -1_ik18)

  n = command_argument_count()
  differ = range(0_ik) < range(0_ik18)
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    write(*,'(A,I0)') 'parameter_value=', p + n
  else
    write(*,'(A)') 'parameter_value=UNSUPPORTED'
  end if
end program signIntrinsic_004

! CHECK: kinds_differ=T
! CHECK-NEXT: parameter_value=-7
