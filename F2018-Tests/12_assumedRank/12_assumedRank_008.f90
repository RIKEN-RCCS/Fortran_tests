! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S3, S4, S6, S7, S8, S9]

module assumedRank_008_m
  implicit none
contains
  subroutine classify(a)
    integer, intent(in) :: a(..)
    blk: select rank (x => a)
    rank (0) blk
      write(*,'(A,I0)') 'blk rank(0) x=', x
    rank (1) blk
      write(*,'(A,*(I0,:,","))') 'blk rank(1) x=', x
    rank (*) blk
      write(*,'(A,I0,A,I0)') 'blk rank(*) x(1)=', x(1), ' x(4)=', x(4)
    rank default blk
      write(*,'(A,I0)') 'blk default rank=', rank(x)
    end select blk
  end subroutine classify
  subroutine caller(b)
    integer, intent(in) :: b(3, *)
    call classify(b)
  end subroutine caller
end module assumedRank_008_m

program assumedRank_008
  use assumedRank_008_m
  implicit none
  integer :: s, n, i
  integer, allocatable :: v(:), w(:,:)

  n = command_argument_count()
  s = 7 + n
  allocate(v(2 + n), w(3 + n, 2 + n))
  v = [8, 9] + n
  w = reshape([(i + n, i = 1, 6)], [3, 2])
  call classify(s)
  call classify(v)
  call classify(w)
  call caller(w)
end program assumedRank_008
! CHECK: blk rank(0) x=7
! CHECK-NEXT: blk rank(1) x=8,9
! CHECK-NEXT: blk default rank=2
! CHECK-NEXT: blk rank(*) x(1)=1 x(4)=4
