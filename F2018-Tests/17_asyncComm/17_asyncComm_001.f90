! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/17_asyncComm.c -c -o %t.c.o && %flang %t.f.o %t.c.o -lpthread -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/17_asyncComm.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -lpthread -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/17_asyncComm.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -lpthread -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.17 [S1, S2, S6]

program asyncComm_001
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_irecv(buf, n) bind(c)
      import :: c_int
      integer(c_int), asynchronous, intent(inout) :: buf(*)
      integer(c_int), value :: n
    end subroutine
    subroutine c_wait() bind(c)
    end subroutine
  end interface
  integer(c_int), asynchronous :: buf(4)
  integer :: n, k

  n = command_argument_count()
  buf = n
  write(*,'(A,4(1X,I0))') 'before_irecv buf=', buf

  call c_irecv(buf, 4)
  k = 0
  do while (k < 1000 + n)
    k = k + 1
  end do
  call c_wait()

  write(*,'(A,I0)') 'continued k=', k
  write(*,'(A,4(1X,I0))') 'after_wait buf=', buf
end program asyncComm_001
! CHECK: before_irecv buf= 0 0 0 0
! CHECK-NEXT: continued k=1000
! CHECK-NEXT: after_wait buf= 10 20 30 40
