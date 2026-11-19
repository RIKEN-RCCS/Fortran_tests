! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.4 [S1, S2, S5]

program inquireEnhancements_002
  implicit none
  integer :: r, us, uf, uq

  open(newunit=us, status='scratch', access='stream', form='unformatted')
  open(newunit=uf, status='scratch', access='stream', form='formatted')
  open(newunit=uq, status='scratch', access='sequential', form='formatted')
  r = 12345
  inquire(us, recl=r)
  write(*,'(A,I0)') 'recl_stream_unformatted=', r
  r = 12345
  inquire(uf, recl=r)
  write(*,'(A,I0)') 'recl_stream_formatted=', r
  r = -12345
  inquire(uq, recl=r)
  write(*,'(A,L1)') 'recl_sequential_positive=', r > 0
  close(us)
  close(uf)
  close(uq)
end program inquireEnhancements_002

! CHECK: recl_stream_unformatted=-2
! CHECK-NEXT: recl_stream_formatted=-2
! CHECK-NEXT: recl_sequential_positive=T
