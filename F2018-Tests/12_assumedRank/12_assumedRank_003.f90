! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S3, S4, S6, S7, S8]

module assumedRank_003_m
  implicit none
contains
  subroutine classify(a)
    integer, intent(in) :: a(..)
    select rank (a)
    rank (0)
      write(*,'(A,I0)') 'rank(0) value=', a
    rank (1)
      write(*,'(A,*(I0,:,","))') 'rank(1) values=', a
    rank (2)
      write(*,'(A,I0,A,I0)') 'rank(2) size=', size(a), ' a(2,1)=', a(2,1)
    rank default
      write(*,'(A,I0)') 'default rank=', rank(a)
    end select
  end subroutine classify
  subroutine caller(b)
    integer, intent(in) :: b(2, *)
    call classify(b)
  end subroutine caller
end module assumedRank_003_m

program assumedRank_003
  use assumedRank_003_m
  implicit none
  integer :: s, n
  integer, allocatable :: v(:), w(:,:), t(:,:,:)

  n = command_argument_count()
  s = 5 + n
  allocate(v(3 + n), w(2 + n, 2 + n), t(2 + n, 2 + n, 2 + n))
  v = [10, 20, 30] + n
  w = reshape([1, 2, 3, 4] + n, [2, 2])
  t = 0
  call classify(s)
  call classify(v)
  call classify(w)
  call classify(t)
  call caller(w)
end program assumedRank_003
! CHECK: rank(0) value=5
! CHECK-NEXT: rank(1) values=10,20,30
! CHECK-NEXT: rank(2) size=4 a(2,1)=2
! CHECK-NEXT: default rank=3
! CHECK-NEXT: default rank=2
