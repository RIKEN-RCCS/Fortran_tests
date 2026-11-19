! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.22 [S1, S2]

program advancingInputSize_003
  implicit none
  integer :: u, n
  character(5) :: c

  open(newunit=u, status='scratch', form='formatted', action='readwrite')
  write(u,'(A)') 'abc'
  rewind(u)
  n = -1
  read(u,'(a5)',size=n) c
  write(*,'(A,I0)') 'size_padded=', n
  close(u)
end program advancingInputSize_003

! CHECK: size_padded=3
