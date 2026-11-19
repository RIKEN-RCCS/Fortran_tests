! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.9 [S1, S3, S6]

program computingEnvironmentIntrinsics_006
  implicit none
  integer :: n, s
  logical :: ok
  character(1) :: c
  character(64) :: em

  call get_environment_variable('PATH', length=n, status=s)
  ok = s == 0 .and. n >= 2
  write(*,'(A,L1)') 'path_len_ok=', ok
  if (ok) then
    em = 'UNCHANGED'
    call get_environment_variable('PATH', c, n, s, .true., em)
    write(*,'(A,I0)') 'status=', s
    write(*,'(A,L1)') 'errmsg_unchanged=', em == 'UNCHANGED'
  else
    write(*,'(A)') 'status=UNSUPPORTED'
    write(*,'(A)') 'errmsg_unchanged=UNSUPPORTED'
  end if
end program computingEnvironmentIntrinsics_006

! CHECK: path_len_ok=T
! CHECK-NEXT: status=-1
! CHECK-NEXT: errmsg_unchanged=T
