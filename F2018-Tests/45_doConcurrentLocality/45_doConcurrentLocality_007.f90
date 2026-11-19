! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.19 [S1, S2, S3, S6]

program doConcurrentLocality_007
  implicit none
  integer :: i, n, r(4)

  n = command_argument_count()
  block
    integer :: u
    integer :: v
    integer :: w
    v = 10 + n
    w = 100 + n
    do concurrent (i = 1:4) local(u) local_init(v) shared(w)
      u = i * 2
      r(i) = u + v + w
    end do
    write(*,'(A,3(I0,1X),I0)') 'block_vars=', r
    write(*,'(A,I0,1X,I0)') 'outer_v_w=', v, w
  end block
end program doConcurrentLocality_007

! CHECK: block_vars=112 114 116 118
! CHECK-NEXT: outer_v_w=10 100
