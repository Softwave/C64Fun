// Multiply two 8-bit numbers and then print the result to the screen
// https://codebase64.org/doku.php?id=base:8bit_multiplication_8bit_product

.var x = 6
.var y = 10

BasicUpstart2(start)

* = $1000

start:
    jsr mul 
    rts 

// Numbers to multiply 
num1:
    .byte x
num2:
    .byte y

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
    lda #x // Reset the numbers for next program run 
    sta num1
    lda #y
    sta num2

    rts 