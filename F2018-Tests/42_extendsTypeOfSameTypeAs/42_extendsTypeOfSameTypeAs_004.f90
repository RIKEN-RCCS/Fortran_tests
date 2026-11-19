! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.16 [S1, S2, S3]

program extendsTypeOfSameTypeAs_004
  implicit none
  type :: t
    integer :: i = 0
  end type
  type, extends(t) :: e
    integer :: j = 0
  end type
  type :: h
    type(t), pointer :: p
  end type
  type(t) :: ot
  type(e) :: oe

  call run()
contains
  subroutine run()
    type(h) :: hv
    class(t), allocatable :: ce
    type(e), pointer :: pe
    allocate(e :: ce)
    write(*,'(A,L1)') 'same(hv%p,ot)=', same_type_as(hv%p, ot)
    write(*,'(A,L1)') 'ext(ce,hv%p)=', extends_type_of(ce, hv%p)
    write(*,'(A,L1)') 'same(ce,pe)=', same_type_as(ce, pe)
  end subroutine
end program extendsTypeOfSameTypeAs_004

! CHECK: same(hv%p,ot)=T
! CHECK-NEXT: ext(ce,hv%p)=T
! CHECK-NEXT: same(ce,pe)=T
