! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S6]


program testSign_007
  implicit none
  real :: neg
  logical :: supported

  neg = -1.5 - command_argument_count()
  block
    use ieee_arithmetic, only: ieee_support_datatype
    supported = ieee_support_datatype(neg)
  end block
  write(*,'(A,L1)') 'datatype_supported=', supported
  if (supported) then
    block
      use ieee_arithmetic, only: ieee_signbit
      write(*,'(A,L1)') 'use_only: signbit(-1.5)=', ieee_signbit(neg)
    end block
    block
      use ieee_arithmetic, only: sb => ieee_signbit
      write(*,'(A,L1)') 'use_rename: sb(-1.5)=', sb(neg)
    end block
    block
      use, intrinsic :: ieee_arithmetic
      write(*,'(A,L1)') 'use_intrinsic: signbit(-1.5)=', ieee_signbit(neg)
      write(*,'(A,L1)') 'keyword: signbit(x=-1.5)=', ieee_signbit(x=neg)
    end block
  else
    write(*,'(A)') 'use_only: signbit(-1.5)=UNSUPPORTED'
    write(*,'(A)') 'use_rename: sb(-1.5)=UNSUPPORTED'
    write(*,'(A)') 'use_intrinsic: signbit(-1.5)=UNSUPPORTED'
    write(*,'(A)') 'keyword: signbit(x=-1.5)=UNSUPPORTED'
  end if
end program testSign_007
! CHECK: datatype_supported=T
! CHECK-NEXT: use_only: signbit(-1.5)=T
! CHECK-NEXT: use_rename: sb(-1.5)=T
! CHECK-NEXT: use_intrinsic: signbit(-1.5)=T
! CHECK-NEXT: keyword: signbit(x=-1.5)=T
