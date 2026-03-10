	AREA	ARMex,CODE,READONLY
		ENTRY

Main
	LDR r0, =Value1		
	LDR r1, =Value2		
	LDR r2, Address1	
	MOV r5, #10			; r5=0x0A ==
	MOV r6, #11			; r6=0x0B !=
	
Loop
	LDRB r3, [r0], #1
	LDRB r4, [r1], #1

Comp	
	CMP r3, r4
	BEQ Equal
	BNE NonEqual

Equal
	STR r5, [r2]		; when 0 0 
	B FinishCheck1
	
NonEqual
	STR r6, [r2]
	B Endline

FinishCheck1
	CMP r3, #0
	; BEQ Endline
	BAL FinishCheck2
	
FinishCheck2
	CMP r4, #0
	BEQ Endline
	BNE Loop
	
Endline
	MOV pc, lr
	
Value1 DCB "ABE", 0
Value2 DCB "AC", 0
Address1 DCD &40000000
	
	END
		