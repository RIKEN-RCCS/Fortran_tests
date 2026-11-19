! RUN: %if flang %{ %flang %s -o %t && rm -rf %t.d && mkdir -p %t.d && cd %t.d && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && rm -rf %t.d && mkdir -p %t.d && cd %t.d && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && rm -rf %t.d && mkdir -p %t.d && cd %t.d && %t | FileCheck %s %}

! SPEC: N2161 5.21 [S1, S2, S3, S5]

program connectFileMultipleUnits_001
  implicit none
  character(*), parameter :: fname = 'f2018_test_047.dat'
  integer :: ua, ub, w, ios, n
  logical :: op

  open(newunit=w, file=fname, status='replace', action='write')
  write(w,'(A)') 'line1'
  write(w,'(A)') 'line2'
  write(w,'(A)') 'line3'
  close(w)

  open(newunit=ua, file=fname, status='old', action='read')
  open(newunit=ub, file=fname, status='old', action='read', iostat=ios)
  write(*,'(A,L1)') 'multi_connect_supported=', ios == 0
  if (ios == 0) then
    inquire(file=fname, opened=op, number=n)
    write(*,'(A,L1)') 'file_opened=', op
    write(*,'(A,L1)') 'number_is_a_or_b=', n == ua .or. n == ub
    close(ub)
  else
    write(*,'(A)') 'file_opened=UNSUPPORTED'
    write(*,'(A)') 'number_is_a_or_b=UNSUPPORTED'
  end if
  close(ua, status='delete')
end program connectFileMultipleUnits_001

! CHECK: multi_connect_supported=T
! CHECK-NEXT: file_opened=T
! CHECK-NEXT: number_is_a_or_b=T
