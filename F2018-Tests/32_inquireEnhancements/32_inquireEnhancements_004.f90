! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.4 [S3, S6]

program inquireEnhancements_004
  use, intrinsic :: iso_fortran_env, only: file_storage_size
  implicit none
  integer :: u, id, p, ios, n, i
  integer :: v(100)
  integer, asynchronous :: w(50)

  v = [(i, i = 1, 100)]
  n = storage_size(0) / file_storage_size * 50
  open(newunit=u, status='scratch', access='stream', form='unformatted', &
       asynchronous='yes')
  write(u) v
  read(u, pos=1, asynchronous='yes', id=id) w
  inquire(u, pos=p)
  write(*,'(A,L1)') 'pos_after_pending_read=', p == n + 1
  wait(u, id=id, iostat=ios)
  write(*,'(A,L1)') 'wait_ok=', ios == 0
  close(u)
end program inquireEnhancements_004

! CHECK: pos_after_pending_read=T
! CHECK-NEXT: wait_ok=T
