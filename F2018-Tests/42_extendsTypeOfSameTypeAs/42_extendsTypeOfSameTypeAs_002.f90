! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.16 [S1, S2, S3]

program extendsTypeOfSameTypeAs_002
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
    write(*,'(A,L1)') 'same(pt,pe)=', same_type_as(pt, pe)
    write(*,'(A,L1)') 'ext(pe,pt)=', extends_type_of(pe, pt)
    write(*,'(A,L1)') 'ext(pt,pt)=', extends_type_of(pt, pt)
  end subroutine
end program extendsTypeOfSameTypeAs_002

! CHECK: same(pt,pe)=F
! CHECK-NEXT: ext(pe,pt)=T
! CHECK-NEXT: ext(pt,pt)=T
