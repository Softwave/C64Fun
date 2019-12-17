BasicUpstart2(start) // 10 sys 16384 

// Simple program that changes the screen color to black
// and the text color to white 

* = $4000 

start:
	lda #$00 // Load 0, or black, into accumulator
	sta $d020 // Make border black
	sta $d021 // Make center of screen black
	lda #$01 // Load 1 into accumulator, this is white
	sta $0286 // Set screen text to white
	jsr $e544 // Clear the screen
	rts // Return to sub