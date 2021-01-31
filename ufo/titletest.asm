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
.byte 0,0
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,79,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,80,32
.byte 32,116,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,116,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,116,32,32,32,32,32,32,32,32,32,32,23,5,9,18,4,22,9,19,9,15,14,32,54,52,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,2,25,32,10,5,19,19,9,3,1,32,12,5,25,2,1,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,103,32
.byte 32,101,32,32,32,32,32,32,32,32,16,18,5,19,19,32,6,9,18,5,32,20,15,32,19,20,1,18,20,32,32,32,32,32,32,32,32,32,103,32
.byte 32,76,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,111,122,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,6,4,6,4,6,4,6,4,6,4,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,14,14,14,14,14,14,14,14,14,1,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,4,4,4,4,4,4,4,4,4,4,4,4,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,1,14
.byte 14,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,14,14,14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14,14,14,14,14,14,1,14
.byte 14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,1,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14
