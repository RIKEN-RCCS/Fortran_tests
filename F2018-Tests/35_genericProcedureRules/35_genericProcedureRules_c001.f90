! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.7 [S1, S3]

module m
  implicit none
  abstract interface
    subroutine sub0()
    end subroutine sub0
  end interface
  interface run
    module procedure run1, run2
  end interface run
! FLANG: .f90:[[@LINE+2]]:{{[0-9]+}}: error: Generic 'bad' may not have specific procedures
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  interface bad
    module procedure bad1, bad2
  end interface bad
contains
  subroutine run1(p)
    procedure(sub0) :: p
    call p()
  end subroutine run1
  subroutine run2(q, p)
    procedure(sub0) :: q, p
    call q()
    call p()
  end subroutine run2
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error: Ambiguous interfaces in generic interface 'bad'
  subroutine bad1(p)
    procedure(sub0) :: p
    call p()
  end subroutine bad1
  subroutine bad2(q)
    procedure(sub0) :: q
    call q()
  end subroutine bad2
end module m
