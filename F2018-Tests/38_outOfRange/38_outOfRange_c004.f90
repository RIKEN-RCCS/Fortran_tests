! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='out_of_range, has not been explicitly declared' %s %}

! SPEC: N2161 5.10 [S2]


program outOfRange_c004
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  print *, out_of_range(1.0_dp, 1.0, .true.)
  block
    logical :: control
    control = out_of_range(1.0, 0)
  end block
end program outOfRange_c004
! FLANG: c004.f90:11:{{[0-9]+}}: error: Actual argument for 'mold=' has bad type
! GFORT: {{.*}}round{{.*}} argument of {{.*}}out_of_range{{.*}} shall appear only if
! NVFORT: {{.*}}c004.f90: 11)
