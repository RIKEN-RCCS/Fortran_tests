! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.14 [S3, S5]


program random_init_002
  implicit none
  integer :: n
  integer, allocatable :: s1(:), s2(:)
  real :: r1(8), r2(8)

  call random_seed(size=n)
  write(*,'(A,L1)') 'seed_size_ok=', n >= 1
  if (n >= 1) then
    allocate(s1(n), s2(n))
    call random_init(.true., .true.)
    call random_seed(get=s1)
    call random_number(r1)
    call random_init(.true., .true.)
    call random_seed(get=s2)
    call random_number(r2)
    write(*,'(A,L1)') 'seeds_equal=', all(s1 == s2)
    write(*,'(A,L1)') 'sequences_equal=', all(r1 == r2)
  else
    write(*,'(A)') 'seeds_equal=UNSUPPORTED'
    write(*,'(A)') 'sequences_equal=UNSUPPORTED'
  end if
end program random_init_002
! CHECK: seed_size_ok=T
! CHECK-NEXT: seeds_equal=T
! CHECK-NEXT: sequences_equal=T
