! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.9 [S1, S5]

program computingEnvironmentIntrinsics_002
  implicit none
  integer :: n, s
  character(4096) :: c
  character(64) :: em

  em = 'UNCHANGED'
  call get_command(c, n, s, em)
  write(*,'(A,I0)') 'status=', s
  write(*,'(A,L1)') 'errmsg_unchanged=', em == 'UNCHANGED'
end program computingEnvironmentIntrinsics_002

! CHECK: status=0
! CHECK-NEXT: errmsg_unchanged=T
