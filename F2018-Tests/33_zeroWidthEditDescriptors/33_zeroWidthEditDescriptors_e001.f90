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

! SPEC: N2161 5.5 [S2]

program zeroWidthEditDescriptors_e001
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  integer, parameter :: dp = selected_real_kind(15)
  real(dp) :: x
  character(len=40) :: line
  character(len=20) :: fmt
  character(len=80) :: msg
  integer :: ios

  line = '1.5'
  fmt = '(e3.1)'
  x = -1.0_dp
  read(line, fmt, iostat=ios) x
  write(*,'(A,I0,A,F0.1)') 'control_e3.1 iostat=', ios, ' x=', x
  flush(output_unit)
  fmt = '(e0.3)'
  msg = 'unchanged'
  read(line, fmt, iostat=ios, iomsg=msg) x
  write(*,'(A,L1)') 'e0.3_input_detected=', ios > 0 .and. msg /= 'unchanged'
  flush(output_unit)
end program zeroWidthEditDescriptors_e001

! CHECK: control_e3.1 iostat=0 x=1.5
! CHECK-NEXT: e0.3_input_detected=T
! ST: status=0
