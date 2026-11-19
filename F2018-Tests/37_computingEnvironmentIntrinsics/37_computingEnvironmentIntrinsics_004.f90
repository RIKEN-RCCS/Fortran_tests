! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.9 [S1, S2, S7]

program computingEnvironmentIntrinsics_004
  implicit none
  integer :: n, s
  character(64) :: c
  character(64) :: em

  em = 'UNCHANGED'
  call get_command_argument(command_argument_count() + 1, c, n, s, em)
  write(*,'(A,L1)') 'status_positive=', s > 0
  write(*,'(A,L1)') 'errmsg_changed=', em /= 'UNCHANGED'
end program computingEnvironmentIntrinsics_004

! CHECK: status_positive=T
! CHECK-NEXT: errmsg_changed=T
