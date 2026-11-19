! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.4 [S3, S6]

program inquireEnhancements_003
  use, intrinsic :: iso_fortran_env, only: file_storage_size
  implicit none
  integer :: u, id, p, s, ios, n, i
  integer, asynchronous :: v(100)

  v = [(i, i = 1, 100)]
  n = storage_size(0) / file_storage_size * 100
  open(newunit=u, status='scratch', access='stream', form='unformatted', &
       asynchronous='yes')
  write(u, asynchronous='yes', id=id) v
  inquire(u, pos=p, size=s)
  write(*,'(A,L1)') 'pos_after_pending=', p == n + 1
  write(*,'(A,L1)') 'size_after_pending=', s == n
  wait(u, id=id, iostat=ios)
  write(*,'(A,L1)') 'wait_ok=', ios == 0
  close(u)
end program inquireEnhancements_003

! CHECK: pos_after_pending=T
! CHECK-NEXT: size_after_pending=T
! CHECK-NEXT: wait_ok=T
