! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.22 [S3]

program advancingInputSize_006
  implicit none
  integer :: u, n, k, ios

  open(newunit=u, status='scratch', form='formatted', action='readwrite')
  write(u,'(A)') '  42'
  rewind(u)
  k = -1
  read(u,*,size=n,iostat=ios) k
  write(*,'(A,I0)') 'list_directed_iostat=', ios
  write(*,'(A,I0)') 'list_directed_value=', k
  close(u)
end program advancingInputSize_006

! CHECK: list_directed_iostat=0
! CHECK-NEXT: list_directed_value=42
