    // Move a sprite on the screen with a joystick 
    BasicUpstart2(start)

    * = $4000

start:
    ldx #$00
    stx $d020
    stx $d021 
    ldx #$01
    stx $0286
    jsr $e544 // Clear the screen 
    lda #$80
    sta $07f8 // Sprite data at $2000 

    // Enable sprite 0
    lda #$01
    sta $d015

    // Set x and y position 
    lda #$a0
    sta $d000
    lda #$64
    sta $d001

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
    lda #$ff 
    cmp $d012 
    bne delay   
moveup: 
    lda $dc00 
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
    ldx #$40
    stx $d000
moveright:     
    lda $dc00
    and #%00001000
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
    and #%00010000
    bne done 
    inc $d020 
done:
    jmp loop

    * = $2000
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$aa,$00,$02,$aa,$80
    .byte $0a,$aa,$a0,$2a,$aa,$a8,$15,$55
    .byte $54,$3f,$ff,$fc,$2a,$aa,$a8,$0a
    .byte $aa,$a0,$00,$55,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$8e