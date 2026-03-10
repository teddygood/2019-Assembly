	AREA	ARMex, CODE, READONLY
		ENTRY

Main
	LDR r0, Address1
	ADD r1, r1, #1			; r1 = 1
	LSL r1, r1, #1			; r1 = 2
	ADD r2, r2, r1			; r2 = 2
	LSL r1, r1, #1			; r1 = 4
	LSL r1, r1, #1			; r1 = 8
	ADD r4, r4, r1			; r4 = 8
	ADD r1, r1, r2			; r1 = 10 
	ADD r1, r1, #1			; r1 = 11
	ADD r3, r3, r1			; r3 = 11
	ADD r4, r4, r4			; r4 = 16
	ADD r4, r4, r1			; r4 = 27
	ADD r4, r4, r2			; r4 = 29


Loop
	ADD r3, r3, r2			; r3 = 11 + 2, r3 = 13 + 2 ... r3 = 27 + 2
	ADD r1, r1, r3			; r1 = 11 + 13 + 15 + ... + 27 + 29 = 200 = 0xC8
	CMP r3, r4				; if(r3 == 29) 
	BNE Loop				
	BEQ Endline		
	
	
Endline
	STR r1, [r0]
	MOV pc, lr
	
Address1 DCD &40000000
	
	END