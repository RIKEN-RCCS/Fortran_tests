! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 2.17 [S9]

module m
  implicit none
contains
  subroutine s_bad(x)
    real, asynchronous :: x(4)
  end subroutine
  subroutine s_ok(x)
    real, asynchronous, pointer :: x(:)
  end subroutine
end module
program asyncComm_c004
  use m
  implicit none
  real, asynchronous, pointer :: p(:)
  allocate(p(4))
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  call s_bad(p)
  call s_ok(p)
end program
