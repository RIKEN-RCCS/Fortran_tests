! RUN: %if flang %{ %flang %s -o %t %}
! RUN: %if flang %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if flang %{ FileCheck %s < %t.out %}
! RUN: %if flang %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if gfortran %{ %gfortran %s -o %t %}
! RUN: %if gfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if gfortran %{ FileCheck %s < %t.out %}
! RUN: %if gfortran %{ FileCheck --check-prefix=ST %s < %t.st %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t %}
! RUN: %if nvfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if nvfortran %{ FileCheck %s < %t.out %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=ST %s < %t.st %}

! SPEC: N2161 5.6 [S2, S4]

program formattedInputErrorConditions_e002
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  character(len=10) :: line
  character(len=80) :: msg
  integer :: ios, k

  line = '12'
  k = -1
  read(line, *, iostat=ios) k
  write(*,'(A,I0,A,I0)') 'control_list iostat=', ios, ' k=', k
  flush(output_unit)
  line = '1a2'
  msg = 'unchanged'
  read(line, *, iostat=ios, iomsg=msg) k
  write(*,'(A,L1)') 'list_letter_detected=', ios > 0 .and. msg /= 'unchanged'
  flush(output_unit)
end program formattedInputErrorConditions_e002

! CHECK: control_list iostat=0 k=12
! CHECK-NEXT: list_letter_detected=T
! ST: status=0
