! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.25 [S2, S4]

module m_cproc
  use, intrinsic :: iso_c_binding
  implicit none
  abstract interface
    pure function int_fn(x) result(r) bind(c)
      import :: c_int
      integer(c_int), value :: x
      integer(c_int) :: r
    end function int_fn
  end interface
contains
  pure function triple(x) result(r) bind(c)
    integer(c_int), value :: x
    integer(c_int) :: r
    r = 3 * x
  end function triple

  pure function call_via(p, k) result(r)
    type(c_funptr), intent(in) :: p
    integer(c_int), intent(in) :: k
    integer(c_int) :: r
    procedure(int_fn), pointer :: fp
    call c_f_procpointer(p, fp)
    r = fp(k)
  end function call_via
end module m_cproc

program pureProcedureAnomalies_005
  use m_cproc
  implicit none
  integer(c_int) :: k

  k = 4 + command_argument_count()
  write(*,'(A,I0)') 'c_f_procpointer=', call_via(c_funloc(triple), k)
end program pureProcedureAnomalies_005

! CHECK: c_f_procpointer=12
