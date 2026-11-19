! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.25 [S2, S4]

module m_cb
  use, intrinsic :: iso_c_binding
  implicit none
contains
  pure function is_associated(p) result(r)
    type(c_ptr), intent(in) :: p
    logical :: r
    r = c_associated(p)
  end function is_associated

  pure function size_matches(k) result(r)
    integer(c_int), intent(in) :: k
    logical :: r
    r = c_sizeof(k) == c_sizeof(0_c_int)
  end function size_matches

  pure function loc_associated(k) result(r)
    integer(c_int), intent(in) :: k
    logical :: r
    integer(c_int), target :: tg
    tg = k
    r = c_associated(c_loc(tg))
  end function loc_associated
end module m_cb

program pureProcedureAnomalies_002
  use m_cb
  implicit none
  integer(c_int) :: k

  k = 7 + command_argument_count()
  write(*,'(A,L1)') 'c_associated_null=', is_associated(c_null_ptr)
  write(*,'(A,L1)') 'c_sizeof_ok=', size_matches(k)
  write(*,'(A,L1)') 'c_loc_associated=', loc_associated(k)
end program pureProcedureAnomalies_002

! CHECK: c_associated_null=F
! CHECK-NEXT: c_sizeof_ok=T
! CHECK-NEXT: c_loc_associated=T
