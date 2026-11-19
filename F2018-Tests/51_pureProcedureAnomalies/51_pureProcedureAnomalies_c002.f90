! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-' %s %}

! SPEC: N2161 5.25 [S2, S5]

module m_bad
  use, intrinsic :: iso_c_binding
  implicit none
contains
  pure function twice_plus_one(n) result(r)
    integer, value :: n
    integer :: r
    n = n * 2
    r = n + 1
  end function twice_plus_one

  pure subroutine deref(cp, v)
    type(c_ptr), intent(in) :: cp
    integer(c_int), intent(out) :: v
    integer(c_int), pointer :: fp
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
    call c_f_pointer(cp, fp)
    v = fp
  end subroutine deref
end module m_bad
