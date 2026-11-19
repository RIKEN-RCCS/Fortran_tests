! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.25 [S2, S4]

module m_cfun
  use, intrinsic :: iso_c_binding
  implicit none
contains
  pure function triple(x) result(r) bind(c)
    integer(c_int), value :: x
    integer(c_int) :: r
    r = 3 * x
  end function triple

  pure function negate(x) result(r) bind(c)
    integer(c_int), value :: x
    integer(c_int) :: r
    r = -x
  end function negate

  pure function same_funloc(p) result(r)
    type(c_funptr), intent(in) :: p
    logical :: r
    r = c_associated(c_funloc(triple), p)
  end function same_funloc
end module m_cfun

program pureProcedureAnomalies_004
  use m_cfun
  implicit none
  type(c_funptr) :: pt, pn

  pt = c_funloc(triple)
  pn = c_funloc(negate)
  write(*,'(A,L1)') 'c_funloc_same=', same_funloc(pt)
  write(*,'(A,L1)') 'c_funloc_other=', same_funloc(pn)
end program pureProcedureAnomalies_004

! CHECK: c_funloc_same=T
! CHECK-NEXT: c_funloc_other=F
