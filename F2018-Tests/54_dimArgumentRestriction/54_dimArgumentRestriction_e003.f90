! RUN: %if flang %{ %flang %s -o %t > %t.log 2>&1 %}
! RUN: %if flang %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if flang %{ FileCheck --implicit-check-not=not_detected %s < %t.out %}
! RUN: %if flang %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if gfortran %{ %gfortran %s -o %t > %t.log 2>&1 %}
! RUN: %if gfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if gfortran %{ FileCheck --implicit-check-not=not_detected %s < %t.out %}
! RUN: %if gfortran %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t > %t.log 2>&1 %}
! RUN: %if nvfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if nvfortran %{ FileCheck --implicit-check-not=not_detected %s < %t.out %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=ST %s < %t.st %}

! SPEC: N2161 5.28 [S2, S5]

program dimArgumentRestriction_e003
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  integer :: a(2, 3)

  a = reshape([1, 2, 3, 4, 5, 6], [2, 3]) + command_argument_count()
  call control(1)
  call run()

contains
  subroutine control(d)
    integer, optional, intent(in) :: d
    write(*,'(A,*(I0,:,1X))') 'sum_dim_present=', sum(a, d)
    flush(output_unit)
  end subroutine

  subroutine run(d)
    integer, optional, intent(in) :: d
    integer, allocatable :: t(:)
    t = sum(a, d)
    write(*,'(A,L1)') 'sum_dim_absent_not_detected=', size(t) >= 0
    flush(output_unit)
  end subroutine
end program dimArgumentRestriction_e003

! CHECK: sum_dim_present=3 7 11
! ST: status={{[1-9][0-9]*}}
