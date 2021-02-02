#import "math.asm"

BasicUpstart2(start)

start:
    :mul8(op1, op2, op3)
    ldx op3 
    lda #0 
    jsr $bdcd 
    rts 

op1:
    .byte 10 

op2:
    .byte 21

op3:
    .byte 0 