! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.14 [S2, S3]


program random_init_005
  implicit none
  integer :: n, i
  integer, allocatable :: s1(:), s2(:)
  real :: r1(8), r2(8), w

  call random_seed(size=n)
  write(*,'(A,L1)') 'seed_size_ok=', n >= 1
  if (n >= 1) then
    allocate(s1(n), s2(n))
    call random_init(image_distinct=.false., repeatable=.true.)
    call random_seed(get=s1)
    call random_number(r1)
    do i = 1, 100
      call random_number(w)
    end do
    call random_init(image_distinct=.false., repeatable=.true.)
    call random_seed(get=s2)
    call random_number(r2)
    write(*,'(A,L1)') 'keyword_seeds_equal=', all(s1 == s2)
    write(*,'(A,L1)') 'keyword_sequences_equal=', all(r1 == r2)
  else
    write(*,'(A)') 'keyword_seeds_equal=UNSUPPORTED'
    write(*,'(A)') 'keyword_sequences_equal=UNSUPPORTED'
  end if
end program random_init_005
! CHECK: seed_size_ok=T
! CHECK-NEXT: keyword_seeds_equal=T
! CHECK-NEXT: keyword_sequences_equal=T
