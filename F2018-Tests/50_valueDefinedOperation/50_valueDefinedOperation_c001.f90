! RUN: %if flang %{ %flang -c %s -o %t.o > %t.log 2>&1 || true %}
! RUN: %if flang %{ FileCheck --check-prefix=FLANG --implicit-check-not='warning:' --implicit-check-not='error:' %s < %t.log %}
! RUN: %if gfortran %{ %gfortran -c %s -o %t.o > %t.log 2>&1 || true %}
! RUN: %if gfortran %{ FileCheck --check-prefix=GFORT --implicit-check-not='Error:' --implicit-check-not='Warning:' %s < %t.log %}
! RUN: %if nvfortran %{ %nvfortran -c %s -o %t.o > %t.log 2>&1 || true %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-' %s < %t.log %}

! SPEC: N2161 5.24 [S1, S5]

module m_v
  implicit none
  type :: t
    integer :: n
  end type t
  interface operator(.neg.)
    module procedure neg_t
  end interface
! NVFORT: NVFORTRAN-{{[SW]}}-{{[0-9]+}}-{{.*}}'bad_t'
! FLANG: .f90:[[@LINE+2]]:{{[0-9]+}}: warning: In .BAD. function 'bad_t', dummy argument 'a' should have INTENT(IN) or VALUE attribute
  interface operator(.bad.)
    module procedure bad_t
  end interface
contains
  function neg_t(a) result(r)
    type(t), value :: a
    type(t) :: r
    a%n = -a%n
    r = a
  end function neg_t
! FLANG: .f90:[[@LINE+3]]:{{[0-9]+}}: Declaration of 'bad_t'
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error: First argument of operator interface at (1) must be INTENT(IN)
  function bad_t(a) result(r)
    type(t) :: a
    type(t) :: r
    r = a
  end function bad_t
end module m_v
