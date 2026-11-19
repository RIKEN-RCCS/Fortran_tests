! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S2, S3, S4]

module assumedRank_001_m
  implicit none
contains
  subroutine show(label, a)
    character(*), intent(in) :: label
    real, intent(in) :: a(..)
    write(*,'(A,A,I0,A,I0,A,*(I0,:,","))') label, ' rank=', rank(a), ' size=', size(a), &
      ' shape=', shape(a)
  end subroutine show
end module assumedRank_001_m

program assumedRank_001
  use assumedRank_001_m
  implicit none
  real :: s
  real, allocatable :: v(:), w(:,:)
  integer :: n

  n = command_argument_count()
  s = 1.0 + n
  allocate(v(4 + n), w(2 + n, 3 + n))
  v = 0.0
  w = 0.0

  write(*,'(A,L1)') 'rank_kind_default=', kind(rank(v)) == kind(0)
  call show('scalar', s)
  call show('rank1', v)
  call show('rank2', w)
end program assumedRank_001
! CHECK: rank_kind_default=T
! CHECK-NEXT: scalar rank=0 size=1 shape={{$}}
! CHECK-NEXT: rank1 rank=1 size=4 shape=4{{$}}
! CHECK-NEXT: rank2 rank=2 size=6 shape=2,3{{$}}
