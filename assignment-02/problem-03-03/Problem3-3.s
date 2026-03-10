	AREA	ARMex, CODE, READONLY
		ENTRY
	
Main
	LDR r0, Address1
	
	MOV r1, #11		; r1 = 11
	ADD r2, r1, #2	; r2 = 13
	ADD r1, r1, r2	; r1 = 11 + 13
	ADD r2, r2, #2	; r2 = 15
	ADD r1, r1, r2	; r1 = 11 + 13 + 15
	ADD r2, r2, #2	; r2 = 17
	ADD r1, r1, r2	; r1 = 11 + 13 + 15 + 17
	ADD r2, r2, #2	; r2 = 19
	ADD r1, r1, r2 	; r1 = 11 + 13 + 15 + 17 + 19
	ADD r2, r2, #2	; r2 = 21
	ADD r1, r1, r2	; r1 = 11 + 13 + 15  + 17 + 19 + 21
	ADD r2, r2, #2 	; r2 = 23
	ADD r1, r1, r2	; r1 = 11 + 13 + 15 + 17 + 19 + 21 + 23
	ADD r2, r2, #2	; r2 = 25
	ADD r1, r1, r2	; r1 = 11 + 13 + 15 + 17 + 19 + 21 + 23 + 25
	ADD r2, r2, #2	; r2 = 27
	ADD r1, r1, r2	; r1 = 11 + 13 + 15 + 17 + 19 + 21 + 23 + 25 + 27
	ADD r2, r2, #2	; r2 = 29
	ADD r1, r1, r2	; r1 = 11 + 13 + 15 + 17 + 19 + 21 + 23 + 25 + 27 + 29 = 200 = 0xC8
	
	STR r1, [r0] 	; 0xC8
	
	MOV pc, lr
	
Address1 DCD &40000000
	END