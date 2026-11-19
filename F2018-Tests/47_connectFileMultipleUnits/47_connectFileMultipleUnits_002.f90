! RUN: %if flang %{ %flang %s -o %t && rm -rf %t.d && mkdir -p %t.d && cd %t.d && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && rm -rf %t.d && mkdir -p %t.d && cd %t.d && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && rm -rf %t.d && mkdir -p %t.d && cd %t.d && %t | FileCheck %s %}

! SPEC: N2161 5.21 [S1, S2, S3, S6]

program connectFileMultipleUnits_002
  implicit none
  character(*), parameter :: fname = 'f2018_test_047.dat'
  integer :: ua, ub, w, ios
  logical :: op
  character(20) :: line

  open(newunit=w, file=fname, status='replace', action='write')
  write(w,'(A)') 'line1'
  write(w,'(A)') 'line2'
  write(w,'(A)') 'line3'
  close(w)

  open(newunit=ua, file=fname, status='old', action='read')
  open(newunit=ub, file=fname, status='old', action='read', iostat=ios)
  write(*,'(A,L1)') 'multi_connect_supported=', ios == 0
  if (ios == 0) then
    close(ua)
    inquire(unit=ub, opened=op)
    write(*,'(A,L1)') 'b_still_opened=', op
    read(ub,'(A)') line
    write(*,'(A,A)') 'b_read=', trim(line)
    close(ub, status='delete')
  else
    write(*,'(A)') 'b_still_opened=UNSUPPORTED'
    write(*,'(A)') 'b_read=UNSUPPORTED'
    close(ua, status='delete')
  end if
end program connectFileMultipleUnits_002

! CHECK: multi_connect_supported=T
! CHECK-NEXT: b_still_opened=T
! CHECK-NEXT: b_read=line1
