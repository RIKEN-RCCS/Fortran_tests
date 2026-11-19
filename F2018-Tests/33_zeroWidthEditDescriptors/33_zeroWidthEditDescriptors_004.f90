! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.5 [S3]

program zeroWidthEditDescriptors_004
  implicit none
  character(len=40) :: line
  integer :: i, j, n
  logical :: t, f
  character(len=3) :: c

  n = command_argument_count()
  i = 42 + n
  j = -7 - n
  t = n == 0
  f = n /= 0
  c = 'abc'
  write(line,'(ss,g0.3)') i
  write(*,'(A,A,A)') 'g0.3_int=[', trim(line), ']'
  write(line,'(ss,g0.3)') j
  write(*,'(A,A,A)') 'g0.3_int_neg=[', trim(line), ']'
  write(line,'(ss,g0.3)') t
  write(*,'(A,A,A)') 'g0.3_true=[', trim(line), ']'
  write(line,'(ss,g0.3)') f
  write(*,'(A,A,A)') 'g0.3_false=[', trim(line), ']'
  write(line,'(ss,g0.3)') c
  write(*,'(A,A,A)') 'g0.3_char=[', trim(line), ']'
end program zeroWidthEditDescriptors_004

! CHECK: g0.3_int=[42]
! CHECK-NEXT: g0.3_int_neg=[-7]
! CHECK-NEXT: g0.3_true=[T]
! CHECK-NEXT: g0.3_false=[F]
! CHECK-NEXT: g0.3_char=[abc]
