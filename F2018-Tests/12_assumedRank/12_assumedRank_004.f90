! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S4, S6, S7, S8]

module assumedRank_004_m
  implicit none
contains
  subroutine classify(a)
    integer, intent(in) :: a(..)
    select rank (a)
    rank (*)
      write(*,'(A,I0,A,I0)') 'rank(*) a(1)=', a(1), ' a(4)=', a(4)
    rank (2)
      write(*,'(A,I0)') 'rank(2) size=', size(a)
    rank default
      write(*,'(A,I0)') 'default rank=', rank(a)
    end select
  end subroutine classify
  subroutine caller(b)
    integer, intent(in) :: b(3, *)
    call classify(b)
  end subroutine caller
end module assumedRank_004_m

program assumedRank_004
  use assumedRank_004_m
  implicit none
  integer :: v(3, 4), i, n

  n = command_argument_count()
  v = reshape([(i + n, i = 1, 12)], [3, 4])
  call caller(v)
  call classify(v)
end program assumedRank_004
! CHECK: rank(*) a(1)=1 a(4)=4
! CHECK-NEXT: rank(2) size=12
