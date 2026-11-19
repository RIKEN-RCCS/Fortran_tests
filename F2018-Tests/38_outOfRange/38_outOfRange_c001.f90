! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='out_of_range, has not been explicitly declared' %s %}

! SPEC: N2161 5.10 [S2]


program outOfRange_c001
  implicit none
  print *, out_of_range(.true., 0)
  block
    logical :: control
    control = out_of_range(1.0, 0)
  end block
end program outOfRange_c001
! FLANG: c001.f90:10:{{[0-9]+}}: error: Actual argument for 'x=' has bad type
! GFORT: {{.*}}x{{.*}} argument of {{.*}}out_of_range{{.*}} must be INTEGER, REAL
! NVFORT: {{.*}}c001.f90: 10)
