! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.4 [S2, S3]

program main
  use, intrinsic :: iso_c_binding
  implicit none

  type, bind(c) :: t_struct
    integer(c_int) :: i
    real(c_double) :: r
  end type

  interface
    subroutine macro_rules() bind(c, name="macro_rules")
    end subroutine
    subroutine note(slot, a) bind(c, name="note")
      import :: c_int
      integer(c_int), value :: slot
      type(*), dimension(..) :: a
    end subroutine
    subroutine report() bind(c, name="report")
    end subroutine
    subroutine same_code(b) bind(c, name="same_code")
      import :: c_double
      real(c_double) :: b(:)
    end subroutine
  end interface

  integer(c_signed_char)        :: v_schar(2)
  integer(c_short)              :: v_short(2)
  integer(c_int)                :: v_int(2)
  integer(c_long)               :: v_long(2)
  integer(c_long_long)          :: v_llong(2)
  integer(c_size_t)             :: v_size(2)
  integer(c_int8_t)             :: v_i8(2)
  integer(c_int16_t)            :: v_i16(2)
  integer(c_int32_t)            :: v_i32(2)
  integer(c_int64_t)            :: v_i64(2)
  integer(c_int_least8_t)       :: v_l8(2)
  integer(c_int_least16_t)      :: v_l16(2)
  integer(c_int_least32_t)      :: v_l32(2)
  integer(c_int_least64_t)      :: v_l64(2)
  integer(c_int_fast8_t)        :: v_f8(2)
  integer(c_int_fast16_t)       :: v_f16(2)
  integer(c_int_fast32_t)       :: v_f32(2)
  integer(c_int_fast64_t)       :: v_f64(2)
  integer(c_intmax_t)           :: v_imax(2)
  integer(c_intptr_t)           :: v_iptr(2)
  integer(c_ptrdiff_t)          :: v_pdiff(2)
  real(c_float)                 :: v_float(2)
  real(c_double)                :: v_double(2), v_double2(3)
  real(c_long_double)           :: v_ldbl(2)
  complex(c_float_complex)      :: v_fcx(2)
  complex(c_double_complex)     :: v_dcx(2)
  complex(c_long_double_complex):: v_ldcx(2)
  logical(c_bool)               :: v_bool(2)
  character(kind=c_char,len=1)  :: v_char(2)
  type(c_ptr)                   :: v_cptr(2)
  type(t_struct)                :: v_struct(2)

  v_schar = 0; v_short = 0; v_int = 0; v_long = 0; v_llong = 0; v_size = 0
  v_i8 = 0; v_i16 = 0; v_i32 = 0; v_i64 = 0
  v_l8 = 0; v_l16 = 0; v_l32 = 0; v_l64 = 0
  v_f8 = 0; v_f16 = 0; v_f32 = 0; v_f64 = 0
  v_imax = 0; v_iptr = 0; v_pdiff = 0
  v_float = 0; v_double = 0; v_double2 = 0; v_ldbl = 0
  v_fcx = 0; v_dcx = 0; v_ldcx = 0
  v_bool = .false._c_bool
  v_char = c_char_'x'
  v_cptr = c_null_ptr
  v_struct = t_struct(0, 0.0_c_double)

  call note(0,  v_schar)
  call note(1,  v_short)
  call note(2,  v_int)
  call note(3,  v_long)
  call note(4,  v_llong)
  call note(5,  v_size)
  call note(6,  v_i8)
  call note(7,  v_i16)
  call note(8,  v_i32)
  call note(9,  v_i64)
  call note(10, v_l8)
  call note(11, v_l16)
  call note(12, v_l32)
  call note(13, v_l64)
  call note(14, v_f8)
  call note(15, v_f16)
  call note(16, v_f32)
  call note(17, v_f64)
  call note(18, v_imax)
  call note(19, v_iptr)
  call note(20, v_pdiff)
  call note(21, v_float)
  call note(22, v_double)
  call note(23, v_ldbl)
  call note(24, v_fcx)
  call note(25, v_dcx)
  call note(26, v_ldcx)
  call note(27, v_bool)
  call note(28, v_char)
  call note(29, v_cptr)
  call note(30, v_struct)

  call macro_rules()
  call report()
  call same_code(v_double2)
end program main

! CHECK: table2_codes_positive: yes
! CHECK: other_is_negative: yes
! CHECK: other_distinct_from_all: yes
! CHECK: struct_distinct_from_all: yes
! CHECK: all_slots_seen: yes
! CHECK: descriptor_codes_positive: yes
! CHECK: double_is_CFI_type_double: yes
! CHECK: unique_macro_types_match: yes
! CHECK: same_type_same_code: yes
