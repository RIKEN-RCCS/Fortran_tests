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

! SPEC: N2161 5.26 [S2, S4]

module m_r
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
contains
  non_recursive subroutine na(n)
    integer, intent(in) :: n
    if (n == 1) then
      write(*,'(A,L1)') 'nr_indirect_not_detected=', .true.
      flush(output_unit)
    end if
    call nb(n)
  end subroutine na
  subroutine nb(n)
    integer, intent(in) :: n
    if (n > 0) call na(n - 1)
  end subroutine nb
end module m_r

program recursiveByDefault_e001
  use m_r
  implicit none
  integer :: n

  n = command_argument_count()
  call na(n)
  write(*,'(A,L1)') 'na_without_recursion=', .true.
  flush(output_unit)
  call na(2 + n)
end program recursiveByDefault_e001

! CHECK: na_without_recursion=T
! ST: status={{[1-9][0-9]*}}
