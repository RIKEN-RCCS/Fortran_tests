! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.31 [S1, S2, S3, S4, S5]


program statVariablePrecision_002
  implicit none
  integer, parameter :: k2 = selected_int_kind(2)
  integer, parameter :: k18 = selected_int_kind(18)
  integer, allocatable :: x(:)
  integer(k2) :: s2
  integer(k18) :: s18
  integer :: n
  logical :: ok, representable
  n = 3 + command_argument_count()

  allocate(x(n), stat=s2)
  write(*,'(A,I0)') 'k2_alloc=', s2
  deallocate(x, stat=s2)
  write(*,'(A,I0)') 'k2_dealloc=', s2

  allocate(x(n))
  allocate(x(n), stat=s18)
  representable = s18 <= huge(0_k2)
  write(*,'(A,L1)') 'k2_alloc_again_representable=', representable
  ok = .true.
  if (representable) then
    allocate(x(n), stat=s2)
    ok = s2 > 0
  end if
  write(*,'(A,L1)') 'k2_alloc_again_positive_if_representable=', ok

  deallocate(x)
  deallocate(x, stat=s18)
  representable = s18 <= huge(0_k2)
  write(*,'(A,L1)') 'k2_dealloc_again_representable=', representable
  ok = .true.
  if (representable) then
    deallocate(x, stat=s2)
    ok = s2 > 0
  end if
  write(*,'(A,L1)') 'k2_dealloc_again_positive_if_representable=', ok
end program statVariablePrecision_002
! CHECK: k2_alloc=0
! CHECK-NEXT: k2_dealloc=0
! CHECK-NEXT: k2_alloc_again_representable={{[TF]}}
! CHECK-NEXT: k2_alloc_again_positive_if_representable=T
! CHECK-NEXT: k2_dealloc_again_representable={{[TF]}}
! CHECK-NEXT: k2_dealloc_again_positive_if_representable=T
