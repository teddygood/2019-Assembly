	AREA Problem1, CODE, READONLY
		ENTRY
start
		LDR r0, value1		
		LDR r1, value2		

		CMP r0, #0
		MOVEQ r9, r1
		BEQ	store_result

		CMP r1, #0
		MOVEQ r9, r0
		BEQ	store_result
		
		MOV r2, r0, lsr #31 ;r0 sign bit
		MOV r3, r1, lsr #31	;r1 sign bit
	
		MOV r6, r0, lsl #9 	;r0 mantissa value
		MOV r6, r6, lsr #9
		MOV r7, r1, lsl #9	;r1 mantissa value
		MOV r7, r7, lsr #9
	
		MOV r0, r0, lsl #1	;r0 exponent value
		MOV r0, r0, lsr #24
		MOV r1, r1, lsl #1	;r1 exponent value
		MOV r1, r1, lsr #24

		MOV r5, #1
		ADD	r6, r6, r5, LSL #23				;add 1 to front of mantissa
		ADD	r7, r7, r5, LSL #23	
	
		SUBS	r8, r0, r1						;shiftNum
		ADDPL	r1, r1, r8						;equalize exponent
		LSRPL	r7, r8							;shift mantissa
		RSBMI	r8, r8, #0						;absolute value of shiftNum
		LSRMI	r6, r8							;shift mantissa
		
		CMP 	r2, r3								;compare sign bit
		ADDEQ	r9, r6, r7					;same sign bit, add mantissa
		SUBNE	r9, r6, r7					;different sign bit, sub mantissa
		MOVPL	r10, r2							;new sign bit
		RSBMI	r9, r9, #0						;absolute value of mantissa
		MOVMI	r10, r3							;new sign bit
		
normalize											;normalize
		MOV r11, r9, LSR #23				;compare first digit
		CMP	r11, r5
		BEQ	Endline							;normalize finish
		LSRPL	r9, #1							;shift right
		ADDPL	r1, r1, #1						;add exponent
		LSLMI	r9, #1							;shift left
		SUBMI	r1, r1, #1						;sub exponent
		B	normalize								;loop normalize
		
Endline											;Endline
		SUB	r9, r9, r5, LSL #23					;sub from front of mantissa
		ADD	r9, r9, r1, LSL #23				;add exponent
		ADD	r9, r9, r10, LSL #31				;add sign
		
store_result
		LDR	r4, temp				
		STR	r9, [r4]							;store result
		
		MOV	pc, #0
	
value1 & 0x3f800004	; example input 1
value2 & 0xbf800001	; example input 2
; value1 & 0x00000000	; zero input example
temp & &40000000
	
	end
