! RUN: %if flang %{ %flang -std=f2018 -pedantic %s -o %t > %t.log 2>&1 && %t >> %t.log %}
! RUN: %if flang %{ FileCheck --implicit-check-not=warning --implicit-check-not=error --implicit-check-not=portability %s < %t.log %}
! RUN: %if gfortran %{ %gfortran -std=f2018 %s -o %t > %t.log 2>&1 && %t >> %t.log %}
! RUN: %if gfortran %{ FileCheck --implicit-check-not=Warning --implicit-check-not=Error %s < %t.log %}
! RUN: %if nvfortran %{ %nvfortran -Mstandard %s -o %t > %t.log 2>&1 && %t >> %t.log %}
! RUN: %if nvfortran %{ FileCheck --implicit-check-not=NVFORTRAN- %s < %t.log %}

! SPEC: N2161 5.17 [S1, S2, S4]


program detectingNonstandardIntrinsics_002
  implicit none
  integer, external :: loc
  integer :: n
  n = command_argument_count()
  write(*,'(A,I0)') 'external_loc=', loc(1 + n)
end program detectingNonstandardIntrinsics_002

integer function loc(i)
  implicit none
  integer, intent(in) :: i
  loc = i + 1
end function loc
! CHECK: external_loc=2
