! RUN: %if flang %{ %flang %s -o %t > %t.log 2>&1 || cp /bin/false %t %}
! RUN: %if flang %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if flang %{ FileCheck --implicit-check-not=not_detected %s < %t.out %}
! RUN: %if flang %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if gfortran %{ %gfortran %s -o %t > %t.log 2>&1 || cp /bin/false %t %}
! RUN: %if gfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if gfortran %{ FileCheck --implicit-check-not=not_detected %s < %t.out %}
! RUN: %if gfortran %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t > %t.log 2>&1 || cp /bin/false %t %}
! RUN: %if nvfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if nvfortran %{ FileCheck --implicit-check-not=not_detected %s < %t.out %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=ST %s < %t.st %}

! SPEC: N2161 5.28 [S3]

program dimArgumentRestriction_e001
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  integer :: a(2, 3)
  logical :: m(2, 3)
  integer, pointer :: pd => null()
  integer, allocatable :: c(:)
  integer :: d

  a = reshape([1, 2, 3, 4, 5, 6], [2, 3]) + command_argument_count()
  m = mod(a, 2) == 0
  d = 1 + command_argument_count()
  write(*,'(A,*(I0,:,1X))') 'count_dim_variable=', count(m, d)
  flush(output_unit)
  c = count(m, pd)
  write(*,'(A,L1)') 'count_dim_null_ptr_not_detected=', size(c) >= 0
  flush(output_unit)
end program dimArgumentRestriction_e001

! CHECK: count_dim_variable=1 1 1
! ST: status={{[1-9][0-9]*}}
