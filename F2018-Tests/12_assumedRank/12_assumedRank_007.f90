! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.12 [S1, S6, S7]

module assumedRank_007_m
  implicit none
contains
  subroutine bounds(label, a)
    character(*), intent(in) :: label
    integer, intent(in) :: a(..)
    select rank (a)
    rank (1)
      write(*,'(A,A,I0,A,I0,A,I0)') label, ' lbound=', lbound(a, 1), ' ubound=', ubound(a, 1), &
        ' a(ubound)=', a(ubound(a, 1))
    rank default
      write(*,'(A,A,I0)') label, ' default rank=', rank(a)
    end select
    select rank (x => a)
    rank (1)
      write(*,'(A,A,I0,A,I0,A,I0)') label, ' x lbound=', lbound(x, 1), ' ubound=', ubound(x, 1), &
        ' x(ubound)=', x(ubound(x, 1))
    rank default
      write(*,'(A,A,I0)') label, ' x default rank=', rank(x)
    end select
  end subroutine bounds
  subroutine bounds_alloc(label, a)
    character(*), intent(in) :: label
    integer, allocatable, intent(in) :: a(..)
    select rank (a)
    rank (1)
      write(*,'(A,A,I0,A,I0,A,I0)') label, ' alloc lbound=', lbound(a, 1), ' ubound=', ubound(a, 1), &
        ' a(ubound)=', a(ubound(a, 1))
    rank default
      write(*,'(A,A,I0)') label, ' alloc default rank=', rank(a)
    end select
  end subroutine bounds_alloc
  subroutine bounds_ptr(label, a)
    character(*), intent(in) :: label
    integer, pointer, intent(in) :: a(..)
    select rank (a)
    rank (1)
      write(*,'(A,A,I0,A,I0,A,I0)') label, ' ptr lbound=', lbound(a, 1), ' ubound=', ubound(a, 1), &
        ' a(ubound)=', a(ubound(a, 1))
    rank default
      write(*,'(A,A,I0)') label, ' ptr default rank=', rank(a)
    end select
  end subroutine bounds_ptr
end module assumedRank_007_m

program assumedRank_007
  use assumedRank_007_m
  implicit none
  integer, allocatable, target :: u(:), v(:)
  integer, pointer :: pu(:), pv(:)
  integer :: n

  n = command_argument_count()
  allocate(u(3 + n), v(3 + n:5 + n))
  u = [10, 20, 30] + n
  v = [10, 20, 30] + n
  pu => u
  pv => v
  call bounds('from1', u)
  call bounds('from3', v)
  call bounds_alloc('from1', u)
  call bounds_alloc('from3', v)
  call bounds_ptr('from1', pu)
  call bounds_ptr('from3', pv)
end program assumedRank_007
! CHECK: from1 lbound=1 ubound=3 a(ubound)=30
! CHECK-NEXT: from1 x lbound=1 ubound=3 x(ubound)=30
! CHECK-NEXT: from3 lbound=1 ubound=3 a(ubound)=30
! CHECK-NEXT: from3 x lbound=1 ubound=3 x(ubound)=30
! CHECK-NEXT: from1 alloc lbound=1 ubound=3 a(ubound)=30
! CHECK-NEXT: from3 alloc lbound=3 ubound=5 a(ubound)=30
! CHECK-NEXT: from1 ptr lbound=1 ubound=3 a(ubound)=30
! CHECK-NEXT: from3 ptr lbound=3 ubound=5 a(ubound)=30
