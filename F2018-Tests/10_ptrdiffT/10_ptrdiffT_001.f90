! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.10 [S1]

program ptrdiffT_001
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    function c_ptrdiff_size() bind(c, name="c_ptrdiff_size") result(r)
      import :: c_size_t
      integer(c_size_t) :: r
    end function
  end interface
  integer(c_ptrdiff_t) :: d

  write(*,'(A,L1)') 'storage_size/8==sizeof(ptrdiff_t)=', &
       int(storage_size(d) / 8, c_size_t) == c_ptrdiff_size()
end program ptrdiffT_001
! CHECK: storage_size/8==sizeof(ptrdiff_t)=T
