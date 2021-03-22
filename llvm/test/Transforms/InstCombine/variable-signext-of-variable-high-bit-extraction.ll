; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

declare void @use16(i16)
declare void @use32(i32)
declare void @use64(i64)

define i32 @t0(i64 %data, i32 %nbits) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[TMP1:%.*]] = ashr i64 [[DATA]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = trunc i64 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow
  ret i32 %signextended
}
define i32 @t0_zext_of_nbits(i64 %data, i8 %nbits_narrow) {
; CHECK-LABEL: @t0_zext_of_nbits(
; CHECK-NEXT:    [[NBITS:%.*]] = zext i8 [[NBITS_NARROW:%.*]] to i16
; CHECK-NEXT:    call void @use16(i16 [[NBITS]])
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub nsw i16 64, [[NBITS]]
; CHECK-NEXT:    call void @use16(i16 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i16 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW_NARROW:%.*]] = sub nsw i16 32, [[NBITS]]
; CHECK-NEXT:    call void @use16(i16 [[NUM_HIGH_BITS_TO_SMEAR_NARROW_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = zext i16 [[NUM_HIGH_BITS_TO_SMEAR_NARROW_NARROW]] to i32
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[TMP1:%.*]] = ashr i64 [[DATA]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = trunc i64 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %nbits = zext i8 %nbits_narrow to i16
  call void @use16(i16 %nbits)
  %skip_high = sub i16 64, %nbits
  call void @use16(i16 %skip_high)
  %skip_high_wide = zext i16 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow_narrow = sub i16 32, %nbits
  call void @use16(i16 %num_high_bits_to_smear_narrow_narrow)
  %num_high_bits_to_smear_narrow = zext i16 %num_high_bits_to_smear_narrow_narrow to i32
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow
  ret i32 %signextended
}
define i32 @t0_exact(i64 %data, i32 %nbits) {
; CHECK-LABEL: @t0_exact(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr exact i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[TMP1:%.*]] = ashr exact i64 [[DATA]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = trunc i64 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr exact i64 %data, %skip_high_wide ; We can preserve `exact`-ness of the original shift.
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow
  ret i32 %signextended
}

define i32 @t1_redundant_sext(i64 %data, i32 %nbits) {
; CHECK-LABEL: @t1_redundant_sext(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED_WITH_SIGNEXTENSION:%.*]] = ashr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED_WITH_SIGNEXTENSION]])
; CHECK-NEXT:    [[EXTRACTED_WITH_SIGNEXTENSION_NARROW:%.*]] = trunc i64 [[EXTRACTED_WITH_SIGNEXTENSION]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_WITH_SIGNEXTENSION_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i32 [[EXTRACTED_WITH_SIGNEXTENSION_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    call void @use32(i32 [[SIGNBIT_POSITIONED]])
; CHECK-NEXT:    ret i32 [[EXTRACTED_WITH_SIGNEXTENSION_NARROW]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted_with_signextension = ashr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted_with_signextension)
  %extracted_with_signextension_narrow = trunc i64 %extracted_with_signextension to i32 ; this is already the answer.
  call void @use32(i32 %extracted_with_signextension_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_with_signextension_narrow, %num_high_bits_to_smear_narrow
  call void @use32(i32 %signbit_positioned)
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow
  ret i32 %signextended
}

define i64 @t2_notrunc(i64 %data, i64 %nbits) {
; CHECK-LABEL: @t2_notrunc(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i64 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR:%.*]] = sub i64 64, [[NBITS]]
; CHECK-NEXT:    call void @use64(i64 [[NUM_HIGH_BITS_TO_SMEAR]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i64 [[EXTRACTED]], [[NUM_HIGH_BITS_TO_SMEAR]]
; CHECK-NEXT:    call void @use64(i64 [[SIGNBIT_POSITIONED]])
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = ashr i64 [[DATA]], [[SKIP_HIGH]]
; CHECK-NEXT:    ret i64 [[SIGNEXTENDED]]
;
  %skip_high = sub i64 64, %nbits
  call void @use64(i64 %skip_high)
  %extracted = lshr i64 %data, %skip_high
  call void @use64(i64 %extracted)
  %num_high_bits_to_smear = sub i64 64, %nbits
  call void @use64(i64 %num_high_bits_to_smear)
  %signbit_positioned = shl i64 %extracted, %num_high_bits_to_smear ;
  call void @use64(i64 %signbit_positioned)
  %signextended = ashr i64 %signbit_positioned, %num_high_bits_to_smear ; can just shift %data itself.
  ret i64 %signextended
}

define i64 @t3_notrunc_redundant_sext(i64 %data, i64 %nbits) {
; CHECK-LABEL: @t3_notrunc_redundant_sext(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i64 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = ashr i64 [[DATA:%.*]], [[SKIP_HIGH]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR:%.*]] = sub i64 64, [[NBITS]]
; CHECK-NEXT:    call void @use64(i64 [[NUM_HIGH_BITS_TO_SMEAR]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i64 [[EXTRACTED]], [[NUM_HIGH_BITS_TO_SMEAR]]
; CHECK-NEXT:    call void @use64(i64 [[SIGNBIT_POSITIONED]])
; CHECK-NEXT:    ret i64 [[EXTRACTED]]
;
  %skip_high = sub i64 64, %nbits
  call void @use64(i64 %skip_high)
  %extracted = ashr i64 %data, %skip_high ; this is already the answer.
  call void @use64(i64 %extracted)
  %num_high_bits_to_smear = sub i64 64, %nbits
  call void @use64(i64 %num_high_bits_to_smear)
  %signbit_positioned = shl i64 %extracted, %num_high_bits_to_smear
  call void @use64(i64 %signbit_positioned)
  %signextended = ashr i64 %signbit_positioned, %num_high_bits_to_smear
  ret i64 %signextended
}

define <2 x i32> @t4_vec(<2 x i64> %data, <2 x i32> %nbits) {
; CHECK-LABEL: @t4_vec(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub <2 x i32> <i32 64, i32 64>, [[NBITS:%.*]]
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext <2 x i32> [[SKIP_HIGH]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <2 x i64> [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = trunc <2 x i64> [[TMP1]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[SIGNEXTENDED]]
;
  %skip_high = sub <2 x i32> <i32 64, i32 64>, %nbits
  %skip_high_wide = zext <2 x i32> %skip_high to <2 x i64>
  %extracted = lshr <2 x i64> %data, %skip_high_wide
  %extracted_narrow = trunc <2 x i64> %extracted to <2 x i32>
  %num_high_bits_to_smear_narrow = sub <2 x i32> <i32 32, i32 32>, %nbits
  %signbit_positioned = shl <2 x i32> %extracted_narrow, %num_high_bits_to_smear_narrow
  %signextended = ashr <2 x i32> %signbit_positioned, %num_high_bits_to_smear_narrow
  ret <2 x i32> %signextended
}

define <3 x i32> @t5_vec_undef(<3 x i64> %data, <3 x i32> %nbits) {
; CHECK-LABEL: @t5_vec_undef(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub <3 x i32> <i32 64, i32 64, i32 undef>, [[NBITS:%.*]]
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext <3 x i32> [[SKIP_HIGH]] to <3 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <3 x i64> [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = trunc <3 x i64> [[TMP1]] to <3 x i32>
; CHECK-NEXT:    ret <3 x i32> [[SIGNEXTENDED]]
;
  %skip_high = sub <3 x i32> <i32 64, i32 64, i32 undef>, %nbits
  %skip_high_wide = zext <3 x i32> %skip_high to <3 x i64>
  %extracted = lshr <3 x i64> %data, %skip_high_wide
  %extracted_narrow = trunc <3 x i64> %extracted to <3 x i32>
  %num_high_bits_to_smear_narrow0 = sub <3 x i32> <i32 32, i32 32, i32 undef>, %nbits
  %num_high_bits_to_smear_narrow1 = sub <3 x i32> <i32 undef, i32 32, i32 32>, %nbits
  %signbit_positioned = shl <3 x i32> %extracted_narrow, %num_high_bits_to_smear_narrow0
  %signextended = ashr <3 x i32> %signbit_positioned, %num_high_bits_to_smear_narrow1
  ret <3 x i32> %signextended
}

; Extra-uses
define i32 @t6_extrause_good0(i64 %data, i32 %nbits) {
; CHECK-LABEL: @t6_extrause_good0(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[TMP1:%.*]] = ashr i64 [[DATA]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = trunc i64 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow ; will go away
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow
  ret i32 %signextended
}
define i32 @t7_extrause_good1(i64 %data, i32 %nbits) {
; CHECK-LABEL: @t7_extrause_good1(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW0:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW0]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i32 [[EXTRACTED_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW0]]
; CHECK-NEXT:    call void @use32(i32 [[SIGNBIT_POSITIONED]])
; CHECK-NEXT:    [[TMP1:%.*]] = ashr i64 [[DATA]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = trunc i64 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow0 = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow0)
  %num_high_bits_to_smear_narrow1 = sub i32 32, %nbits ; will go away.
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow0
  call void @use32(i32 %signbit_positioned)
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow1
  ret i32 %signextended
}
define i32 @n8_extrause_bad(i64 %data, i32 %nbits) {
; CHECK-LABEL: @n8_extrause_bad(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i32 [[EXTRACTED_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    call void @use32(i32 [[SIGNBIT_POSITIONED]])
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = ashr i32 [[SIGNBIT_POSITIONED]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  call void @use32(i32 %signbit_positioned)
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow ; neither of operands will go away.
  ret i32 %signextended
}

; Negative tests
define i32 @n9(i64 %data, i32 %nbits) {
; CHECK-LABEL: @n9(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 63, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i32 [[EXTRACTED_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = ashr i32 [[SIGNBIT_POSITIONED]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 63, %nbits ; not 64
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow
  ret i32 %signextended
}

define i32 @n10(i64 %data, i32 %nbits) {
; CHECK-LABEL: @n10(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 31, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i32 [[EXTRACTED_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = ashr i32 [[SIGNBIT_POSITIONED]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 31, %nbits ; not 32
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow
  ret i32 %signextended
}

define i32 @n11(i64 %data, i32 %nbits1, i32 %nbits2) {
; CHECK-LABEL: @n11(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS1:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS2:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i32 [[EXTRACTED_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = ashr i32 [[SIGNBIT_POSITIONED]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 64, %nbits1 ; not %nbits2
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits2 ; not %nbits1
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow
  ret i32 %signextended
}

define i32 @n12(i64 %data, i32 %nbits1, i32 %nbits2) {
; CHECK-LABEL: @n12(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS1:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW1:%.*]] = sub i32 32, [[NBITS1]]
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW2:%.*]] = sub i32 32, [[NBITS2:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW1]])
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW2]])
; CHECK-NEXT:    [[SIGNBIT_POSITIONED:%.*]] = shl i32 [[EXTRACTED_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW1]]
; CHECK-NEXT:    [[SIGNEXTENDED:%.*]] = ashr i32 [[SIGNBIT_POSITIONED]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW2]]
; CHECK-NEXT:    ret i32 [[SIGNEXTENDED]]
;
  %skip_high = sub i32 64, %nbits1
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow1 = sub i32 32, %nbits1 ; not %nbits2
  %num_high_bits_to_smear_narrow2 = sub i32 32, %nbits2 ; not %nbits1
  call void @use32(i32 %num_high_bits_to_smear_narrow1)
  call void @use32(i32 %num_high_bits_to_smear_narrow2)
  %signbit_positioned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow1
  %signextended = ashr i32 %signbit_positioned, %num_high_bits_to_smear_narrow2
  ret i32 %signextended
}

define i32 @n13(i64 %data, i32 %nbits) {
; CHECK-LABEL: @n13(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 -1, [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    [[RES:%.*]] = and i32 [[TMP1]], [[EXTRACTED_NARROW]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %highbits_cleaned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  %res = lshr i32 %highbits_cleaned, %num_high_bits_to_smear_narrow ; not ashr
  ret i32 %res
}
define i32 @n13_extrause(i64 %data, i32 %nbits) {
; CHECK-LABEL: @n13_extrause(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = lshr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[HIGHBITS_CLEANED:%.*]] = shl i32 [[EXTRACTED_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    call void @use32(i32 [[HIGHBITS_CLEANED]])
; CHECK-NEXT:    [[RES:%.*]] = lshr i32 [[HIGHBITS_CLEANED]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = lshr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %highbits_cleaned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  call void @use32(i32 %highbits_cleaned)
  %res = lshr i32 %highbits_cleaned, %num_high_bits_to_smear_narrow ; not ashr
  ret i32 %res
}
define i32 @n14(i64 %data, i32 %nbits) {
; CHECK-LABEL: @n14(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = ashr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 -1, [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    [[RES:%.*]] = and i32 [[TMP1]], [[EXTRACTED_NARROW]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = ashr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %highbits_cleaned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  %res = lshr i32 %highbits_cleaned, %num_high_bits_to_smear_narrow ; not ashr
  ret i32 %res
}
define i32 @n14_extrause(i64 %data, i32 %nbits) {
; CHECK-LABEL: @n14_extrause(
; CHECK-NEXT:    [[SKIP_HIGH:%.*]] = sub i32 64, [[NBITS:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SKIP_HIGH]])
; CHECK-NEXT:    [[SKIP_HIGH_WIDE:%.*]] = zext i32 [[SKIP_HIGH]] to i64
; CHECK-NEXT:    call void @use64(i64 [[SKIP_HIGH_WIDE]])
; CHECK-NEXT:    [[EXTRACTED:%.*]] = ashr i64 [[DATA:%.*]], [[SKIP_HIGH_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[EXTRACTED]])
; CHECK-NEXT:    [[EXTRACTED_NARROW:%.*]] = trunc i64 [[EXTRACTED]] to i32
; CHECK-NEXT:    call void @use32(i32 [[EXTRACTED_NARROW]])
; CHECK-NEXT:    [[NUM_HIGH_BITS_TO_SMEAR_NARROW:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[NUM_HIGH_BITS_TO_SMEAR_NARROW]])
; CHECK-NEXT:    [[HIGHBITS_CLEANED:%.*]] = shl i32 [[EXTRACTED_NARROW]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    call void @use32(i32 [[HIGHBITS_CLEANED]])
; CHECK-NEXT:    [[RES:%.*]] = lshr i32 [[HIGHBITS_CLEANED]], [[NUM_HIGH_BITS_TO_SMEAR_NARROW]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %skip_high = sub i32 64, %nbits
  call void @use32(i32 %skip_high)
  %skip_high_wide = zext i32 %skip_high to i64
  call void @use64(i64 %skip_high_wide)
  %extracted = ashr i64 %data, %skip_high_wide
  call void @use64(i64 %extracted)
  %extracted_narrow = trunc i64 %extracted to i32
  call void @use32(i32 %extracted_narrow)
  %num_high_bits_to_smear_narrow = sub i32 32, %nbits
  call void @use32(i32 %num_high_bits_to_smear_narrow)
  %highbits_cleaned = shl i32 %extracted_narrow, %num_high_bits_to_smear_narrow
  call void @use32(i32 %highbits_cleaned)
  %res = lshr i32 %highbits_cleaned, %num_high_bits_to_smear_narrow ; not ashr
  ret i32 %res
}