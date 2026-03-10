	AREA	ARMex,CODE,READONLY
		ENTRY

Main
	LDR r1, =Matrix_data	;Address where Matrix data is stored
	LDR r3, [r1], #4	;Matrix Size
	
	;; Inverse_Matrix Initialization ;;
	LDR r0, Result_data
	

Data_Load
	MOV r4, #4
	MUL r4, r3, r4
	LDR r5, [r1], r4
	LDR r6, [r1]
	LDR r11, [r2], r4
	LDR r12, [r2]
	
	B FP_DIVISION
	
FP_DIVISION
	
	
	
	B FP_MULTIPLICATION

FP_MULTIPLICATION

	
	
	B FP_ADDTION
	
FP_ADDTION

start
		LDR r0, value1		
		LDR r1, value2		
		
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
		
		LDR	r4, temp				
		STR	r9, [r4]							;store result
		
		MOV	pc, #0

Result_data DCD 0x60000000		;Result_data address
	
	AREA	matrix, DATA	;Matrix Size, Matrix_data AREA
Matrix_data
	DCD 3
	DCD 2_01000010100010000000000000000000
	DCD 2_01000010010001000000000000000000
	DCD 2_11000010011110000000000000000000
	DCD 2_11000001011010000000000000000000
	DCD 2_01000001000010000000000000000000
	DCD 2_01000100001100000000000000000000
	DCD 2_01000010101111000000000000000000
	DCD 2_01000011100111000000000000000000
	DCD 2_11000000011100000000000000000000
		