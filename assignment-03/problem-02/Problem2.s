	AREA	ARMex, CODE, READONLY
		ENTRY
Main
	; r1 counts from 1 to 10 and r2 keeps the running factorial value.
	LDR r3, Addr
	MOV r2, #1
	MOV r1, #1

Loop
	; Store 1!, 2!, ... , 10! sequentially to memory starting at Addr.
	MUL r2,r1,r2
	STR r2,[r3],#4
	CMP r1,#10
	ADDNE r1,#1 
	BNE Loop    
	
	MOV pc,lr
Addr DCD 0x40000
	END
