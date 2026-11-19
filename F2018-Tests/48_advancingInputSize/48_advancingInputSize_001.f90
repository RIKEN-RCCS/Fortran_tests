! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.22 [S1, S2]

program advancingInputSize_001
  implicit none
  integer :: u, n, k
  character(5) :: c

  open(newunit=u, status='scratch', form='formatted', action='readwrite')
  write(u,'(A)') 'abcde123xyz'
  rewind(u)
  n = -1
  read(u,'(a5,i3)',size=n) c, k
  write(*,'(A,I0)') 'size_no_advance_spec=', n
  rewind(u)
  n = -1
  read(u,'(a5,i3)',advance='yes',size=n) c, k
  write(*,'(A,I0)') 'size_advance_yes=', n
  write(*,'(A,A,A,I0)') 'values=', c, ' ', k
  close(u)
end program advancingInputSize_001

! CHECK: size_no_advance_spec=8
! CHECK-NEXT: size_advance_yes=8
! CHECK-NEXT: values=abcde 123
