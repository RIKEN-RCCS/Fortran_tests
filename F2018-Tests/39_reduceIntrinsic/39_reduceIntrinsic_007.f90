! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.11 [S3, S8]


program reduce_007
  implicit none
  type :: mat2
    integer :: e(2, 2)
  end type mat2
  type(mat2) :: p, q, r

  p%e = reshape([1, 0, 1, 1], [2, 2])
  q%e = reshape([1, 1, 0, 1], [2, 2])
  r = reduce([p, q], mul)
  write(*,'(A,I0,3(1X,I0))') 'matmul_order=', r%e(1, 1), r%e(1, 2), r%e(2, 1), r%e(2, 2)
contains
  pure type(mat2) function mul(a, b)
    type(mat2), intent(in) :: a, b
    mul%e = matmul(a%e, b%e)
  end function mul
end program reduce_007
! CHECK: matmul_order=2 1 1 1
