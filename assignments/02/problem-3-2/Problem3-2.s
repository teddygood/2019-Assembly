	AREA	ARMex, CODE, READONLY
		ENTRY

Main
	LDR r0, Address1
	MOV r1, #0
	MOV r2, #0
	
	ADD r1, r1, #1			; r1 = 1
	LSL r1, r1, #3			; r1 = 8
	ADD r2, r2, #1			; r2 = 1
	LSL r2, r2, #1			; r2 = 2
	ADD r1, r1, r2			; r1 = 10 
	
	ADD r2, r1, r1 			; r2 = 20	(n+10)
	MUL r1, r2, r1 			; r2 = 200	n(n+10)
	
	STR r1, [r0]			; 0xC8
	
	MOV pc, lr
	
Address1 DCD &40000000
	
	END
