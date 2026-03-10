	AREA Problem1, CODE, READONLY
		
start
	MOV r0, #0 	; r0 = 0
	MOV r1, #1 	; r1 = 1
	MOV r2, #2 	; r2 = 2
	MOV r3, #3 	; r3 = 3
	MOV r4, #4 	; r4 = 4
	MOV r5, #5 	; r5 = 5
	MOV r6, #6 	; r6 = 6
	MOV r7, #7 	; r7 = 7
	
	STMFD sp!, {r0-r7}			; push into stack
	
	LDMFD sp!, {r1, r6}			; pop from stack 
	LDMFD sp!, {r0, r2, r7}		; pop from stack 
	LDMFD sp!, {r3-r5}			; pop from stack
	
	MOV pc, #0
		
	END