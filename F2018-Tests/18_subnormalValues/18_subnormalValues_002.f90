! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.1 [S1, S3]


program subnormalValues_002
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x, divisor, pos, neg
  logical :: supported

  x = 1.0 + command_argument_count()
  divisor = 2.0 + command_argument_count()

  supported = ieee_support_subnormal(x)
  write(*,'(A,L1)') 'subnormal_supported=', supported

  if (supported) then
    pos = tiny(x) / divisor
    neg = -tiny(x) / divisor
  else
    pos = tiny(x)
    neg = -tiny(x)
  end if

  write(*,'(A,L1)') 'class_positive_subnormal=', &
       ieee_class(pos) == ieee_positive_subnormal
  write(*,'(A,L1)') 'class_negative_subnormal=', &
       ieee_class(neg) == ieee_negative_subnormal
end program subnormalValues_002
! CHECK: subnormal_supported=T
! CHECK-NEXT: class_positive_subnormal=T
! CHECK-NEXT: class_negative_subnormal=T
