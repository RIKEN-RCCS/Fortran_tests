! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='out_of_range, has not been explicitly declared' %s %}

! SPEC: N2161 5.10 [S2]


program outOfRange_c005
  implicit none
  integer :: m(3)
  m = 0
  print *, out_of_range(1.0, m)
  block
    logical :: control
    control = out_of_range(1.0, 0)
  end block
end program outOfRange_c005
! FLANG: c005.f90:12:{{[0-9]+}}: error: 'mold=' argument has unacceptable rank 1
! GFORT: {{.*}}mold{{.*}} argument of {{.*}}out_of_range{{.*}} must be a scalar
! NVFORT: {{.*}}c005.f90: 12)
