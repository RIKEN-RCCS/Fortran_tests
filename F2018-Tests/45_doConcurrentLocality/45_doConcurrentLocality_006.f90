! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.19 [S1, S2]

program doConcurrentLocality_006
  implicit none
  integer, target :: tg(4) = [10, 20, 30, 40]
  integer, pointer :: p
  integer :: i, n, r(4)

  n = command_argument_count()
  p => tg(1 + n)
  do concurrent (i = 1:4) local_init(p)
    r(i) = p
    p => tg(i)
  end do
  write(*,'(A,3(I0,1X),I0)') 'r=', r
  write(*,'(A,L1)') 'outer_p_assoc_tg1=', associated(p, tg(1))
end program doConcurrentLocality_006

! CHECK: r=10 10 10 10
! CHECK-NEXT: outer_p_assoc_tg1=T
