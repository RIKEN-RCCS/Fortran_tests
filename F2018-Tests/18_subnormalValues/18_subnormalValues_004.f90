! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.1 [S1, S3], 4.10 [S2, S4]


program subnormalValues_004
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x, smallest_normal, below
  logical :: subnormal_supported, datatype_supported

  x = 1.0 + command_argument_count()
  subnormal_supported = ieee_support_subnormal(x)
  datatype_supported = ieee_support_datatype(x)
  write(*,'(A,L1)') 'subnormal_supported=', subnormal_supported
  write(*,'(A,L1)') 'datatype_supported=', datatype_supported

  smallest_normal = tiny(x)
  if (subnormal_supported .and. datatype_supported) then
    below = ieee_next_down(smallest_normal)
  else
    below = smallest_normal
  end if

  write(*,'(A,L1)') 'below_tiny_lt_tiny=', below < smallest_normal
  write(*,'(A,L1)') 'below_tiny_is_positive_subnormal=', &
       ieee_class(below) == ieee_positive_subnormal
  write(*,'(A,L1)') 'tiny_is_positive_normal=', &
       ieee_class(smallest_normal) == ieee_positive_normal
end program subnormalValues_004
! CHECK: subnormal_supported=T
! CHECK-NEXT: datatype_supported=T
! CHECK-NEXT: below_tiny_lt_tiny=T
! CHECK-NEXT: below_tiny_is_positive_subnormal=T
! CHECK-NEXT: tiny_is_positive_normal=T
