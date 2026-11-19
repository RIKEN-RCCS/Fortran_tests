! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.5 [S2]

program zeroWidthEditDescriptors_c001
  implicit none
  integer, parameter :: dp = selected_real_kind(15)
  real(dp) :: x
  character(len=40) :: line

  x = 1.5_dp
  write(line,'(ss,e0.3)') x
  line = '1.5'
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  read(line,'(e0.3)') x
  print *, x
end program zeroWidthEditDescriptors_c001
