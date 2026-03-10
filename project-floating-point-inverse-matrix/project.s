	AREA	ARMex, CODE, READONLY
		ENTRY

Main
		MOV		sp, #0x4000
		LDR		r11, Result_data			; workspace / final output base
		LDR		r1, =Matrix_data
		LDR		r8, [r1], #4				; N
		ADD		r9, r8, r8					; total columns in augmented matrix = 2N
		MOV		r10, r8, LSL #3			; row stride bytes = 2N * 4
		LDR		r12, OneFloat

		; Build [A | I] at Result_data.
		MOV		r0, r11
		MOV		r4, #0

Init_Row
		CMP		r4, r8
		BEQ		Elimination_Start

		MOV		r5, #0

Init_Left
		CMP		r5, r8
		BEQ		Init_Right
		LDR		r6, [r1], #4
		STR		r6, [r0], #4
		ADD		r5, r5, #1
		B		Init_Left

Init_Right
		MOV		r5, #0

Init_Right_Loop
		CMP		r5, r8
		BEQ		Init_Next_Row
		CMP		r5, r4
		STREQ	r12, [r0], #4
		MOVNE	r6, #0
		STRNE	r6, [r0], #4
		ADD		r5, r5, #1
		B		Init_Right_Loop

Init_Next_Row
		ADD		r4, r4, #1
		B		Init_Row

Elimination_Start
		MOV		r4, #0						; pivot index
		MOV		r6, r11						; pivot row base pointer

Pivot_Loop
		CMP		r4, r8
		BEQ		Compact_Result

		; Partial pivoting: pick the largest absolute value in the pivot column.
		MOV		r0, r6						; best row pointer
		MOV		r1, r6						; scan row pointer
		MOV		r2, #0						; best magnitude bits
		MOV		r5, r4

Find_Pivot
		ADD		r3, r1, r4, LSL #2
		LDR		r12, [r3]
		MOV		r12, r12, LSL #1			; absolute-value proxy for compare
		CMP		r12, r2
		MOVHI	r2, r12
		MOVHI	r0, r1
		ADD		r5, r5, #1
		ADD		r1, r1, r10
		CMP		r5, r8
		BLT		Find_Pivot

		CMP		r2, #0
		BEQ		Program_End

		CMP		r0, r6
		BEQ		Pivot_Row_Ready
		MOV		r1, r6
		MOV		r2, r9
		BL		Swap_Rows

Pivot_Row_Ready
		ADD		r1, r6, r4, LSL #2
		LDR		r1, [r1]					; pivot value
		MOV		r0, r6
		MOV		r2, r9
		BL		Row_Divide

		MOV		r5, #0
		MOV		r7, r11

Eliminate_Row_Loop
		CMP		r5, r8
		BEQ		Next_Pivot
		CMP		r5, r4
		BEQ		Skip_Row

		ADD		r1, r7, r4, LSL #2
		LDR		r3, [r1]					; factor = row[col]
		CMP		r3, #0
		BEQ		Skip_Row

		MOV		r0, r7
		MOV		r1, r6
		MOV		r2, r9
		BL		Row_Eliminate

Skip_Row
		ADD		r5, r5, #1
		ADD		r7, r7, r10
		B		Eliminate_Row_Loop

Next_Pivot
		ADD		r4, r4, #1
		ADD		r6, r6, r10
		B		Pivot_Loop

Compact_Result
		; Copy the inverse matrix (right half) back to Result_data as a dense NxN matrix.
		MOV		r4, #0
		MOV		r5, r11						; row base
		MOV		r6, r11						; compact destination
		MOV		r7, r8, LSL #2				; offset to right half

Compact_Row
		CMP		r4, r8
		BEQ		Program_End
		ADD		r0, r5, r7
		MOV		r1, r8

Compact_Col
		LDR		r2, [r0], #4
		STR		r2, [r6], #4
		SUBS	r1, r1, #1
		BNE		Compact_Col

		ADD		r5, r5, r10
		ADD		r4, r4, #1
		B		Compact_Row

Program_End
		MOV		pc, #0

OneFloat	DCD	0x3F800000
		LTORG

; -----------------------------------------------------------------------------
; Row helpers
; -----------------------------------------------------------------------------

Swap_Rows
		; r0 = row A, r1 = row B, r2 = word count
		STMFD	sp!, {r4-r7, lr}
		MOV		r4, r0
		MOV		r5, r1
		MOV		r6, r2

Swap_Row_Loop
		CMP		r6, #0
		BEQ		Swap_Row_Done
		LDR		r0, [r4]
		LDR		r1, [r5]
		STR		r1, [r4], #4
		STR		r0, [r5], #4
		SUB		r6, r6, #1
		B		Swap_Row_Loop

Swap_Row_Done
		LDMFD	sp!, {r4-r7, pc}

