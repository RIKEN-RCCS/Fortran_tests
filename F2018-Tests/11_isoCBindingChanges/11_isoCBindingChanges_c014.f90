! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 2.11 [S10]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  abstract interface
    subroutine iface() bind(c)
    end subroutine
  end interface
contains
  subroutine sub()
    integer, pointer :: dp
    procedure(iface), pointer :: pp
    type(c_funptr) :: fp
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
    call c_f_procpointer(fp, dp)
    call c_f_procpointer(fp, pp)
  end subroutine
end module
