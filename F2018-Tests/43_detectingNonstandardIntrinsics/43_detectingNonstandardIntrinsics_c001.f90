! RUN: %if flang %{ %flang -std=f2018 -pedantic -c %s -o %t.o > %t.log 2>&1 || echo compile_failed >> %t.log %}
! RUN: %if flang %{ FileCheck --check-prefix=FLANG %s < %t.log %}
! RUN: %if gfortran %{ %gfortran -std=f2018 -c %s -o %t.o > %t.log 2>&1 || echo compile_failed >> %t.log %}
! RUN: %if gfortran %{ FileCheck --check-prefix=GFORT %s < %t.log %}
! RUN: %if nvfortran %{ %nvfortran -Mstandard -c %s -o %t.o > %t.log 2>&1 || echo compile_failed >> %t.log %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=NVFORT %s < %t.log %}

! SPEC: N2161 5.17 [S1, S2, S3]


program detectingNonstandardIntrinsics_c001
  implicit none
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: {{(Error|Warning)}}: The intrinsic {{.}}loc{{.}} declared INTRINSIC at (1) is not available in the current standard settings but a GNU Fortran extension
  intrinsic :: loc
  real :: x
  x = 1.0
  print *, loc(x)
end program detectingNonstandardIntrinsics_c001
! FLANG: {{(error|warning|portability)}}:{{.*}}loc
! NVFORT: NVFORTRAN-{{.*}}loc
