! RUN: %flang %s -o %t && %t | FileCheck --check-prefix=FLANG %s
! RUN: %gfortran %s -o %t && %t | FileCheck --check-prefix=GFORT %s

! SPEC: F2008 Introduction, 10.7.5

program main
  use, intrinsic :: ieee_arithmetic
  implicit none

  integer :: i = -123
  real    :: r = 12.34
  complex :: c
  logical :: l = .true.
  character(len=5) :: str = "ABC"
  real    :: inf, nan

  ! IEEE
  inf = ieee_value(1.0, ieee_positive_inf)
  nan = ieee_value(1.0, ieee_quiet_nan)
  c = cmplx(1.5, 3.7)

  ! ====================
  ! A-1 integer
  ! B-1 g0
  ! ====================
  print '(a, g0)', 'integer(g0) = ', i
  print '(a, i0)', 'integer(i0) = ', i

  ! ====================
  ! A-2 real
  ! B-1 g0
  ! ====================
  print '(a, g0)', 'real(g0) = ', r
  print '(a, g15.7)', 'real(g15.7) = ', r
  ! ====================
  ! A-2 real
  ! B-2 g0.d
  ! ====================
  print '(a, g0.4)', 'real(g0.4) = ', r
  print '(a, g15.4)', 'real(g15.4) = ', r

  ! ====================
  ! A-3 complex
  ! B-1 g0
  ! ====================
  print "(a, '(', g0, ',', g0,')')", 'complex(g0) = ', c
  print "(a, '(', g15.7, ',', g15.7,')')", 'complex(g15.7) = ', c
  ! ====================
  ! A-3 complex
  ! B-2 g0.d
  ! ====================
  print "(a, '(', g0.4, ',', g0.4,')')", 'complex(g0.4) = ', c
  print "(a, '(', g15.4, ',', g15.4,')')", 'complex(g15.4) = ', c
  
  ! ====================
  ! A-4 logical
  ! B-1 g0
  ! ====================
  print '(a, g0)', 'logocal(g0) = ', l
  print '(a, l1)', 'logocal(l1) = ', l

  ! ====================
  ! A-5 character
  ! B-1 g0
  ! ====================
  print '(a, g0)', 'character(g0) = ', str
  print '(a, a)', 'character(a) = ', str

  ! ====================
  ! A-6 Infinity
  ! B-1 g0
  ! ====================
  print '(a, g0)', 'inf(g0) = ', inf
  print '(a, f0.0)', 'inf(f0.0) = ', inf
  
  ! ====================
  ! A-7 NaN
  ! B-1 g0
  ! ====================
  print '(a, g0)', 'nan(g0) = ', nan
  print '(a, f0.0)', 'nan(f0.0) = ', nan

end program

! FLANG: integer(g0) = -123
! FLANG-NEXT: integer(i0) = -123
! FLANG-NEXT: real(g0) = 12.34
! FLANG-NEXT: real(g15.7) =    12.34000    
! FLANG-NEXT: real(g0.4) = 12.34
! FLANG-NEXT: real(g15.4) =       12.34    
! FLANG-NEXT: complex(g0) = (1.5,3.7)
! FLANG-NEXT: complex(g15.7) = (   1.500000    ,   3.700000    )
! FLANG-NEXT: complex(g0.4) = (1.500,3.700)
! FLANG-NEXT: complex(g15.4) = (      1.500    ,      3.700    )
! FLANG-NEXT: logocal(g0) = T
! FLANG-NEXT: logocal(l1) = T
! FLANG-NEXT: character(g0) = ABC  
! FLANG-NEXT: character(a) = ABC  
! FLANG-NEXT: inf(g0) = Inf
! FLANG-NEXT: inf(f0.0) = Inf
! FLANG-NEXT: nan(g0) = NaN
! FLANG-NEXT: nan(f0.0) = 

! GFORT: integer(g0) = -123
! GFORT-NEXT: integer(i0) = -123
! GFORT-NEXT: real(g0) = 12.3400002
! GFORT-NEXT: real(g15.7) =    12.34000    
! GFORT-NEXT: real(g0.4) = 12.34
! GFORT-NEXT: real(g15.4) =       12.34    
! GFORT-NEXT: complex(g0) = (1.50000000,3.70000005)
! GFORT-NEXT: complex(g15.7) = (   1.500000    ,   3.700000    )
! GFORT-NEXT: complex(g0.4) = (1.500,3.700)
! GFORT-NEXT: complex(g15.4) = (      1.500    ,      3.700    )
! GFORT-NEXT: logocal(g0) = T
! GFORT-NEXT: logocal(l1) = T
! GFORT-NEXT: character(g0) = ABC  
! GFORT-NEXT: character(a) = ABC  
! GFORT-NEXT: inf(g0) = Inf
! GFORT-NEXT: inf(f0.0) = Inf
! GFORT-NEXT: nan(g0) = NaN
! GFORT-NEXT: nan(f0.0) = NaN