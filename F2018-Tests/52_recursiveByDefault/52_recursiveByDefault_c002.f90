! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=": error:" %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not="Error:" %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not="NVFORTRAN-" %s %}

! SPEC: N2161 5.26 [S2, S4]

module m_r
  implicit none
contains
  non_recursive function square(n) result(r)
    integer, intent(in) :: n
    integer :: r
    r = n * n
  end function square
  non_recursive function nr(n) result(r)
    integer, intent(in) :: n
    integer :: r
    if (n <= 0) then
      r = 0
    else
! FLANG: .f90:[[@LINE+5]]:{{[0-9]+}}: error: NON_RECURSIVE procedure 'nr' cannot call itself
! FLANG: .f90:[[@LINE-7]]:{{[0-9]+}}: Declaration of 'nr'
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
      r = n + nr(n - 1)
    end if
  end function nr
end module m_r
