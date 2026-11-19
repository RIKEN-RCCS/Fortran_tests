! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S3, S10]

module assumedRank_005_m
  implicit none
contains
  subroutine show(a)
    integer, intent(in) :: a(..)
    write(*,'(A,I0)') 'rank=', rank(a)
    write(*,'(A,I0)') 'size(dim=rank)=', size(a, dim=rank(a))
    write(*,'(A,*(I0,:,","))') 'shape=', shape(a)
    write(*,'(A,I0)') 'size=', size(a)
    write(*,'(A,I0,A,I0)') 'final lbound=', lbound(a, rank(a)), ' ubound=', ubound(a, rank(a))
  end subroutine show
  subroutine caller(b)
    integer, intent(in) :: b(3, *)
    call show(b)
  end subroutine caller
end module assumedRank_005_m

program assumedRank_005
  use assumedRank_005_m
  implicit none
  integer :: v(3, 4)

  v = command_argument_count()
  call caller(v)
end program assumedRank_005
! CHECK: rank=2
! CHECK-NEXT: size(dim=rank)=-1
! CHECK-NEXT: shape=3,-1
! CHECK-NEXT: size=-3
! CHECK-NEXT: final lbound=1 ubound=-1
