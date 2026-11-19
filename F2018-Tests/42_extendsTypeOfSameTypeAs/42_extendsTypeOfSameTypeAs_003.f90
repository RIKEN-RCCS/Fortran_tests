! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.16 [S1, S2, S3]

program extendsTypeOfSameTypeAs_003
  implicit none
  type :: t
    integer :: i = 0
  end type
  type, extends(t) :: e
    integer :: j = 0
  end type
  type(t) :: ot
  type(e) :: oe

  call run()
contains
  subroutine run()
    type(t), pointer :: pt
    type(e), pointer :: pe
    type(e), target :: te
    pt => null()
    pe => te
    write(*,'(A,L1)') 'same(null_pt,ot)=', same_type_as(pt, ot)
    write(*,'(A,L1)') 'ext(assoc_pe,ot)=', extends_type_of(pe, ot)
  end subroutine
end program extendsTypeOfSameTypeAs_003

! CHECK: same(null_pt,ot)=T
! CHECK-NEXT: ext(assoc_pe,ot)=T
