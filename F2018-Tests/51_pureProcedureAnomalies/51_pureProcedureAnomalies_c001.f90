! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-' %s %}

! SPEC: N2161 5.25 [S3]

module m_bad
  implicit none
contains
  pure function twice_plus_one(n) result(r)
    integer, value :: n
    integer :: r
    n = n * 2
    r = n + 1
  end function twice_plus_one

! NVFORT: NVFORTRAN-W-0194-INTENT(IN) argument cannot be defined - n ({{.*}}.f90: [[@LINE+2]])
! NVFORT: NVFORTRAN-S-0501-Non-pointer dummy argument n of pure function
  pure function bad(n) result(r)
    integer, intent(in) :: n
    integer :: r
! FLANG: .f90:[[@LINE+3]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error:
    n = n * 2
    r = n + 1
  end function bad
end module m_bad
