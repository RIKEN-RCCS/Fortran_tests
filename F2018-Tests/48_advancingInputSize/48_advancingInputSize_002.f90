! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.22 [S2]

program advancingInputSize_002
  implicit none
  integer :: u, n, k
  character(5) :: c

  open(newunit=u, status='scratch', form='formatted', action='readwrite')
  write(u,'(A)') 'abcde123xyz'
  rewind(u)
  n = -1
  read(u,'(a5,i3)',advance='no',size=n) c, k
  write(*,'(A,I0)') 'size_advance_no=', n
  close(u)
end program advancingInputSize_002

! CHECK: size_advance_no=8
