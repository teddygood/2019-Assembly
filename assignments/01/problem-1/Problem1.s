	AREA	ARMex,CODE,READONLY
		ENTRY
		
TEMPADDR1 & &00001000

start
	MOV		r0, #15				; r0 = 15 (0F)
	MOV 	r1, #10				; r1 = 10 (0A)
	MOV 	r2, #5				; r2 = 5  (05)
	LDR 	r3, TEMPADDR1 		; 0x00001000
	
	STRB 	r0, [r3], #1		; 0x00001000: 0F
	STRB 	r1, [r3], #1		; 0x00001001: 0A
	STRB 	r2, [r3]			; 0x00001002: 05
	
	LDRB 	r4, [r3], #-1		; 0x00001002: 05
	CMP		r4, #10				; r4 = 5 < 10
	MOVGT 	r5, #1
	MOVLT 	r5, #2				; r5 = 2
	MOVEQ 	r5, #3
	
	LDRB  	r4, [r3], #-1		; 0x00001001: 10
	CMP 	r4, #10				; r4 = 10 = 10
	MOVGT 	r5, #1
	MOVLT 	r5, #2				
	MOVEQ 	r5, #3				; r5 = 3
	
	LDRB  	r4, [r3]			; 0x00001000: 15
	CMP 	r4, #10				; r4 = 15 > 10
	MOVGT 	r5, #1				; r5 = 1
	MOVLT 	r5, #2				
	MOVEQ 	r5, #3
	
	MOV pc, lr 
	END