! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' --implicit-check-not='NVFORTRAN-W-' %s %}

! SPEC: N2161 2.11 [S6]

module m
  use, intrinsic :: iso_c_binding
  implicit none
contains
  subroutine sub()
    real :: x
    real, target :: y
    type(c_ptr) :: p
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-W-0468-{{.*}}.f90: [[@LINE+1]])
    p = c_loc(x)
    p = c_loc(y)
  end subroutine
end module
