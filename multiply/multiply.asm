// Multiply two 8-bit numbers and then print the result to the screen
// https://codebase64.org/doku.php?id=base:8bit_multiplication_8bit_product

BasicUpstart2(start)

* = $1000

start:
    jsr mul 
    rts 

// Numbers to multiply 
num1:
    .byte 8
num2:
    .byte 5

mul:
    lda #$00
    beq enter_loop
add:
    clc
    adc num1 
loop:
    asl num1 
enter_loop:
    lsr num2 
    bcs add 
    bne loop
end:
    sta num1    
    tax 
    lda #$00
    jsr $bdcd 
    lda #8 // Reset the numbers for next program run 
    sta num1
    lda #5
    sta num2

    rts 