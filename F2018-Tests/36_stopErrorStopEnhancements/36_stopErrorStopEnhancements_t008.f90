! RUN: %if flang %{ %flang %s -o %t %}
! RUN: %if flang %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if flang %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if flang %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if flang %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}
! RUN: %if flang %{ bash -c 'test -s %t.err' %}
! RUN: %if gfortran %{ %gfortran %s -o %t %}
! RUN: %if gfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if gfortran %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if gfortran %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if gfortran %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}
! RUN: %if gfortran %{ bash -c 'test -s %t.err' %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t %}
! RUN: %if nvfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if nvfortran %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}
! RUN: %if nvfortran %{ bash -c 'test -s %t.err' %}

! SPEC: N2161 5.8 [S3, S6, S7]

program stopErrorStopEnhancements_t008
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: ieee_exceptions, only: ieee_overflow, ieee_support_flag, ieee_set_flag
  implicit none
  integer :: n0
  logical :: q
  n0 = command_argument_count()
  q = (n0 /= 0)
  if (.not. ieee_support_flag(ieee_overflow)) then
    write(*,'(A)') 'before_stop=UNSUPPORTED'
    stop
  end if
  call ieee_set_flag(ieee_overflow, .true.)
  write(*,'(A)') 'before_stop=T'
  flush(output_unit)
  stop, quiet=q
  write(*,'(A)') 'after_stop=T'
end program stopErrorStopEnhancements_t008

! OUT: before_stop=T
! ST: status={{([0-9]{1,2}|1[01][0-9]|12[0-7])$}}
! REC-ST: status=0
