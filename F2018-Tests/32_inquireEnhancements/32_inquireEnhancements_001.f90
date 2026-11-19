! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.4 [S1, S4]

program inquireEnhancements_001
  implicit none
  integer :: r
  logical :: op, not_opened

  inquire(unit=77, opened=op)
  not_opened = .not. op
  write(*,'(A,L1)') 'unit_not_opened=', not_opened
  if (not_opened) then
    r = 12345
    inquire(unit=77, recl=r)
    write(*,'(A,I0)') 'recl_unit=', r
    r = 12345
    inquire(file='F2018_TEST_NO_SUCH_FILE_032', recl=r)
    write(*,'(A,I0)') 'recl_file=', r
  else
    write(*,'(A)') 'recl_unit=UNSUPPORTED'
    write(*,'(A)') 'recl_file=UNSUPPORTED'
  end if
end program inquireEnhancements_001

! CHECK: unit_not_opened=T
! CHECK-NEXT: recl_unit=-1
! CHECK-NEXT: recl_file=-1
