! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 2.11 [S6]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  type :: pt(n)
    integer, len :: n
    integer :: a(n)
  end type
  type :: t
    integer :: i
  end type
contains
  subroutine sub()
    type(pt(3)), target :: x
    type(t), target :: y
    type(c_ptr) :: p
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
    p = c_loc(x)
    p = c_loc(y)
  end subroutine
end module
