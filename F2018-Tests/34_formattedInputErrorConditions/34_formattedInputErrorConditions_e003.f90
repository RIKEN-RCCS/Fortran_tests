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

! SPEC: N2161 5.6 [S1]

program formattedInputErrorConditions_e003
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  character(len=10) :: line
  integer :: k

  line = '1a2'
  write(*,'(A,L1)') 'before_read=', .true.
  flush(output_unit)
  read(line, '(i3)') k
  write(*,'(A,L1)') 'i3_letter_no_iostat_not_detected=', .true.
  flush(output_unit)
end program formattedInputErrorConditions_e003

! CHECK: before_read=T
! ST: status={{[1-9][0-9]*}}
