! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.9 [S1, S3]

program computingEnvironmentIntrinsics_003
  implicit none
  integer :: n, s
  logical :: ok
  character(1) :: c
  character(64) :: em

  call get_command_argument(0, length=n, status=s)
  ok = s == 0 .and. n >= 2
  write(*,'(A,L1)') 'name_len_ok=', ok
  if (ok) then
    em = 'UNCHANGED'
    call get_command_argument(0, c, n, s, em)
    write(*,'(A,I0)') 'status=', s
    write(*,'(A,L1)') 'errmsg_unchanged=', em == 'UNCHANGED'
  else
    write(*,'(A)') 'status=UNSUPPORTED'
    write(*,'(A)') 'errmsg_unchanged=UNSUPPORTED'
  end if
end program computingEnvironmentIntrinsics_003

! CHECK: name_len_ok=T
! CHECK-NEXT: status=-1
! CHECK-NEXT: errmsg_unchanged=T
