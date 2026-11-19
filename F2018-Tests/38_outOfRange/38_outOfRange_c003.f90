! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='out_of_range, has not been explicitly declared' %s %}

! SPEC: N2161 5.10 [S2]


program outOfRange_c003
  implicit none
  integer, parameter :: lk = selected_int_kind(18)
  print *, out_of_range(1, 0_lk, .true.)
  block
    logical :: control
    control = out_of_range(1.0, 0)
  end block
end program outOfRange_c003
! FLANG: c003.f90:11:{{[0-9]+}}: error: Actual argument for 'x=' has bad type
! GFORT: {{.*}}round{{.*}} argument of {{.*}}out_of_range{{.*}} shall appear only if
! NVFORT: {{.*}}c003.f90: 11)
