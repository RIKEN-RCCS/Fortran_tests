! RUN: %if flang %{ %flang %s -o %t %}
! RUN: %if flang %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if flang %{ FileCheck --implicit-check-not=after_reduce %s < %t.out %}
! RUN: %if flang %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if gfortran %{ %gfortran %s -o %t %}
! RUN: %if gfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if gfortran %{ FileCheck --implicit-check-not=after_reduce %s < %t.out %}
! RUN: %if gfortran %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t %}
! RUN: %if nvfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if nvfortran %{ FileCheck --implicit-check-not=after_reduce %s < %t.out %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=ST %s < %t.st %}

! SPEC: N2161 5.11 [S6]


program reduce_t001
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  integer, allocatable :: e(:)
  integer :: n, r

  n = command_argument_count()
  allocate(e(n))
  write(*,'(A)') 'before_reduce=T'
  flush(output_unit)
  r = reduce(e, add)
  write(*,'(A,I0)') 'after_reduce=', r
  flush(output_unit)
contains
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
end program reduce_t001
! CHECK: before_reduce=T
! ST: status={{[1-9][0-9]*}}
