moveright:     
    lda $dc00 
    and #%00001000
    bne button 
    inc spr0_x
checkbitright:
    ldx spr0_x
    cpx #0
    bne rightbounds 
    lda $d010 
    and #%11111110 
    sta $d010 
rightbounds:
    ldx spr0_x
    cpx #254
    bne button
    lda $d010
    ora #%00000001
    cmp $d010  
    beq button  // When we cros middle threshhold 
    lda $d010
    lda $d010 
    ora #%00000001
    sta $d010 
    ldx #1
    stx spr0_x