Row_Divide
		; r0 = row pointer, r1 = pivot, r2 = word count
		STMFD	sp!, {r4-r7, lr}
		MOV		r4, r0
		MOV		r5, r1
		MOV		r6, r2

Row_Divide_Loop
		CMP		r6, #0
		BEQ		Row_Divide_Done
		LDR		r0, [r4]
		MOV		r1, r5
		BL		FP_DIV
		STR		r0, [r4], #4
		SUB		r6, r6, #1
		B		Row_Divide_Loop

Row_Divide_Done
		LDMFD	sp!, {r4-r7, pc}

Row_Eliminate
		; r0 = target row, r1 = pivot row, r2 = word count, r3 = factor
		STMFD	sp!, {r4-r11, lr}
		MOV		r8, r0
		MOV		r9, r1
		MOV		r10, r2
		MOV		r11, r3

Row_Eliminate_Loop
		CMP		r10, #0
		BEQ		Row_Eliminate_Done

		LDR		r4, [r8]
		LDR		r5, [r9], #4
		MOV		r0, r5
		MOV		r1, r11
		BL		FP_MUL
		MOV		r1, r0
		MOV		r0, r4
		BL		FP_SUB
		STR		r0, [r8], #4

		SUB		r10, r10, #1
		B		Row_Eliminate_Loop

Row_Eliminate_Done
		LDMFD	sp!, {r4-r11, pc}

; -----------------------------------------------------------------------------
; Floating-point helpers
; -----------------------------------------------------------------------------

FP_SUB
		EOR		r1, r1, #0x80000000
		B		FP_ADD

FP_ADD
		; r0 = value A, r1 = value B
		STMFD	sp!, {r2-r11, lr}

		MOV		r2, r0, LSL #1
		CMP		r2, #0
		MOVEQ	r0, r1
		BEQ		FP_ADD_Done

		MOV		r2, r1, LSL #1
		CMP		r2, #0
		BEQ		FP_ADD_Done

		MOV		r2, r0, LSR #31			; sign A
		MOV		r3, r1, LSR #31			; sign B

		MOV		r4, r0, LSL #9			; mantissa A
		MOV		r4, r4, LSR #9
		MOV		r5, r1, LSL #9			; mantissa B
		MOV		r5, r5, LSR #9

		MOV		r12, #1
		ADD		r4, r4, r12, LSL #23
		ADD		r5, r5, r12, LSL #23

		MOV		r6, r0, LSL #1			; exponent A
		MOV		r6, r6, LSR #24
		MOV		r7, r1, LSL #1			; exponent B
		MOV		r7, r7, LSR #24

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

FP_MUL
		; r0 = value A, r1 = value B
		STMFD	sp!, {r2-r11, lr}

		MOV		r2, r0, LSL #1
		CMP		r2, #0
		MOVEQ	r0, #0
		BEQ		FP_MUL_Done

		MOV		r2, r1, LSL #1
		CMP		r2, #0
		MOVEQ	r0, #0
		BEQ		FP_MUL_Done

		MOV		r2, r0, LSR #31
		MOV		r3, r1, LSR #31
		EOR		r11, r2, r3

		MOV		r4, r0, LSL #1
		MOV		r4, r4, LSR #24
		MOV		r5, r1, LSL #1
		MOV		r5, r5, LSR #24
		ADD		r8, r4, r5
		SUB		r8, r8, #127

		MOV		r6, r0, LSL #9
		MOV		r6, r6, LSR #9
		MOV		r7, r1, LSL #9
		MOV		r7, r7, LSR #9
		MOV		r12, #1
		ADD		r6, r6, r12, LSL #23
		ADD		r7, r7, r12, LSL #23

		MOV		r0, r6
		MOV		r1, r7
		BL		UMUL24

		MOV		r9, r0						; product low
		MOV		r10, r1						; product high
		TST		r10, #0x00008000			; bit 47
		BEQ		FP_MUL_No_Shift

		MOV		r6, r10, LSL #8
		ORR		r6, r6, r9, LSR #24
		ADD		r8, r8, #1
		B		FP_MUL_Pack

FP_MUL_No_Shift
		MOV		r6, r10, LSL #9
		ORR		r6, r6, r9, LSR #23

FP_MUL_Pack
		CMP		r8, #0
		MOVLE	r0, #0
		BLE		FP_MUL_Done
		CMP		r8, #255
		MOVGE	r8, #254
		SUB		r6, r6, r12, LSL #23
		MOV		r0, r11, LSL #31
		ADD		r0, r0, r8, LSL #23
		ADD		r0, r0, r6

FP_MUL_Done
		LDMFD	sp!, {r2-r11, pc}

