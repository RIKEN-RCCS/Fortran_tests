! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/17_asyncComm.c -c -o %t.c.o && %flang %t.f.o %t.c.o -lpthread -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/17_asyncComm.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -lpthread -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/17_asyncComm.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -lpthread -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.17 [S2, S7]

program asyncComm_003
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_isend(buf, n) bind(c)
      import :: c_int
      integer(c_int), asynchronous, intent(in) :: buf(*)
      integer(c_int), value :: n
    end subroutine
    subroutine c_wait() bind(c)
    end subroutine
    subroutine c_sent(out) bind(c)
      import :: c_int
      integer(c_int), intent(out) :: out(*)
    end subroutine
  end interface
  integer(c_int), asynchronous :: buf(4)
  integer(c_int) :: sent(4)
  integer :: n, s

  n = command_argument_count()
  buf = [1, 2, 3, 4] + n

  call c_isend(buf, 4)
  s = sum(buf)
  write(*,'(A,I0)') 'pending_ref sum=', s
  call c_wait()

  call c_sent(sent)
  write(*,'(A,4(1X,I0))') 'isend sent=', sent
end program asyncComm_003

! CHECK: pending_ref sum=10
! CHECK-NEXT: isend sent= 1 2 3 4
