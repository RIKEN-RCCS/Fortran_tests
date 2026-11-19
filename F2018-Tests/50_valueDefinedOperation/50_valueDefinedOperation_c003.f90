! RUN: %if flang %{ %flang -c %s -o %t.o > %t.log 2>&1 || true %}
! RUN: %if flang %{ FileCheck --check-prefix=FLANG --implicit-check-not='warning:' --implicit-check-not='error:' %s < %t.log %}
! RUN: %if gfortran %{ %gfortran -c %s -o %t.o > %t.log 2>&1 || true %}
! RUN: %if gfortran %{ FileCheck --check-prefix=GFORT --implicit-check-not='Error:' --implicit-check-not='Warning:' %s < %t.log %}
! RUN: %if nvfortran %{ %nvfortran -c %s -o %t.o > %t.log 2>&1 || true %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-' %s < %t.log %}

! SPEC: N2161 5.24 [S4]

module m_v
  implicit none
  type :: t
    integer :: n
  end type t
  interface operator(.neg.)
    module procedure neg_t
  end interface
! NVFORT: NVFORTRAN-{{[SW]}}-{{[0-9]+}}-{{.*}}'assign_val'
! FLANG: .f90:[[@LINE+2]]:{{[0-9]+}}: warning: In defined assignment subroutine 'assign_val', first dummy argument 'lhs' should have INTENT(OUT) or INTENT(INOUT)
  interface assignment(=)
    module procedure assign_val
  end interface
contains
  function neg_t(a) result(r)
    type(t), value :: a
    type(t) :: r
    a%n = -a%n
    r = a
  end function neg_t
! FLANG: .f90:[[@LINE+3]]:{{[0-9]+}}: Declaration of 'assign_val'
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error: First argument of defined assignment at (1) must be INTENT(OUT) or INTENT(INOUT)
  subroutine assign_val(lhs, rhs)
    type(t), value :: lhs
    integer, intent(in) :: rhs
    lhs%n = rhs
  end subroutine assign_val
end module m_v
