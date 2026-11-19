! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.9 [S1, S5]

program computingEnvironmentIntrinsics_007
  implicit none
  integer :: s
  character(64) :: em

  em = 'UNCHANGED'
  call get_command(errmsg=em, status=s)
  write(*,'(A,I0)') 'status=', s
  write(*,'(A,L1)') 'errmsg_unchanged=', em == 'UNCHANGED'
end program computingEnvironmentIntrinsics_007

! CHECK: status=0
! CHECK-NEXT: errmsg_unchanged=T
