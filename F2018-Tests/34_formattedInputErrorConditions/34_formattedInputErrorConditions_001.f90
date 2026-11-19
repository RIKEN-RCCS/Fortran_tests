! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.6 [S5]

program formattedInputErrorConditions_001
  implicit none
  character(len=5) :: line
  integer :: ios, k
  logical :: b

  line = 'FOO  '
  b = .true.
  read(line, '(l5)', iostat=ios) b
  write(*,'(A,I0,A,L1)') 'l5_foo_iostat=', ios, ' l5_foo_value=', b
  line = '1 2'
  k = -1
  read(line, '(i3)', iostat=ios) k
  write(*,'(A,I0,A,I0)') 'i3_blank_iostat=', ios, ' i3_blank_value=', k
end program formattedInputErrorConditions_001

! CHECK: l5_foo_iostat=0 l5_foo_value=F
! CHECK-NEXT: i3_blank_iostat=0 i3_blank_value=12
