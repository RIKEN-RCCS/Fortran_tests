! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.7 [S1, S2, S3]

module m
  implicit none
  abstract interface
    subroutine sub0()
    end subroutine sub0
  end interface
  interface run
    module procedure run1, run2
  end interface run
! FLANG: .f90:[[@LINE+2]]:{{[0-9]+}}: error: Generic 'mo' may not have specific procedures
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  interface mo
    module procedure mo1, mo2
  end interface mo
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
! GFORT: Error: Ambiguous interfaces in generic interface 'mo'
  subroutine mo1(p, r)
    procedure(sub0) :: p
    procedure(sub0), optional :: r
    call p()
    if (present(r)) call r()
  end subroutine mo1
  subroutine mo2(q, p)
    procedure(sub0) :: q, p
    call q()
    call p()
  end subroutine mo2
end module m
