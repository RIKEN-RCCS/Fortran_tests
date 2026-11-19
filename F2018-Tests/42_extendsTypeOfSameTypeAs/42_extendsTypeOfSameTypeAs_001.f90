! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.16 [S1, S2, S3]

program extendsTypeOfSameTypeAs_001
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
    write(*,'(A,L1)') 'same(pt,ot)=', same_type_as(pt, ot)
    write(*,'(A,L1)') 'same(pt,oe)=', same_type_as(pt, oe)
    write(*,'(A,L1)') 'same(oe,pe)=', same_type_as(oe, pe)
    write(*,'(A,L1)') 'ext(pe,ot)=', extends_type_of(pe, ot)
    write(*,'(A,L1)') 'ext(pt,oe)=', extends_type_of(pt, oe)
    write(*,'(A,L1)') 'ext(oe,pt)=', extends_type_of(oe, pt)
  end subroutine
end program extendsTypeOfSameTypeAs_001

! CHECK: same(pt,ot)=T
! CHECK-NEXT: same(pt,oe)=F
! CHECK-NEXT: same(oe,pe)=T
! CHECK-NEXT: ext(pe,ot)=T
! CHECK-NEXT: ext(pt,oe)=F
! CHECK-NEXT: ext(oe,pt)=T
