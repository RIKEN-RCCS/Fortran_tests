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

! SPEC: N2161 5.6 [S1, S2]

program formattedInputErrorConditions_e001
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  character(len=10) :: line
  character(len=80) :: msg
  integer, parameter :: dp = selected_real_kind(15)
  integer :: ios, k
  real(dp) :: x
  logical :: b

  line = '123'
  k = -1
  read(line, '(i3)', iostat=ios) k
  write(*,'(A,I0,A,I0)') 'control_i3 iostat=', ios, ' k=', k
  flush(output_unit)
  line = '1a2'
  msg = 'unchanged'
  read(line, '(i3)', iostat=ios, iomsg=msg) k
  write(*,'(A,L1)') 'i3_letter_detected=', ios > 0 .and. msg /= 'unchanged'
  flush(output_unit)
  line = '1.5'
  x = -1.0_dp
  read(line, '(f5.1)', iostat=ios) x
  write(*,'(A,I0,A,F0.1)') 'control_f5.1 iostat=', ios, ' x=', x
  flush(output_unit)
  line = '1.2.3'
  msg = 'unchanged'
  read(line, '(f5.1)', iostat=ios, iomsg=msg) x
  write(*,'(A,L1)') 'f5.1_two_points_detected=', ios > 0 .and. msg /= 'unchanged'
  flush(output_unit)
  line = '1.5'
  x = -1.0_dp
  read(line, '(e4.1)', iostat=ios) x
  write(*,'(A,I0,A,F0.1)') 'control_e4.1 iostat=', ios, ' x=', x
  flush(output_unit)
  line = '1.5e'
  msg = 'unchanged'
  read(line, '(e4.1)', iostat=ios, iomsg=msg) x
  write(*,'(A,L1)') 'e4.1_no_exp_digit_detected=', ios > 0 .and. msg /= 'unchanged'
  flush(output_unit)
  line = 'T'
  b = .false.
  read(line, '(l1)', iostat=ios) b
  write(*,'(A,I0,A,L1)') 'control_l1 iostat=', ios, ' b=', b
  flush(output_unit)
  line = 'X'
  msg = 'unchanged'
  read(line, '(l1)', iostat=ios, iomsg=msg) b
  write(*,'(A,L1)') 'l1_x_detected=', ios > 0 .and. msg /= 'unchanged'
  flush(output_unit)
end program formattedInputErrorConditions_e001

! CHECK: control_i3 iostat=0 k=123
! CHECK-NEXT: i3_letter_detected=T
! CHECK-NEXT: control_f5.1 iostat=0 x=1.5
! CHECK-NEXT: f5.1_two_points_detected=T
! CHECK-NEXT: control_e4.1 iostat=0 x=1.5
! CHECK-NEXT: e4.1_no_exp_digit_detected=T
! CHECK-NEXT: control_l1 iostat=0 b=T
! CHECK-NEXT: l1_x_detected=T
! ST: status=0
