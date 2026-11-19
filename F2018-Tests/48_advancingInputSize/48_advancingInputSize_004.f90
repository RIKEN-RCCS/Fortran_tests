! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.22 [S1, S2, S4]

program advancingInputSize_004
  implicit none
  integer :: u, n, k
  character(3) :: c

  open(newunit=u, status='scratch', form='formatted', action='readwrite')
  write(u,'(A)') 'zzabc'
  write(u,'(A)') '45'
  rewind(u)
  n = -1
  read(u,'(2x,a3/i2)',size=n) c, k
  write(*,'(A,I0)') 'size_x_and_slash=', n
  close(u)
end program advancingInputSize_004

! CHECK: size_x_and_slash=5
