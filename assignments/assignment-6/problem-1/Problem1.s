	AREA ARMex, CODE, READONLY
		ENTRY

Main
	; r0 walks the source string and r2 writes the copied bytes to Address1.
	LDR r0, =C_string1
	LDR r2, Address1

Loop
	; Copy until the terminating NULL byte is written as well.
	LDRB r1, [r0], #1
	STRB r1, [r2], #1
	CMP r1, #0
	BNE Loop

Endline
	MOV pc, #0

C_string1 DCB "Hello world !!!", 0
Address1 DCD &40000000

	END
