! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.10 [S2, S3, S5]


program adjacentNumbers_002
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x, pos_inf, neg_inf, qnan
  logical :: datatype_supported, inf_supported, nan_supported

  x = 1.0 + command_argument_count()
  datatype_supported = ieee_support_datatype(x)
  inf_supported = ieee_support_inf(x)
  nan_supported = ieee_support_nan(x)
  write(*,'(A,L1)') 'datatype_supported=', datatype_supported
  write(*,'(A,L1)') 'inf_supported=', inf_supported
  write(*,'(A,L1)') 'nan_supported=', nan_supported

  if (inf_supported) then
    pos_inf = ieee_value(x, ieee_positive_inf)
    neg_inf = ieee_value(x, ieee_negative_inf)
  else
    pos_inf = huge(x)
    neg_inf = -huge(x)
  end if
  if (nan_supported) then
    qnan = ieee_value(x, ieee_quiet_nan)
  else
    qnan = x
  end if

  write(*,'(A,L1)') 'next_up_of_pos_inf_eq_pos_inf=', ieee_next_up(pos_inf) == pos_inf
  write(*,'(A,L1)') 'next_down_of_neg_inf_eq_neg_inf=', ieee_next_down(neg_inf) == neg_inf
  write(*,'(A,L1)') 'next_down_of_pos_inf_eq_huge=', ieee_next_down(pos_inf) == huge(x)
  write(*,'(A,L1)') 'next_up_of_neg_inf_eq_minus_huge=', ieee_next_up(neg_inf) == -huge(x)
  write(*,'(A,L1)') 'next_up_of_qnan_is_nan=', ieee_is_nan(ieee_next_up(qnan))
  write(*,'(A,L1)') 'next_down_of_qnan_is_nan=', ieee_is_nan(ieee_next_down(qnan))
end program adjacentNumbers_002
! CHECK: datatype_supported=T
! CHECK-NEXT: inf_supported=T
! CHECK-NEXT: nan_supported=T
! CHECK-NEXT: next_up_of_pos_inf_eq_pos_inf=T
! CHECK-NEXT: next_down_of_neg_inf_eq_neg_inf=T
! CHECK-NEXT: next_down_of_pos_inf_eq_huge=T
! CHECK-NEXT: next_up_of_neg_inf_eq_minus_huge=T
! CHECK-NEXT: next_up_of_qnan_is_nan=T
! CHECK-NEXT: next_down_of_qnan_is_nan=T
