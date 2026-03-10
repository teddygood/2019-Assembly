	AREA Problem1, CODE, READONLY
		ENTRY

start
		LDR		r0, value1
		LDR		r1, value2
		; FP_ADD returns the IEEE754 single-precision sum in r0.
		BL		FP_ADD

		LDR		r4, temp
		STR		r0, [r4]
		MOV		pc, #0

FP_ADD
		STMFD	sp!, {r2-r11, lr}

		; Treat zero operands as fast paths before unpacking sign/exponent/fraction.
		MOV		r2, r0, LSL #1
		CMP		r2, #0
		MOVEQ	r0, r1
		BEQ		FP_ADD_Done

		MOV		r2, r1, LSL #1
		CMP		r2, #0
		BEQ		FP_ADD_Done

		MOV		r2, r0, LSR #31
		MOV		r3, r1, LSR #31

		; Extract mantissas and restore the implicit leading 1 for normalized values.
		MOV		r4, r0, LSL #9
		MOV		r4, r4, LSR #9
		MOV		r5, r1, LSL #9
		MOV		r5, r5, LSR #9

		MOV		r12, #1
		ADD		r4, r4, r12, LSL #23
		ADD		r5, r5, r12, LSL #23

		MOV		r6, r0, LSL #1
		MOV		r6, r6, LSR #24
		MOV		r7, r1, LSL #1
		MOV		r7, r7, LSR #24

		; Align the smaller operand so both mantissas share the larger exponent.
		SUBS	r8, r6, r7
		MOV		r9, r6
		BEQ		FP_ADD_Aligned
		BGT		FP_ADD_A_Bigger

		RSB		r8, r8, #0
		CMP		r8, #31
		MOVGE	r4, #0
		MOVLT	r4, r4, LSR r8
		MOV		r9, r7
		B		FP_ADD_Aligned

FP_ADD_A_Bigger
		CMP		r8, #31
		MOVGE	r5, #0
		MOVLT	r5, r5, LSR r8
		MOV		r9, r6

FP_ADD_Aligned
		; Different signs mean subtraction; same signs mean pure mantissa addition.
		CMP		r2, r3
		BEQ		FP_ADD_Same_Sign

		CMP		r4, r5
		SUBHS	r10, r4, r5
		MOVHS	r11, r2
		SUBLO	r10, r5, r4
		MOVLO	r11, r3

		CMP		r10, #0
		MOVEQ	r0, #0
		BEQ		FP_ADD_Done

FP_ADD_Sub_Normalize
		; Left-normalize after subtraction until the hidden leading 1 is restored.
		CMP		r10, r12, LSL #23
		BHS		FP_ADD_Pack
		MOV		r10, r10, LSL #1
		SUB		r9, r9, #1
		CMP		r9, #0
		MOVEQ	r0, #0
		BEQ		FP_ADD_Done
		B		FP_ADD_Sub_Normalize

FP_ADD_Same_Sign
		ADD		r10, r4, r5
		MOV		r11, r2
		CMP		r10, r12, LSL #24
		MOVHS	r10, r10, LSR #1
		ADDHS	r9, r9, #1

FP_ADD_Pack
		; Repack sign, exponent, and fraction into the final IEEE754 word.
		CMP		r9, #0
		MOVLE	r0, #0
		BLE		FP_ADD_Done
		CMP		r9, #255
		MOVGE	r9, #254
		SUB		r10, r10, r12, LSL #23
		MOV		r0, r11, LSL #31
		ADD		r0, r0, r9, LSL #23
		ADD		r0, r0, r10

FP_ADD_Done
		LDMFD	sp!, {r2-r11, pc}

value1 & 0x3f800004
value2 & 0xbf800001
temp & &40000000

	END
