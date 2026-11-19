! RUN: %if flang %{ %flang %s -o %t %}
! RUN: %if flang %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if flang %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if flang %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if flang %{ bash -c 'FileCheck --check-prefix=REC-ERR %s < %t.err > /dev/null 2>&1 || echo "recommended_differs: REC-ERR"' %}
! RUN: %if flang %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}
! RUN: %if gfortran %{ %gfortran %s -o %t %}
! RUN: %if gfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if gfortran %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if gfortran %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if gfortran %{ bash -c 'FileCheck --check-prefix=REC-ERR %s < %t.err > /dev/null 2>&1 || echo "recommended_differs: REC-ERR"' %}
! RUN: %if gfortran %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t %}
! RUN: %if nvfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if nvfortran %{ bash -c 'FileCheck --check-prefix=REC-ERR %s < %t.err > /dev/null 2>&1 || echo "recommended_differs: REC-ERR"' %}
! RUN: %if nvfortran %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}

! SPEC: N2161 5.8 [S1, S5, S6]

program stopErrorStopEnhancements_t002
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  integer :: n0
  n0 = command_argument_count()
  write(*,'(A)') 'before_stop=T'
  flush(output_unit)
  stop 'done_' // repeat('x', 1 + n0)
  write(*,'(A)') 'after_stop=T'
end program stopErrorStopEnhancements_t002

! OUT: before_stop=T
! ST: status={{([0-9]{1,2}|1[01][0-9]|12[0-7])$}}
! REC-ERR: done_x
! REC-ST: status=0
