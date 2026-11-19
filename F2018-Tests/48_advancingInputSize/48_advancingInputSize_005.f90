! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.22 [S1, S3]

program advancingInputSize_005
  implicit none
  character(8) :: buf
  integer :: n, k
  character(5) :: c

  buf = 'abcde123'
  n = -1
  read(buf,'(a5,i3)',size=n) c, k
  write(*,'(A,I0)') 'size_internal=', n
end program advancingInputSize_005

! CHECK: size_internal=8
