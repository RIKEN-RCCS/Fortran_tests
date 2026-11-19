! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.10 [S2, S3, S5]


program adjacentNumbers_004
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x, big
  logical :: datatype_supported, inf_supported

  x = 1.0 + command_argument_count()
  big = huge(x) - command_argument_count()
  datatype_supported = ieee_support_datatype(x)
  inf_supported = ieee_support_inf(x)
  write(*,'(A,L1)') 'datatype_supported=', datatype_supported
  write(*,'(A,L1)') 'inf_supported=', inf_supported
  if (datatype_supported .and. inf_supported) then
    write(*,'(A,L1)') 'next_up(huge)_is_pos_inf=', &
         ieee_class(ieee_next_up(big)) == ieee_positive_inf
    write(*,'(A,L1)') 'next_down(-huge)_is_neg_inf=', &
         ieee_class(ieee_next_down(-big)) == ieee_negative_inf
  else
    write(*,'(A)') 'next_up(huge)_is_pos_inf=UNSUPPORTED'
    write(*,'(A)') 'next_down(-huge)_is_neg_inf=UNSUPPORTED'
  end if
end program adjacentNumbers_004
! CHECK: datatype_supported=T
! CHECK-NEXT: inf_supported=T
! CHECK-NEXT: next_up(huge)_is_pos_inf=T
! CHECK-NEXT: next_down(-huge)_is_neg_inf=T
