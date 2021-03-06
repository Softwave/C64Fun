// Simple Hello World program
BasicUpstart2(start) // 10 sys 16384 

* = $4000 // Mem location

start:
	lda #0  // Load 0 for black
	sta $d020 // Make border black
	sta $d021 // Make center of screen black
	lda #1 // Load 1 for white
	sta $0286 // Make text white 
	jsr $e544 // Clear the screen 
	jsr draw_text // Jump to the draw_text sub
	rts // Return to main subroutine use jmp * if u want to freeze there

// Our 40-character wide message 
msg:
	.text "              hello world!              " 

draw_text:
	ldx #0
draw_loop:
	lda msg,x // Load the memory location of msg, plus x, into a 
	sta $05e0,x // Put a into memory location 05e0 + x to show on screen
	inx // Increment x, this is our index 
	cpx #40 // Compare x to 40 (our message is 40 chars long)
	bne draw_loop // If it's not, go back to draw loop, otherwise continue
	rts // Return to sub