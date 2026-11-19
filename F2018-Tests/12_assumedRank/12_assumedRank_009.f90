! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S3, S5, S6, S7, S8, S11]

module assumedRank_009_m
  implicit none
contains
  subroutine fill(a)
    integer, intent(out) :: a(..)
    select rank (a)
    rank (*)
      a(1) = 7 + command_argument_count()
      write(*,'(A)') 'fill block=rank(*)'
    rank (1)
      a(1) = 8 + command_argument_count()
      write(*,'(A)') 'fill block=rank(1)'
    rank default
      write(*,'(A,I0)') 'fill default rank=', rank(a)
    end select
  end subroutine fill
  subroutine via_size(b)
    integer :: b(*)
    call fill(b)
  end subroutine via_size
  subroutine via_rank(d)
    integer :: d(..)
    call fill(d)
  end subroutine via_rank
end module assumedRank_009_m

program assumedRank_009
  use assumedRank_009_m
  implicit none
  integer :: u(3), v(3), w(3)

  u = 0
  v = 0
  w = 0
  call fill(u)
  write(*,'(A,I0)') 'explicit u(1)=', u(1)
  call via_size(v)
  write(*,'(A,I0)') 'assumed-size v(1)=', v(1)
  call via_rank(w)
  write(*,'(A,I0)') 'assumed-rank w(1)=', w(1)
end program assumedRank_009
! CHECK: fill block=rank(1)
! CHECK-NEXT: explicit u(1)=8
! CHECK-NEXT: fill block=rank(*)
! CHECK-NEXT: assumed-size v(1)=7
! CHECK-NEXT: fill block=rank(1)
! CHECK-NEXT: assumed-rank w(1)=8
