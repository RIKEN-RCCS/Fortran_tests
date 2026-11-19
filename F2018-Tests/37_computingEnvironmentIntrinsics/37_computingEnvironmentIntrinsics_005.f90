! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.9 [S1, S2, S6]

program computingEnvironmentIntrinsics_005
  implicit none
  integer :: n, s
  character(64) :: c
  character(64) :: em

  em = 'UNCHANGED'
  call get_environment_variable('F2018_TEST_NO_SUCH_VARIABLE_037', c, n, s, .true., em)
  write(*,'(A,L1)') 'env_supported=', s /= 2
  if (s /= 2) then
    write(*,'(A,I0)') 'status=', s
    write(*,'(A,I0)') 'length=', n
    write(*,'(A,L1)') 'errmsg_changed=', em /= 'UNCHANGED'
  else
    write(*,'(A)') 'status=UNSUPPORTED'
    write(*,'(A)') 'length=UNSUPPORTED'
    write(*,'(A)') 'errmsg_changed=UNSUPPORTED'
  end if
end program computingEnvironmentIntrinsics_005

! CHECK: env_supported=T
! CHECK-NEXT: status=1
! CHECK-NEXT: length=0
! CHECK-NEXT: errmsg_changed=T
