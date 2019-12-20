// Small program to print the alphabet 
BasicUpstart2(start) 

* = $1000

start:
	ldx #$41 // Load 'a' char into x
loop:
	txa // transfer x into a 
	jsr $ffd2 // print a character 
	inx // increment x 
	cpx #$5b // compare x to 91 (which is z)
	bne loop // If it's not z, then loop again 
	rts // Return to sub