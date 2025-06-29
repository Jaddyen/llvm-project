; REQUIRES: x86-registered-target

; RUN: opt -mtriple=i686-unknown-linux -S -passes=lowertypetests -lowertypetests-summary-action=export -lowertypetests-read-summary=%S/Inputs/use-typeid1-typeid2.yaml -lowertypetests-write-summary=%t %s | FileCheck --check-prefixes=CHECK,CHECK-X86-32 %s
; RUN: FileCheck --check-prefixes=SUMMARY,SUMMARY-X86,SUMMARY-X86-32 %s < %t

; RUN: opt -mtriple=x86_64-unknown-linux -S -passes=lowertypetests -lowertypetests-summary-action=export -lowertypetests-read-summary=%S/Inputs/use-typeid1-typeid2.yaml -lowertypetests-write-summary=%t %s | FileCheck --check-prefixes=CHECK,CHECK-64 %s
; RUN: FileCheck --check-prefixes=SUMMARY,SUMMARY-X86,SUMMARY-64 %s < %t

; RUN: opt -mtriple=aarch64-unknown-linux -S -passes=lowertypetests -lowertypetests-summary-action=export -lowertypetests-read-summary=%S/Inputs/use-typeid1-typeid2.yaml -lowertypetests-write-summary=%t %s | FileCheck --check-prefixes=CHECK,CHECK-64 %s
; RUN: FileCheck --check-prefixes=SUMMARY,SUMMARY-64,SUMMARY-ARM %s < %t

@foo = constant [2048 x i8] zeroinitializer, !type !0, !type !1, !type !2, !type !3

!0 = !{i32 0, !"typeid1"}
!1 = !{i32 6, !"typeid1"}
!2 = !{i32 4, !"typeid2"}
!3 = !{i32 136, !"typeid2"}

; CHECK: [[G:@[0-9]+]] = private constant { [2048 x i8] } zeroinitializer

; CHECK-X86-32: @__typeid_typeid1_global_addr = hidden alias i8, getelementptr (i8, ptr [[G]], i32 6)
; CHECK-64: @__typeid_typeid1_global_addr = hidden alias i8, getelementptr (i8, ptr [[G]], i64 6)
; CHECK-X86: @__typeid_typeid1_align = hidden alias i8, inttoptr (i8 1 to ptr)
; CHECK-X86: @__typeid_typeid1_size_m1 = hidden alias i8, inttoptr (i64 3 to ptr)
; CHECK-X86: @__typeid_typeid1_inline_bits = hidden alias i8, inttoptr (i32 9 to ptr)

; CHECK-X86-32: @__typeid_typeid2_global_addr = hidden alias i8, getelementptr (i8, ptr [[G]], i32 136)
; CHECK-64: @__typeid_typeid2_global_addr = hidden alias i8, getelementptr (i8, ptr [[G]], i64 136)
; CHECK-X86: @__typeid_typeid2_align = hidden alias i8, inttoptr (i8 2 to ptr)
; CHECK-X86: @__typeid_typeid2_size_m1 = hidden alias i8, inttoptr (i64 33 to ptr)
; CHECK-X86-64: @__typeid_typeid2_inline_bits = hidden alias i8, inttoptr (i64 8589934593 to ptr)
; CHECK-X86-32: @__typeid_typeid2_byte_array = hidden alias i8, ptr @bits
; CHECK-X86-32: @__typeid_typeid2_bit_mask = hidden alias i8, inttoptr (i8 1 to ptr)

; CHECK: @foo = alias [2048 x i8], ptr [[G]]

; SUMMARY:      TypeIdMap:
; SUMMARY-NEXT:   typeid1:
; SUMMARY-NEXT:     TTRes:
; SUMMARY-NEXT:       Kind:            Inline
; SUMMARY-NEXT:       SizeM1BitWidth:  5
; SUMMARY-X86-NEXT:   AlignLog2:       0
; SUMMARY-X86-NEXT:   SizeM1:          0
; SUMMARY-X86-NEXT:   BitMask:         0
; SUMMARY-X86-NEXT:   InlineBits:      0
; SUMMARY-ARM-NEXT:   AlignLog2:       1
; SUMMARY-ARM-NEXT:   SizeM1:          3
; SUMMARY-ARM-NEXT:   BitMask:         0
; SUMMARY-ARM-NEXT:   InlineBits:      9
; SUMMARY-NEXT:     WPDRes:
; SUMMARY-NEXT:   typeid2:
; SUMMARY-NEXT:     TTRes:
; SUMMARY-X86-32-NEXT: Kind:           ByteArray
; SUMMARY-X86-32-NEXT: SizeM1BitWidth: 7
; SUMMARY-64-NEXT:    Kind:            Inline
; SUMMARY-64-NEXT:    SizeM1BitWidth:  6
; SUMMARY-X86-NEXT:   AlignLog2:       0
; SUMMARY-X86-NEXT:   SizeM1:          0
; SUMMARY-X86-NEXT:   BitMask:         0
; SUMMARY-X86-NEXT:   InlineBits:      0
; SUMMARY-ARM-NEXT:   AlignLog2:       2
; SUMMARY-ARM-NEXT:   SizeM1:          33
; SUMMARY-ARM-NEXT:   BitMask:         0
; SUMMARY-ARM-NEXT:   InlineBits:      8589934593
; SUMMARY-NEXT:     WPDRes:
