	; **********************************
	;  File: countbits.s
	;  Programmer: Garrett McMillan
	;  Description: A ARM Assembly program that counts
	;		the bits (1's or 0's) 
	;		in a given hex number 
	;  Project: countbits.arj               
	;  Date: October 15, 2012
	;************************************
		AREA randomcounter, CODE, READONLY
		IMPORT randomnumber
		IMPORT seed
SWI_WriteC	EQU	&0     			; output character in r0 
SWI_Exit	EQU	&11    			; finish program
		ENTRY
		MOV	r4, #10			; store 10 in a counter
mainLoop	BL	randomnumber		; begin loop - acquire random number
		MOV	r1, r0			; move random number into r1
		MOV	r7, r0			; move random number into r7
		MOV	r9, r0			; move random number into r9
		BL	PrintText		; print the message
		= &0a, &0d, "The number:", &0
		BL	PrintHex		; print the number
		MOV	r7, r9			; restore the number in r7
		BL	CountOnes		; count the ones	
		BL	PrintText		; print the message
		= &0a, &0d, "# of 1's:", &0
		BL	PrintHex		; print the number	
		MOV	r7, r9			; restore r7 
		BL	CountZeroes		; count the zeroes
		BL	PrintText		; print the message
		= &0a, &0d, "# of 0's:", &0
		BL	PrintHex		; print the number
		SUBS	r4, r4, #1		; decrement the counter
		CMP	r4, #0			; test the counter
		BGT	mainLoop		; if greater than zero, loop
		SWI	SWI_Exit		; exit
CountOnes	MOV	r5, #0			; initialize the bit counter
		LDR	r6, allOnes		; store the goal string in r6
CountOneLoop	SUB	r8, r7, #1		; decrement the number
		AND	r7, r8, r7		; and the new number with the original
		TEQ	r8, r6			; check for completeness
		ADDNE	r5, r5, #1		; increment counter 
		BNE	CountOneLoop		; loop
		MOV	r1, r5			; store r5 for output
		MOV	pc, r14			; return
CountZeroes	MOV	r5, #0			; initialize counter
		LDR	r6, allZeroes		; store goal string in r6
CountZeroLoop	ADD	r8, r7, #1		; increment the number
		ORR	r7, r8, r7		; or the new number with the original
		TEQ	r8, r6			; test for completeness
		ADDNE	r5, r5, #1		; increment the counter
		BNE	CountZeroLoop		; loop
		MOV	r1, r5			; store r5 for output
		MOV	pc, r14			; return
PrintHex	MOV	r2,#8			; count of nibbles = 8
LOOP		MOV	r0,r1,LSR #28		; get top nibble
		CMP 	r0, #9			; hexanumber 0-9 or A-F
		ADDGT 	r0,r0, #"A"-10		; ASCII alphabetic
		ADDLE 	r0,r0, #"0"		; ASCII numeric
		SWI 	SWI_WriteC		; print character
		MOV	r1,r1,LSL #4		; shift left one nibble
		SUBS	r2,r2, #1		; decrement nibble count
		BNE	LOOP			; if more nibbles,loop back
		MOV 	pc, r14			; return
PrintText	LDRB	r0,[r14], #1		; get a character
		CMP 	r0, #0			; end mark NUL?
		SWINE 	SWI_WriteC		; if not, print
		BNE	PrintText
		ADD	r14, r14, #3		; pass next word boundary
		BIC	r14, r14, #3		; round back to boundary
		MOV	pc, r14			; return
allOnes		DCD	&FFFFFFFF		; test string for all ones
allZeroes	DCD	&00000000		; test tring for all zeros
		END				; goodbye!
