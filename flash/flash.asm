// Program that flashes the background
// better than just incrementing d020 
// It only increments through the existing colors 
// Try playing with the value that we compare x to! 
BasicUpstart2(start)

* = $4000

start:
	ldx #$00 // Load 0 into x 
gloop:
	stx $d020 // Store x in d020, setting color
	inx // Increment x 
	cpx #$0f // Compare x to 15
	bne gloop // Loop back up if we're not at 15
	ldx #$00 // If we are at 15, reset x to 0 (black)
	jmp gloop // Now we can go back up
