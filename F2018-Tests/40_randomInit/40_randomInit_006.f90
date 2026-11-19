! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.14 [S3]


program random_init_006
  implicit none
  character(*), parameter :: seed_file = 't040_006_seed.txt'
  integer :: n, u, ios, stat, cmdstat, exitstat
  integer, allocatable :: s1(:), s2(:)
  character(1024) :: self, arg
  logical :: is_child, ok

  call random_seed(size=n)
  is_child = .false.
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    is_child = arg == 'child'
  end if

  if (is_child) then
    allocate(s1(max(n, 0)))
    call random_init(.true., .false.)
    call random_seed(get=s1)
    open(newunit=u, file=seed_file, status='replace', action='write')
    write(u, *) s1
    close(u)
  else
    write(*,'(A,L1)') 'seed_size_ok=', n >= 1
    if (n >= 1) then
      allocate(s1(n), s2(n))
      call random_init(.true., .false.)
      call random_seed(get=s1)
      call get_command_argument(0, self, status=stat)
      ok = stat == 0
      if (ok) then
        cmdstat = -1
        exitstat = -1
        call execute_command_line(trim(self) // ' child', exitstat=exitstat, cmdstat=cmdstat)
        ok = cmdstat == 0 .and. exitstat == 0
      end if
      if (ok) then
        open(newunit=u, file=seed_file, status='old', action='read', iostat=ios)
        ok = ios == 0
        if (ok) then
          read(u, *, iostat=ios) s2
          ok = ios == 0
          close(u, status='delete')
        end if
      end if
      write(*,'(A,L1)') 'self_invoke_ok=', ok
      if (ok) then
        write(*,'(A,L1)') 'seeds_equal_across_runs=', all(s1 == s2)
      else
        write(*,'(A)') 'seeds_equal_across_runs=UNSUPPORTED'
      end if
    else
      write(*,'(A)') 'self_invoke_ok=UNSUPPORTED'
      write(*,'(A)') 'seeds_equal_across_runs=UNSUPPORTED'
    end if
  end if
end program random_init_006
! CHECK: seed_size_ok=T
! CHECK-NEXT: self_invoke_ok=T
! CHECK-NEXT: seeds_equal_across_runs=T
