! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S3, S4, S5]

module assumedRank_002_m
  use, intrinsic :: iso_c_binding, only: c_ptr, c_loc, c_sizeof, c_associated
  implicit none
  type(c_ptr) :: expected
  real :: elem
contains
  subroutine outer(label, a)
    character(*), intent(in) :: label
    real, target, intent(in) :: a(..)
    write(*,'(A,A,L1,A,I0)') label, ' outer c_loc_same=', c_associated(c_loc(a), expected), &
      ' c_sizeof/elem=', c_sizeof(a) / c_sizeof(elem)
    call inner(label, a)
  end subroutine outer
  subroutine inner(label, a)
    character(*), intent(in) :: label
    real, target, intent(in) :: a(..)
    write(*,'(A,A,L1,A,I0,A,I0)') label, ' inner c_loc_same=', c_associated(c_loc(a), expected), &
      ' c_sizeof/elem=', c_sizeof(a) / c_sizeof(elem), ' rank=', rank(a)
  end subroutine inner
  subroutine loc_only(a)
    real, target, intent(in) :: a(..)
    write(*,'(A,L1,A,I0)') 'assumed-size c_loc_same=', c_associated(c_loc(a), expected), &
      ' rank=', rank(a)
  end subroutine loc_only
  subroutine caller(b)
    real, target, intent(in) :: b(3, *)
    call loc_only(b)
  end subroutine caller
end module assumedRank_002_m

program assumedRank_002
  use assumedRank_002_m
  implicit none
  real, target :: s
  real, allocatable, target :: v(:), w(:,:), t(:,:,:)
  integer :: n

  n = command_argument_count()
  s = 1.0 + n
  allocate(v(3 + n), w(2 + n, 3 + n), t(2 + n, 2 + n, 2 + n))
  v = 0.0
  w = 0.0
  t = 0.0
  expected = c_loc(s)
  call outer('scalar', s)
  expected = c_loc(v)
  call outer('rank1', v)
  expected = c_loc(w)
  call outer('rank2', w)
  expected = c_loc(t)
  call outer('rank3', t)
  expected = c_loc(w)
  call caller(w)
end program assumedRank_002
! CHECK: scalar outer c_loc_same=T c_sizeof/elem=1
! CHECK-NEXT: scalar inner c_loc_same=T c_sizeof/elem=1 rank=0
! CHECK-NEXT: rank1 outer c_loc_same=T c_sizeof/elem=3
! CHECK-NEXT: rank1 inner c_loc_same=T c_sizeof/elem=3 rank=1
! CHECK-NEXT: rank2 outer c_loc_same=T c_sizeof/elem=6
! CHECK-NEXT: rank2 inner c_loc_same=T c_sizeof/elem=6 rank=2
! CHECK-NEXT: rank3 outer c_loc_same=T c_sizeof/elem=8
! CHECK-NEXT: rank3 inner c_loc_same=T c_sizeof/elem=8 rank=3
! CHECK-NEXT: assumed-size c_loc_same=T rank=2
