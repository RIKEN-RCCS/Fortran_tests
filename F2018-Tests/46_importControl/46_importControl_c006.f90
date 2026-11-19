! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.20 [S5]

program importControl_c006
  implicit none
  integer :: a, b
  a = 10 + command_argument_count()
  b = 20 + command_argument_count()
  call ok()
  call sub()
contains
  subroutine ok()
    import, only: a
    print *, a
  end subroutine ok
  subroutine sub()
! FLANG: .f90:[[@LINE+1]]:{{[0-9]+}}: error: 'a' from host is not accessible
    import, all
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error: {{.*}}must not be re-declared
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
    integer :: a
    a = 1
  end subroutine sub
end program importControl_c006
