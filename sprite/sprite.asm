    // Move a sprite on the screen with a joystick 
    BasicUpstart2(start)

    * = $1000

start:
    jsr $e544 // Clear the screen 
    lda #$80
    sta $07f8 // Sprite data at $2000 

    // Enable sprite 0
    lda #$01
    sta $d015

    // Set x and y position 
    //lda #$80
    lda #$a0
    sta $d000
    lda #$64
    sta $d001

    // Make the sprite red 
    lda #$02
    sta $d027 

loop:
delay:
    lda #$ff // Delay, check if the raster beam is at line 255 
    cmp $d012 // Only do stuff when the raster beam is on line 255
    bne delay  // This is to lower the framerate 
moveup:
    lda $dc00
    and #$01
    bne movedown 
    dec $d001 
movedown:
    lda $dc00
    and #$02
    bne moveleft
    inc $d001 
moveleft:
    lda $dc00
    and #$04
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
    ldx #$40
    stx $d000
moveright:
    lda $dc00
    and #$08
    bne button
    inc $d000
checkbitright:
    ldx $d000
    cpx #1
    bne rightbounds
    lda #1
    sta $d010
rightbounds:
    ldx $d010
    cpx #1
    bne button 
    ldx $d000
    cpx #255
    bne button
    lda #0
    sta $d010
    ldx #$01
    stx $d000



button:
    lda $dc00
    and #$10
    bne done 
    inc $d020 
done:
    jmp loop

    * = $2000
    .byte $00,$7c,$00,$00,$82,$00,$01,$01
    .byte $00,$02,$00,$80,$04,$00,$40,$08
    .byte $00,$20,$10,$00,$10,$1f,$ff,$f0
    .byte $3f,$ff,$f8,$7f,$ff,$fc,$7f,$ff
    .byte $fc,$7f,$ff,$fc,$3f,$ff,$f8,$1f
    .byte $ff,$f0,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$06