! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S3, S4, S5]

module assumedRank_006_m
  implicit none
contains
  subroutine inner(label, a)
    character(*), intent(in) :: label
    real, intent(in) :: a(..)
    write(*,'(A,A,I0,A,I0)') label, ' inner rank=', rank(a), ' size=', size(a)
  end subroutine inner
  subroutine outer(label, a)
    character(*), intent(in) :: label
    real, intent(in) :: a(..)
    call inner(label, a)
  end subroutine outer
end module assumedRank_006_m

program assumedRank_006
  use assumedRank_006_m
  implicit none
  real :: s
  real, allocatable :: v(:), w(:,:,:)
  integer :: n

  n = command_argument_count()
  s = 1.0 + n
  allocate(v(3 + n), w(2 + n, 2 + n, 2 + n))
  v = 0.0
  w = 0.0
  call outer('scalar', s)
  call outer('rank1', v)
  call outer('rank3', w)
end program assumedRank_006
! CHECK: scalar inner rank=0 size=1
! CHECK-NEXT: rank1 inner rank=1 size=3
! CHECK-NEXT: rank3 inner rank=3 size=8
