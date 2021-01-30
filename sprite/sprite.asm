    // Move a sprite on the screen with a joystick 
    // Commenting this file is a work-in-progress
    BasicUpstart2(start)

    * = $4000

start:
    ldx #$06        // Set screen, border and text colors  
    stx $d020 
    ldx #$00
    stx $d021 
    ldx #$01
    stx $0286
    jsr $e544       // Clear the screen 

    jsr drawtext    // Draw title text

msg:
	.text "              sprite test               "

drawtext:
    ldx #$00
drawloop:
    lda msg,x       // Load what's at msg+x into the accumulator, we're using indexed absolute addressing 
    sta $0428,x     // We're going to write text at the top of character memory
    inx             // Increment x, that is our index 
    cpx #40         // The C64's screen is 40 characters wide, compare x with 40
    bne drawloop    // If it's not, go back up to the loop, otherwise continue
    
    lda #$80        // Set the sprite pointer, long story but sprites are stored at intervals of 64 bytes
    sta $07f8       // $07f8 points to where sprite0 is in memory, but its value is divided by 64
                    // Here sprite 0 is at $2000/8192, and $2000/#$40(64) = #$80(128) 
                    // If sprite 0 was at $2100 then we'd need to put #$84 into $07f8 to point to it 

    // Enable sprite 0
    lda #$01
    sta $d015

    // Set x and y position             
    lda #$a0           
    sta $d000          // sprite0's xposition is stored in $d000 
    lda #$64
    sta $d001          // sprite0's yposition is stored in $d001 


    // Set multicolor mode              
    lda #$01          
    sta $d01c

    // Set the sprite colors         
    lda #$04          
    sta $d025
    lda #$06
    sta $d026 
    lda #$0e
    sta $d027

loop:
delay:
    lda #$ff           // Delay
    cmp $d012          // Only do things on scan line 255
    bne delay          // This is to slow the speed of the sprites movement 
moveup: 
    lda $dc00          // CIA address for joystick port 2,
    and #%00000001     // Up is the least sig bit   
    bne movedown       // We're finding if dc00's least sig bit is set, ie: if the joystick is pushing up
    dec $d001          // Decrement the y position of sprite0 if it was set, thereby making sprite0 go up 
movedown:
    lda $dc00
    and #%00000010     // Different joystick directions are represented by different bits in $dc00
    bne moveleft
    inc $d001          // Go down
moveleft:
    lda $dc00
    and #%00000100
    bne moveright 
    dec $d000          // Go left
checkbitleft:          // Refer to comment on checkbitright this is its opposite
    ldx $d000 
    cpx #255
    bne leftbounds
    lda #0
    sta $d010
leftbounds: 
    ldx $d000
    cpx #1
    bne moveright
    ldx $d010
    cpx #0
    bne moveright
    lda #%00000001
    sta $d010
    ldx #89             // there are 65 additional pixels after 255, and sprites are 24 pixels wide
    stx $d000
moveright:     
    lda $dc00
    and #%00001000
    bne button
    inc $d000
checkbitright:          // So basically, the x positions of C64 sprites are 9 bits long
    ldx $d000           // This is because the C64 has a screen wider than 255 (1 byte) pixels, it's 320  
                        // For sprite0 most of the x position is stored in $d000,
    cpx #0              // but if sprite0 has wrapped past 255 to 0 we set the least signifigant bit of $d010 
    bne rightbounds     // and also sprite0's x starts over again, continuing for 65 more pixels
    lda #%00000001      // till the end of the screen 
    sta $d010           // $d010's least signifigant bit is sprite0's most signifigant bit 
rightbounds:
    ldx $d010
    cpx #%00000001      // Is the most sig bit of sprite0 set? ie: are we past 255?
    bne button          
    ldx $d000           // there are 65 additional pixels after 255, and sprites are 24 pixels wide
    cpx #89             // if sprite0 is  255+89 then we know we are at the end and we can loop back 
    bne button
    lda #0              // So we unset sprite0's most signifigant bit
    sta $d010           //
    ldx #$01            // Then we set their position at the far left of the screen 
    stx $d000           // The opposite happens when we go off the left edge
button:
    lda $dc00
    and #%00010000
    bne done 
    inc $d020           // Pressing fire flashes the screen
done:
    jmp loop

    * = $2000           // We're putting our sprite0 data at memlocation $2000
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$aa,$00,$01,$dd,$c0
    .byte $0a,$aa,$a0,$2a,$aa,$a8,$15,$55
    .byte $54,$3f,$ff,$fc,$2a,$aa,$a8,$0a
    .byte $aa,$a0,$00,$55,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$8e