	AREA	ARMex,CODE,READONLY
		ENTRY
		
start
	MOV r0, #1	; r0 = 1
	MOV r1, #2	; r1 = 2
	MOV r2, #3	; r2 = 3
	MOV r3, #4	; r3 = 4

	LDR	r4, TEMPADDR4 ; start address 0x00001000
	
	STRB r3, [r4], #1		; 0x00001000: 	04
	STRB r2, [r4], #1		; 0x00001001: 	04 03
	STRB r1, [r4], #1		; 0x00001002: 	04 03 02
	STRB r0, [r4], #1		; 0x00001003: 	04 03 02 01
	STRB r0, [r4], #1		; 0x00001004: 	04 03 02 01 01
	STRB r1, [r4], #1		; 0x00001005: 	04 03 02 01 01 02
	STRB r2, [r4], #1		; 0x00001006: 	04 03 02 01 01 02 03
	STRB r3, [r4]			; 0x00001007: 	04 03 02 01 01 02 03 04
									
	LDR r5, [r4, #-3]! 		; r5 = 0x04030201 (0x00001007 ~ 0x00001004)	
	LDR r6, [r4, #-4]!		; r6 = 0x01020304 (0x00001003 ~ 0x00001000)
	
	
TEMPADDR4 & &00001000
	MOV pc,lr
	END