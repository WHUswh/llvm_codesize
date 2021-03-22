; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -target-abi ilp32f -verify-machineinstrs \
; RUN:   < %s | FileCheck -check-prefix=RV32IF %s
; RUN: llc -mtriple=riscv64 -mattr=+f -target-abi lp64f -verify-machineinstrs \
; RUN:   < %s | FileCheck -check-prefix=RV64IF %s

define zeroext i1 @float_is_nan(float %a) nounwind {
; RV32IF-LABEL: float_is_nan:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    feq.s a0, fa0, fa0
; RV32IF-NEXT:    seqz a0, a0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: float_is_nan:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    feq.s a0, fa0, fa0
; RV64IF-NEXT:    seqz a0, a0
; RV64IF-NEXT:    ret
  %1 = fcmp uno float %a, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @float_not_nan(float %a) nounwind {
; RV32IF-LABEL: float_not_nan:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    feq.s a0, fa0, fa0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: float_not_nan:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    feq.s a0, fa0, fa0
; RV64IF-NEXT:    ret
  %1 = fcmp ord float %a, 0.000000e+00
  ret i1 %1
}