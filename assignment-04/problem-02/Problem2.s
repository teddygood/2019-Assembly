	AREA Problem1, CODE, READONLY
		
main
	LDR r10, ADDR	; address
	MOV r0, #10 
	MOV r1, #11
	MOV r2, #12
	MOV r3, #13
	MOV r4, #14
	MOV r5, #15
	MOV r6, #16
	MOV r7, #17
	MOV r8, #160		; r8 = 160	
	STMFD sp!, {r0-r7}	; push into stack
	
	MOV lr, pc
	B doRegister
	MOV lr, pc
	B doGCD
	
	ADD r0, r0, #10
	ADD r1, r1, #11
	ADD r2, r2, #12
	ADD r3, r3, #13
	ADD r4, r4, #14
	ADD r5, r5, #15
	ADD r6, r6, #16
	ADD r7, r7, #17
	
	STR r8, [r10], #4
	STR r0, [r10], #4
	STR r1, [r10], #4
	STR r2, [r10], #4
	STR r3, [r10], #4
	STR r4, [r10], #4
	STR r5, [r10], #4
	STR r6, [r10], #4
	STR r7, [r10]
	B stop

doRegister
	LDMFD sp!, {r0-r7}		; pop from stack 
	
	ADD r0, r0, #0		; r0 = r0 + ( r0 index )
	ADD r1, r1, #1		; r1 = r1 + ( r1 index )					
	ADD r2, r2, #2		; r2 = r2 + ( r2 index )
	ADD r3, r3, #3		; r3 = r3 + ( r3 index )
	ADD r4, r4, #4		; r4 = r4 + ( r4 index )					 
	ADD r5, r5, #5		; r5 = r5 + ( r5 index )					
	ADD r6, r6, #6		; r6 = r6 + ( r6 index )					
	ADD r7, r7, #7		; r7 = r7 + ( r7 index )
	
	ADD r9, r0, r1		; r9 = r0 + r1
	ADD r9, r9, r2		; r9 = r0 + r2
	ADD r9, r9, r3		; r9 = r0 + r3
	ADD r9, r9, r4		; r9 = r0 + r4
	ADD r9, r9, r5		; r9 = r0 + r5
	ADD r9, r9, r6		; r9 = r0 + r6
	ADD r9, r9, r7		; r9 = r0 + r7

	MOV pc, lr						; return
	
doGCD
	CMP r9, r8
	SUBGT r9, r9, r8		; r9 = r9 - r8
	SUBLT r8, r8, r9		; r8 = r8 - r9
	BNE doGCD				; r9 !=r8
	
	MOV pc, lr				; r9 == r8 -> return
	
stop
	MOV pc, #0
	
ADDR & &00040000
	END	
	
	
