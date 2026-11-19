! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.15 [S1, S2]

program signIntrinsic_001
  implicit none
  integer, parameter :: ik = kind(0)
  integer, parameter :: ik18 = selected_int_kind(18)
  integer :: n
  logical :: differ

  n = command_argument_count()
  differ = range(0_ik) < range(0_ik18)
  write(*,'(A,L1)') 'kinds_differ=', differ
  if (differ) then
    write(*,'(A,I0)') 'sign(5_ik,-1_ik18)=', sign(5_ik + n, -1_ik18 - n)
    write(*,'(A,L1)') 'kind_is_a(ik)=', kind(sign(5_ik, -1_ik18)) == ik
    write(*,'(A,I0)') 'sign(5_ik18,1_ik)=', sign(5_ik18 + n, 1_ik + n)
    write(*,'(A,L1)') 'kind_is_a(ik18)=', kind(sign(5_ik18, 1_ik)) == ik18
    write(*,'(A,I0)') 'sign(-5_ik,2_ik18)=', sign(-5_ik - n, 2_ik18 + n)
    write(*,'(A,I0)') 'sign(5_ik,0_ik18)=', sign(5_ik + n, 0_ik18 * (n + 1))
  else
    write(*,'(A)') 'sign(5_ik,-1_ik18)=UNSUPPORTED'
    write(*,'(A)') 'kind_is_a(ik)=UNSUPPORTED'
    write(*,'(A)') 'sign(5_ik18,1_ik)=UNSUPPORTED'
    write(*,'(A)') 'kind_is_a(ik18)=UNSUPPORTED'
    write(*,'(A)') 'sign(-5_ik,2_ik18)=UNSUPPORTED'
    write(*,'(A)') 'sign(5_ik,0_ik18)=UNSUPPORTED'
  end if
end program signIntrinsic_001

! CHECK: kinds_differ=T
! CHECK-NEXT: sign(5_ik,-1_ik18)=-5
! CHECK-NEXT: kind_is_a(ik)=T
! CHECK-NEXT: sign(5_ik18,1_ik)=5
! CHECK-NEXT: kind_is_a(ik18)=T
! CHECK-NEXT: sign(-5_ik,2_ik18)=5
! CHECK-NEXT: sign(5_ik,0_ik18)=5
