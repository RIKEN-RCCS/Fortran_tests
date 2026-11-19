! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 2.17 [S8]

module m
  implicit none
contains
  subroutine s_bad(x)
    real, asynchronous, contiguous :: x(:)
  end subroutine
  subroutine s_ok(x)
    real, asynchronous :: x(:)
  end subroutine
end module
program asyncComm_c003
  use m
  implicit none
  real, asynchronous :: a(10)
  a = 0
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  call s_bad(a(1:9:2))
  call s_ok(a(1:9:2))
end program
