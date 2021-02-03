//#import "math.asm"

    * = $0880
    ldy #$02 
    lda ($2d),y 
    sta $033c 
    sta $033e 
    ldy #$03 
    lda ($2d),y 
    sta $033d 
    sta $033f 
    asl $033d 
    rol $033c 
    asl $033d 
    rol $033c 
    clc 
    lda $033d 
    adc $033f 
    sta $033d 
    lda $033c 
    adc $033e 
    sta $033c 
    asl $033d 
    rol $033c 
    //
    ldy #$02 
    lda $033c
    sta ($2d),y 
    ldy #$03 
    lda $033d 
    sta ($2d),y 
    rts 
