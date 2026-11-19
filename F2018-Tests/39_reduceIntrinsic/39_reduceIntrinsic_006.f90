! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.11 [S3, S8]


program reduce_006
  implicit none
  character(3) :: c(3)

  c = ['bca', 'abc', 'cab']
  write(*,'(A,A)') 'lexical_min=', reduce(c, smaller)
  write(*,'(A,I0)') 'result_len=', len(reduce(c, smaller))
contains
  pure character(3) function smaller(a, b)
    character(3), intent(in) :: a, b
    if (llt(b, a)) then
      smaller = b
    else
      smaller = a
    end if
  end function smaller
end program reduce_006
! CHECK: lexical_min=abc
! CHECK-NEXT: result_len=3
