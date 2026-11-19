! RUN: %if flang %{ %flang -std=f2018 -pedantic %s -o %t > %t.log 2>&1 && %t >> %t.log %}
! RUN: %if flang %{ FileCheck --implicit-check-not=warning --implicit-check-not=error --implicit-check-not=portability %s < %t.log %}
! RUN: %if gfortran %{ %gfortran -std=f2018 %s -o %t > %t.log 2>&1 && %t >> %t.log %}
! RUN: %if gfortran %{ FileCheck --implicit-check-not=Warning --implicit-check-not=Error %s < %t.log %}
! RUN: %if nvfortran %{ %nvfortran -Mstandard %s -o %t > %t.log 2>&1 && %t >> %t.log %}
! RUN: %if nvfortran %{ FileCheck --implicit-check-not=NVFORTRAN- %s < %t.log %}

! SPEC: N2161 5.17 [S1, S2]


program detectingNonstandardIntrinsics_001
  use, intrinsic :: iso_fortran_env, only: int32
  implicit none
  integer :: n, k
  n = command_argument_count()
  call random_seed(size=k)
  write(*,'(A,I0)') 'abs=', abs(-5 - n)
  write(*,'(A,L1)') 'seed_size_positive=', k > 0
  write(*,'(A,I0)') 'int32_bits=', bit_size(int(n, int32))
end program detectingNonstandardIntrinsics_001
! CHECK: abs=5
! CHECK-NEXT: seed_size_positive=T
! CHECK-NEXT: int32_bits=32
