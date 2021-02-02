#importonce 

// Mathematics code for the Commodore 64 using KickAssembler 


// 8-bit multiplication
// Takes 3 mem addresses as input, 
// Stores 8-bit result in product
// Rather slow 
.macro mul8(left, right, product) {
    lda #0
    ldx right 
loop: 
    clc 
    adc left 
    dex 
    bne loop 
end:
    sta product 
}