FP_DIV
		; r0 = numerator, r1 = denominator
		STMFD	sp!, {r2-r11, lr}

		MOV		r2, r0, LSL #1
		CMP		r2, #0
		MOVEQ	r0, #0
		BEQ		FP_DIV_Done

		MOV		r2, r1, LSL #1
		CMP		r2, #0
		MOVEQ	r0, #0
		BEQ		FP_DIV_Done

		MOV		r2, r0, LSR #31
		MOV		r3, r1, LSR #31
		EOR		r11, r2, r3

		MOV		r4, r0, LSL #1
		MOV		r4, r4, LSR #24
		MOV		r5, r1, LSL #1
		MOV		r5, r5, LSR #24
		SUB		r8, r4, r5
		ADD		r8, r8, #127

		MOV		r6, r0, LSL #9
		MOV		r6, r6, LSR #9
		MOV		r7, r1, LSL #9
		MOV		r7, r7, LSR #9
		MOV		r12, #1
		ADD		r6, r6, r12, LSL #23
		ADD		r7, r7, r12, LSL #23

		MOV		r0, r6, LSR #9			; numerator high for (mantissa << 23)
		MOV		r1, r6, LSL #23			; numerator low
		MOV		r2, r7
		BL		UDIV64_32

		MOV		r6, r0					; quotient mantissa
		CMP		r6, r12, LSL #23
		BHS		FP_DIV_Check_High
		MOV		r6, r6, LSL #1
		SUB		r8, r8, #1
		B		FP_DIV_Pack

FP_DIV_Check_High
		CMP		r6, r12, LSL #24
		MOVHS	r6, r6, LSR #1
		ADDHS	r8, r8, #1

FP_DIV_Pack
		CMP		r8, #0
		MOVLE	r0, #0
		BLE		FP_DIV_Done
		CMP		r8, #255
		MOVGE	r8, #254
		SUB		r6, r6, r12, LSL #23
		MOV		r0, r11, LSL #31
		ADD		r0, r0, r8, LSL #23
		ADD		r0, r0, r6

FP_DIV_Done
		LDMFD	sp!, {r2-r11, pc}

; -----------------------------------------------------------------------------
; Integer helpers for mantissa operations
; -----------------------------------------------------------------------------

UMUL24
		; r0 = multiplicand (24-bit), r1 = multiplier (24-bit)
		; returns r0 = low 32 bits, r1 = high 32 bits
		STMFD	sp!, {r2-r6, lr}
		MOV		r2, #0						; product low
		MOV		r3, #0						; product high
		MOV		r4, r0						; multiplicand low
		MOV		r5, #0						; multiplicand high
		MOV		r6, #24

UMUL24_Loop
		TST		r1, #1
		ADDSNE	r2, r2, r4
		ADCNE	r3, r3, r5
		MOV		r5, r5, LSL #1
		ORR		r5, r5, r4, LSR #31
		MOV		r4, r4, LSL #1
		MOV		r1, r1, LSR #1
		SUBS	r6, r6, #1
		BNE		UMUL24_Loop

		MOV		r0, r2
		MOV		r1, r3
		LDMFD	sp!, {r2-r6, pc}

UDIV64_32
		; r0:r1 = numerator, r2 = denominator
		; returns r0 = quotient
		STMFD	sp!, {r3-r8, lr}
		MOV		r3, #0						; quotient
		MOV		r4, #1
		MOV		r4, r4, LSL #31			; current quotient bit
		MOV		r5, #31

UDIV64_32_Loop
		CMP		r5, #0
		BLT		UDIV64_32_Done

		CMP		r5, #0
		MOVEQ	r6, #0
		MOVEQ	r7, r2
		MOVNE	r7, r2, LSL r5
		RSBNE	r8, r5, #32
		MOVNE	r6, r2, LSR r8

		CMP		r0, r6
		BLO		UDIV64_32_Skip
		BHI		UDIV64_32_Subtract
		CMP		r1, r7
		BLO		UDIV64_32_Skip

UDIV64_32_Subtract
		SUBS	r1, r1, r7
		SBC		r0, r0, r6
		ORR		r3, r3, r4

UDIV64_32_Skip
		MOV		r4, r4, LSR #1
		SUB		r5, r5, #1
		B		UDIV64_32_Loop

UDIV64_32_Done
		MOV		r0, r3
		LDMFD	sp!, {r3-r8, pc}

Result_data	DCD	0x60000000

	AREA	MatrixArea, DATA
Matrix_data
	DCD	3
	DCD	2_01000010100010000000000000000000
	DCD	2_01000010010001000000000000000000
	DCD	2_11000010011110000000000000000000
	DCD	2_11000001011010000000000000000000
	DCD	2_01000001000010000000000000000000
	DCD	2_01000100001100000000000000000000
	DCD	2_01000010101111000000000000000000
	DCD	2_01000011100111000000000000000000
	DCD	2_11000000011100000000000000000000

	END
