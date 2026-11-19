! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='out_of_range, has not been explicitly declared' %s %}

! SPEC: N2161 5.10 [S2]


program outOfRange_c002
  implicit none
  print *, out_of_range(1.0, (0.0, 0.0))
  block
    logical :: control
    control = out_of_range(1.0, 0)
  end block
end program outOfRange_c002
! FLANG: c002.f90:10:{{[0-9]+}}: error: Actual argument for 'mold=' has bad type
! GFORT: {{.*}}mold{{.*}} argument of {{.*}}out_of_range{{.*}} must be INTEGER, REAL
! NVFORT: {{.*}}c002.f90: 10)
