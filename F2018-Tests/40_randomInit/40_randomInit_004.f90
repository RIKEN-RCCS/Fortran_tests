! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.14 [S4, S5]


program random_init_004
  implicit none
  integer :: n
  integer, allocatable :: s1(:), s2(:)

  call random_seed(size=n)
  write(*,'(A,L1)') 'seed_size_ok=', n >= 1
  if (n >= 1) then
    allocate(s1(n), s2(n))
    call random_init(.false., .true.)
    call random_seed(get=s1)
    call random_init(.false., .true.)
    call random_seed(get=s2)
    write(*,'(A,L1)') 'seeds_differ=', any(s1 /= s2)
  else
    write(*,'(A)') 'seeds_differ=UNSUPPORTED'
  end if
end program random_init_004
! CHECK: seed_size_ok=T
! CHECK-NEXT: seeds_differ=T
