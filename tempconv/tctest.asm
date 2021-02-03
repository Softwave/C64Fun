// java -jar KickAss.jar foo.asm -o foo.prg

* = $0801          // BASIC start address (#2049)
.byte $0C, $08, $00, $00, $9E, $32, $30, $36
.byte $31, $00, $00, $00

start:
    lda screen_001
    sta $d020
    lda screen_001+1
    sta $d021
    lda #$15
    sta $d018

    ldx #$00
loop:
    lda screen_001+2,x
    sta $0400,x
    lda screen_001+$3ea,x
    sta $d800,x

    lda screen_001+$102,x
    sta $0500,x
    lda screen_001+$4ea,x
    sta $d900,x

    lda screen_001+$202,x
    sta $0600,x
    lda screen_001+$5ea,x
    sta $da00,x

    lda screen_001+$2ea,x
    sta $06e8,x
    lda screen_001+$6d2,x
    sta $dae8,x
    inx
    bne loop

    jmp *


// PETSCII memory layout (example for a 40x25 screen)'
// byte  0         = border color'
// byte  1         = background color'
// bytes 2-1001    = screencodes'
// bytes 1002-2001 = color

screen_001:
.byte 14,0
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,20,3,44,32,20,5,13,16,3,15,14,22,5,18,20,5,18,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,5,14,20,5,18,32,20,5,13,16,32,9,14,32,4,5,7,18,5,5,19,32,6,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,9,14,16,21,20,58,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,18,5,19,21,12,20,58,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32
.byte 32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,2,2,2,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,2,2,2,2,14,14,1,14
.byte 14,1,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,2,2,2,2,2,2,2,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,0,0,0,0,0,0,0,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,0,0,0,0,0,0,0,0,0,0,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14