	AREA	ARMex,CODE,READONLY
		ENTRY

Main
	LDR r0, =Array
	LDR r1, Address1
	MOV r3, #10
	MOV r5, #0
	; Start from the last 32-bit element so the output bytes are written in reverse order.
	SUB r4, r3, #1
	LSL r4, r4, #2

Loop
	; Each word holds a small integer, so STRB writes its low byte to the destination buffer.
	LDR r2, [r0, r4]
	STRB r2, [r1], #1
	SUB r4, r4, #4

	ADD r5, r5, #1		; Count how many array elements were emitted.
	CMP r5, r3			; Stop after all 10 entries have been copied.
	BNE Loop
	BEQ Endline

Endline
	MOV pc, lr

Array DCD 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
Address1 DCD &40000000
	END
