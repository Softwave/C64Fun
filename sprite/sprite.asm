    // Move a sprite on the screen with a joystick 
    // Commenting this file is a work-in-progress
    BasicUpstart2(start)

    * = $4000

start:
    ldx #$00 // Make border and screen black and any potential text white 
    stx $d020 
    stx $d021 
    ldx #$01
    stx $0286
    jsr $e544 // Clear the screen 
    
    
    lda #$80 // Set the sprite pointer, long story but sprites are stored at intervals of 64 bytes
    sta $07f8 // $07f8 points to where sprite0 is in memory, but its value is divided by 64
    // Here sprite 0 is at $2000/8192, and $2000/#$40(64) = #$80(128) 
    // If sprite 0 was at $2100 then we'd need to put #$84 into $07f8 to point to it 

    // Enable sprite 0
    lda #$01
    sta $d015

    // Set x and y position 
    lda #$a0
    sta $d000 // set sprite 0's x position to #$a0 (160)
    lda #$64
    sta $d001 // y position

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
    lda #$ff  // Delay
    cmp $d012 // Only do things on scan line 255
    bne delay // This is to slow the speed of the sprites movement 
moveup: 
    lda $dc00 // CIA address for joystick port 2,
    and #%00000001
    bne movedown 
    dec $d001 
movedown:
    lda $dc00
    and #%00000010
    bne moveleft
    inc $d001 
moveleft:
    lda $dc00
    and #%00000100
    bne moveright 
    dec $d000
checkbitleft: 
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
    lda #1
    sta $d010
    ldx #89 // there are 65 additional pixels after 255, and sprites are 24 pixels wide
    stx $d000
moveright:     
    lda $dc00
    and #%00001000
    bne button
    inc $d000
checkbitright: 
    ldx $d000
    cpx #0
    bne rightbounds
    lda #1
    sta $d010
rightbounds:
    ldx $d010
    cpx #1
    bne button 
    ldx $d000
    cpx #89 // there are 65 additional pixels after 255, and sprites are 24 pixels wide
    bne button
    lda #0
    sta $d010
    ldx #$01
    stx $d000
button:
    lda $dc00
    and #%00010000
    bne done 
    inc $d020 
done:
    jmp loop

    * = $2000
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$aa,$00,$01,$dd,$c0
    .byte $0a,$aa,$a0,$2a,$aa,$a8,$15,$55
    .byte $54,$3f,$ff,$fc,$2a,$aa,$a8,$0a
    .byte $aa,$a0,$00,$55,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$8e