	AREA	ARMex,CODE,READONLY
		ENTRY

Main
	LDR r0, Addr
	MOV r3,#1			   ; 1!
	STR r3, [r0], #4
	MOV r4, r3, LSL #1     ; 2!
	STR r4, [r0], #4
	ADD r1, r4,r4, LSL #1  ; 3!
	STR r1, [r0], #4
	MOV r4, r1, LSL #2	   ; 4!
	STR r4, [r0], #4
	ADD r1, r4,r4, LSL #2  ; 5!
	STR r1, [r0], #4
	MOV r2, r1, LSL #1	   ; 2*5!
	ADD r4, r2, r1, LSL #2 ; 2*5!+4*5!=6!
	STR r4, [r0], #4
	RSB r1, r4, r4, LSL #3 ; 7!
	STR r1, [r0], #4
	MOV r4, r1, LSL #3     ; 8!
	STR r4, [r0], #4
	ADD r1, r4, r4, LSL #3 ; 9!
	STR r1, [r0], #4
	MOV r2, r1, LSL #1;    ; 2*9!
	ADD r4, r2, r1, LSL #3 ; 8*9!+2*9!=10!
	STR r4, [r0], #4
	MOV pc,lr
Addr DCD &40000
	END