// Weirdvision 64 
// My first Commodore 64 game 
// A followup to a small Flash game I made years ago 
// Warning: Lots of bad code here; I learned as I went 

BasicUpstart2(start) // We start at $0801 

.const spr0_x = $d000 
.const spr0_y = $d001 
.const spr1_x = $d002 
.const spr1_y = $d003 
.const spr2_x = $d004
.const spr2_y = $d005 
.const spr3_x = $d006 
.const spr3_y = $d007 
.const spr4_x = $d008
.const spr4_y = $d009 

.macro CowRange(spriteX, spriteY, origX, origY, mask) {
range:
    ldy #0 
range1: 
    iny 
    dex 
    cpx spriteX
    beq beamon 
    cpy #30 
    bne range1 

    ldy #0           
range2: 
    iny 
    inx 
    cpx spriteX
    beq beamon 
    cpy #50 
    bne range2

    //jsr landcow
    rts  
beamon:
    lda #mask 
    and $d015
    cmp #mask 
    bne endcowrange
    dec spriteY 
    inc $d020 
    // We're gonna do this a bunch 
    ldy #00 
makesound:
    ldx #150
    stx $d418
    ldx #0
    stx $d418 
    iny 
    cpy #10 
    bne makesound 
    rts 
landcow:
    // Make sure cow is at original starting place 
    lda #origX
    sta spriteX
    lda #origY 
    sta spriteY  
endcowrange:
    rts
    //jmp done 
}

//resetgame: 




start:
    ldx #$00
    stx $d020
    stx $d021 

    // Debug
    jmp mooscreen1

loadtitle:  
    jsr $e544
    ldx #$00
ltloop:
    lda title+2,x // Load the first bank of the map 
    sta $0400,x
    lda title+$3ea,x
    sta $d800,x     // Load first color bank 
    
    lda title+$102,x
    sta $0500,x
    lda title+$4ea,x
    sta $d900,x

    lda title+$202,x
    sta $0600,x
    lda title+$5ea,x
    sta $da00,x

    lda title+$2ea,x
    sta $06e8,x
    lda title+$6d2,x
    sta $dae8,x
    inx
    bne ltloop
    // Check if player fires to move to next screen 
titleloop:
    lda $dc00
    and #%00010000
    bne titleloop 

// The squidlet homeworld 
hwscreen:
    ldx #$0a
    stx $d021 
    jsr $e544

    // Setup the homeworld sprites squidlet and ufo
    lda #%00000011
    sta $d015 
    // Set multicolor mode for squidlet and UFO
    lda #%00000011
    sta $d01c 
    //Set sprite pointers 
    lda #$88
    sta $07f8
    //
    lda #$80
    sta $07f9 

    // Set squidlet position
    lda #$50
    sta spr0_x
    lda #$d5 
    sta spr0_y
    // Set ufo position
    lda #$ff
    sta spr1_x 
    lda #$d5 
    sta spr1_y 

    // Global multicolor sprite colors 
    lda #$04 // Purple         
    sta $d025
    lda #$06 // Blue 
    sta $d026
    // Set squidlet color 
    lda #$0e 
    sta $d027  
    // Set UFO color 
    lda #$0e 
    sta $d028 


    // Load the homeworld map 
    ldx #$00
lhwloop:
    lda homeworld+2,x // Load the first bank of the map 
    sta $0400,x
    lda homeworld+$3ea,x
    sta $d800,x     // Load first color bank 
    
    lda homeworld+$102,x
    sta $0500,x
    lda homeworld+$4ea,x
    sta $d900,x

    lda homeworld+$202,x
    sta $0600,x
    lda homeworld+$5ea,x
    sta $da00,x

    lda homeworld+$2ea,x
    sta $06e8,x
    lda homeworld+$6d2,x
    sta $dae8,x
    inx
    bne lhwloop
    // Check if player fires to move to next screen 

gotinufo:
    lda inufo
    cmp #1 
    bne hwloop 
    // Play sound or do something here  
    

hwloop:
hwdelay:
    lda #$ff 
    cmp $d012 
    bne hwdelay

    // Check if in ufo and make ufo go up 
    lda inufo 
    cmp #1 
    bne hwcol 
    dec spr1_y 
zoomsnd:
    ldx #15
    stx $d418 
    ldx 0
    stx $d405 
    ldx #240
    stx $d406 
    ldx #17
    stx $d404 
    //
    ldx #0
    ldy #0
zoomsndloop:
    iny
    cpy #7 
    bne zoomsndloop
zoomsndloop2:
    inx 
    stx $d401
    cpx #20
    bne zoomsndloop
    
//zoomsndloop2:
//    cpx $ff
//    bne zoomsndloop
//    stx $d401 
//    inx    
donezoomsndloop:
    ldx #6
    stx $d404 
    

    // Check if ufo is at 0, if so, go to the next screen
    lda spr1_y
    cmp #0
    beq quithomeworld

    // Check if player gets in their UFO  
hwcol:
    lda #%00000011
    cmp $d01e
    bne sqdleft 
    // Disable player sprite
    lda #%00000010
    sta $d015 
    lda #0
    sta spr0_x
    sta spr0_y 
    lda #1 
    sta inufo 
    jmp gotinufo 

quithomeworld:
    // cleanup 
    lda #0
    sta $d015 
    sta spr0_x
    sta spr0_y
    sta spr1_x 
    sta spr1_y
    jmp mooscreen1

sqdleft:
    lda $dc00 
    and #%00000100
    bne sqdright 
    dec spr0_x
sqdright:
    lda $dc00
    and #%00001000
    bne donehw
    inc spr0_x
    jmp hwloop

donehw:
    jmp hwloop

mooscreen1init:
    // Landing on the moo world  
    ldx #$06
    stx $d020
    ldx #$00
    stx $d021 
    jsr $e544 

    // Enable sprites 0 (UFO) and 1 (COW) and 2 (COW) and 3 and 4 (JETS)
    lda #%00011111
    sta $d015 

    // Set multicolor mode for both UFO and COW
    lda #%00011111
    sta $d01c

    // Sprite 0 is at $2000, so set pointer to point to it
    lda #$2000/64
    sta $07f8 
    // Sprite 1 is at $2100, so set pointer to point to it
    lda #$2100/64
    sta $07f9 
    // Sprite 2 is at $2100 also
    lda #$2100/64
    sta $07fa
    // Sprite 3 is at $2300
    lda #$2300/64
    sta $07fb 
    // Sprite 4 is at $2300 also 
    lda #$2300/64 
    sta $07fc 



    // Set ufo position
    lda #$a0 
    sta spr0_x 
    lda #5
    sta spr0_y 
    // Set cow position
    lda #$50
    sta spr1_x
    lda #$d5 
    sta spr1_y 
    // Set cow 2 position
    lda #$fe 
    sta spr2_x
    lda #$d5 
    sta spr2_y
    // Set jet 1 position
    lda #$50
    sta spr3_x
    lda #$50
    sta spr3_y
    // Set jet 2 position 
    lda #$19
    sta spr4_x
    lda #$a7 
    sta spr4_y
    // Jet 2 starts off on the right side of the split 
    lda $d010
    ora #%00010000
    sta $d010 

    // Global multicolor sprite colors 
    lda #$04 // Purple         
    sta $d025
    lda #$06 // Blue 
    sta $d026 
    // Set ufo color
    lda #$0e // Light Blue 
    sta $d027
    // Set cow color
    lda #$01 // White 
    sta $d028 
    // Set cow 2 color
    sta $d029 
    // Set jet 1 color 
    lda #$02 
    sta $d02a
    // Set jet 2 color 
    lda #$02 
    sta $d02b 
    rts

mooscreen1loadworld:
    // Load the first mooworld into character memory 
loadmap:  
    jsr $e544
    ldx #$00
lmloop:
    lda mooworld+2,x // Load the first bank of the map 
    sta $0400,x
    lda mooworld+$3ea,x
    sta $d800,x     // Load first color bank 
    
    lda mooworld+$102,x
    sta $0500,x
    lda mooworld+$4ea,x
    sta $d900,x

    lda mooworld+$202,x
    sta $0600,x
    lda mooworld+$5ea,x
    sta $da00,x

    lda mooworld+$2ea,x
    sta $06e8,x
    lda mooworld+$6d2,x
    sta $dae8,x
    inx
    bne lmloop
    rts 


    // Main loop
mooscreen1:
    sei              
    jsr mooscreen1init
    jsr mooscreen1loadworld
    lda #$00                    
    //sta delay_animation_pointer 

    //lda #$01             
    //sta delay_counter    

    ldy #$7f    
    sty $dc0d   
    sty $dd0d   
    lda $dc0d   
    lda $dd0d   
     
    lda #$01    
    sta $d01a   

    lda #<irq   
    ldx #>irq 
    sta $0314   
    stx $0315  

    lda #$00    
    sta $d012

    lda #$06    
    sta $d020

    cli         
    jmp * 
    //lda #$ff           
    //cmp $d012          
    //bne delay

irq:
    dec $d019 
    // Do stuff 
    jsr movejets
    jsr movejets 
    jsr movejets 
    jsr movejets
    jsr movejets
    jsr movejets2 
    jsr movejets2 
    jsr movejets2 
    jsr movejets2 
    jsr checklanded
    jsr checkleftscene  
    jsr updatecontrols
    jsr checkcollisions 
    jsr beamcow 
    jsr checkleftplanet 
    jmp $ea31   

checkleftscene:
    lda $d010        // If we are on the right side 
    ora #%00000001
    cmp $d010 
    bne checkleft
checkright:
    lda #86       // If we go off the edge of the right side
    cmp spr0_x
    bne notset 
goright:
    ldx #1
    sta movingright
    jmp mooscreen3
    rts
checkleft:
    lda #10
    cmp spr0_x
    bne notset
goleft:
    ldx #0
    sta movingright 
    jmp mooscreen2 
notset:
    rts  

checkleftplanet:
    lda #0 
    cmp spr0_y
    bne endleftplanetcheck
    // Leave the planet 
    lda #0 
    sta $d015 
    sta spr0_x
    sta spr0_y
    sta spr1_x 
    sta spr1_y
    sta spr2_x
    sta spr2_y
    sta spr3_x
    sta spr3_y
    jmp endscreen 
endleftplanetcheck:
    rts

checkcollisions:
    lda $d01e 
    cmp #%00000011
    beq hitcow1
    cmp #%00000101
    beq takecow2
    cmp #%00001001
    beq hitjet  
    cmp #%00010001
    beq hitjet
    cmp #%00010010
    beq jethitcow1
    cmp #%00010100
    beq jethitcow2  
    jmp hitcow1end
hitcow1:
    lda #%11111101
    and $d015
    sta $d015
    lda #0
    sta spr1_x
    sta spr1_y
    inc score
hitcow1end:
    rts 
takecow2:
    lda #%11111011
    and $d015 
    sta $d015
    lda #0
    sta spr2_x
    sta spr2_y
    inc score 
takecow2end:
    rts
hitjet:
    lda #0 
    sta $d015 
    sta spr0_x
    sta spr0_y
    sta spr1_x 
    sta spr1_y
    sta spr2_x
    sta spr2_y
    sta spr3_x
    sta spr3_y
    sta spr4_x
    sta spr4_y
    sei 
    jmp enddeadscreen
    rts 
jethitcow1:
    lda #%11111101
    and $d015
    sta $d015
    lda #0
    sta spr1_x
    sta spr1_y
    rts 
jethitcow2:
    lda #%11111011
    and $d015
    sta $d015
    lda #0
    sta spr1_x
    sta spr1_y
    rts

movejets: 
    dec spr3_x
checkjetbit: 
    ldx spr3_x
    cpx #255 
    bne leftboundsjet
    lda $d010 
    and #%11110111
    sta $d010 
leftboundsjet:
    ldx spr3_x
    cpx #1
    bne jetdone 
    lda $d010
    ora #%00001000
    cmp $d010 
    beq jetdone // If it's not 0 continue 
    lda $d010 
    ora #%00001000
    sta $d010
    ldx #89 
    stx spr3_x
jetdone:
    rts

movejets2: 
    dec spr4_x
checkjetbit2: 
    ldx spr4_x
    cpx #255 
    bne leftboundsjet2
    lda $d010 
    and #%11101111
    sta $d010 
leftboundsjet2:
    ldx spr4_x
    cpx #1
    bne jetdone2 
    lda $d010
    ora #%00010000
    cmp $d010 
    beq jetdone2 // If it's not 0 continue 
    lda $d010 
    ora #%00010000
    sta $d010
    ldx #89 
    stx spr4_x
jetdone2:
    rts 

checklanded:
    lda haslanded 
    cmp #1 
    beq checklandeddone
    lda #$64 
landonmoo:
    inc spr0_y
landsnd:
    ldx #15
    stx $d418 
    ldx 0
    stx $d405 
    ldx #240
    stx $d406 
    ldx #17
    stx $d404 
    //
    ldx #0
    ldy #0
landsndloop:
    iny
    cpy #7 
    bne landsndloop
landsndloop2:
    inx 
    stx $d401
    cpx #20
    bne landsndloop
donelandsndloop:
    ldx #6
    stx $d404 
    cmp spr0_y 
    bne landonmoo
    ldx #1
    stx haslanded 
checklandeddone:
    rts 

updatecontrols:
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
    ldx spr0_x
    cpx #255 
    bne leftbounds 
    lda $d010
    and #%11111110 
    sta $d010 
leftbounds:
    ldx spr0_x
    cpx #1 
    bne moveright 
    lda $d010 
    ora #%00000001
    cmp $d010 
    beq moveright 
    lda $d010 
    ora #%00000001
    sta $d010 
    ldx #89 
    stx spr0_x
moveright:     
    lda $dc00
    and #%00001000
    bne button
    inc $d000
checkbitright:          
    ldx $d000                 
    cpx #0              
    bne rightbounds     
    lda #%00000001      
    sta $d010           
rightbounds:
    ldx $d010
    cpx #%00000001      
    bne button        
    ldx $d000           
    cpx #89             
    bne button 
    lda #0              
    sta $d010           
    ldx #$01            
    stx $d000
button:
    lda $dc00
    and #%00010000
    beq donecontrols 
    ldx #$99
    stx gotocow2
    //jmp cow1range.landcow 
donecontrols:
    rts 

beamcow:
    lda $dc00
    and #%00010000
    beq firepressed 
    jsr cow1range.landcow
    jsr cow2range.landcow 
    rts 
firepressed:
    ldx spr0_x
    cpx spr1_x
    beq overcow1 
    cpx spr2_x
    beq overcow2 
    jsr cow2range
    jsr cow1range 
    rts 
overcow1:
    jmp cow1range 
    rts
overcow2:
    jmp cow2range
    rts 

cow1range: :CowRange(spr1_x, spr1_y, $50, $d5, %00000010)
cow2range: :CowRange(spr2_x, spr2_y, $fe, $d5, %00000100)



// Moo world screen 2
mooscreen2:
    sei              
    jsr mooscreen2init
    jsr mooscreen2loadworld
    lda #$00                    
    //sta delay_animation_pointer 

    //lda #$01             
    //sta delay_counter    

    ldy #$7f    
    sty $dc0d   
    sty $dd0d   
    lda $dc0d   
    lda $dd0d   
     
    lda #$01    
    sta $d01a   

    lda #<irq2   
    ldx #>irq2 
    sta $0314   
    stx $0315  

    lda #$00    
    sta $d012

    lda #$06    
    sta $d020

    cli         
    jmp * 

irq2:
    dec $d019 
    // Do stuff 
    jsr movejets
    jsr movejets 
    jsr movejets 
    jsr movejets
    jsr movejets
    jsr movejets2 
    jsr movejets2 
    jsr movejets2 
    jsr movejets2 
    //jsr checklanded 
    jsr checkleftscene2
    jsr updatecontrols2
    jsr checkcollisions 
    jsr beamcow 
    jsr checkleftplanet 
    jmp $ea31

checkleftscene2:
    lda $d010        // If we are on the right side 
    ora #%00000001
    cmp $d010 
    bne notset2
checkright2:
    lda #86       // If we go off the edge of the right side
    cmp spr0_x
    bne notset2 
goright2:
    ldx #1
    sta movingright
    jmp mooscreen1
    rts
checkleft2:
    lda #1
    cmp spr0_x
    bne notset2
goleft2:
    ldx #0
    sta movingright 
    jmp mooscreen3 
notset2:
    rts 

//gotomooscene2:
//    jmp mooscreen1


mooscreen2init:
    ldx #$06
    stx $d020
    ldx #$00
    stx $d021 
    jsr $e544

    // Enable sprites 0 (UFO) and 1 (COW) and 2 (COW) and 3 and 4 (JETS)
    lda #%00011111
    sta $d015 

    // Set multicolor mode for both UFO and COW
    lda #%00011111
    sta $d01c

    // Sprite 0 is at $2000, so set pointer to point to it
    lda #$2000/64
    sta $07f8 
    // Sprite 1 is at $2100, so set pointer to point to it
    lda #$2100/64
    sta $07f9 
    // Sprite 2 is at $2100 also
    lda #$2100/64
    sta $07fa
    // Sprite 3 is at $2300
    lda #$2300/64
    sta $07fb 
    // Sprite 4 is at $2300 also 
    lda #$2300/64 
    sta $07fc  

        // Set ufo position
    ldx movingright
    cmp #1
    //bne comingfromright2
    //jsr comingfromleft2
comingfromright2:
    // coming from the right going left
    lda #88
    sta spr0_x
    lda #$64 
    sta spr0_y
    lda $d010
    ora #%00000001
    sta $d010
    //jsr spawnend2
//comingfromleft2:
//    lda #244
//    sta spr0_x 
//    lda #$64
//    sta spr0_y
//    
//    //lda $d010 
//    //and #%11111110
//    //sta $d010
//    lda $d010 
//    and #%11111110
//    sta $d010
//    jsr spawnend2
spawnend2: 
    // Set cow position
    lda #$50
    sta spr1_x
    lda #$d5 
    sta spr1_y 
    // Set cow 2 position
    lda #$fe 
    sta spr2_x
    lda #$d5 
    sta spr2_y
    // Set jet 1 position
    lda #$50
    sta spr3_x
    lda #$50
    sta spr3_y
    // Set jet 2 position 
    lda #$19
    sta spr4_x
    lda #$a7 
    sta spr4_y
    // Jet 2 starts off on the right side of the split 
    lda $d010
    ora #%00010000
    sta $d010 

    // Global multicolor sprite colors 
    lda #$04 // Purple         
    sta $d025
    lda #$06 // Blue 
    sta $d026 
    // Set ufo color
    lda #$0e // Light Blue 
    sta $d027
    // Set cow color
    lda #$01 // White 
    sta $d028 
    // Set cow 2 color
    sta $d029 
    // Set jet 1 color 
    lda #$02 
    sta $d02a
    // Set jet 2 color 
    lda #$02 
    sta $d02b 
    rts

mooscreen2loadworld:
    // Load the second mooworld into character memory 
loadmap2:  
    jsr $e544
    ldx #$00
lmloop2:
    lda mooworldleft+2,x // Load the first bank of the map 
    sta $0400,x
    lda mooworldleft+$3ea,x
    sta $d800,x     // Load first color bank 
    
    lda mooworldleft+$102,x
    sta $0500,x
    lda mooworldleft+$4ea,x
    sta $d900,x

    lda mooworldleft+$202,x
    sta $0600,x
    lda mooworldleft+$5ea,x
    sta $da00,x

    lda mooworldleft+$2ea,x
    sta $06e8,x
    lda mooworldleft+$6d2,x
    sta $dae8,x
    inx
    bne lmloop2
    rts  

updatecontrols2:
moveup2: 
    lda $dc00          
    and #%00000001     
    bne movedown2       
    dec $d001          
movedown2:
    lda $dc00
    and #%00000010     
    bne moveleft2
    inc $d001          
moveleft2:
    lda $dc00
    and #%00000100
    bne moveright2 
    dec $d000  
checkbitleft2:
    ldx spr0_x
    cpx #255 
    bne leftbounds2
    lda $d010
    and #%11111110 
    sta $d010 
leftbounds2:
    ldx spr0_x
    cpx #1 
    bne moveright2 
    lda $d010 
    ora #%00000001
    cmp $d010 
    beq moveright2 
    lda $d010 
    ora #%00000001
    sta $d010 
    ldx #89 
    stx spr0_x
    //jmp mooscreen3
moveright2:     
    lda $dc00
    and #%00001000
    bne button2
    inc $d000
checkbitright2:          
    ldx $d000                 
    cpx #0              
    bne rightbounds2     
    lda #%00000001      
    sta $d010           
rightbounds2:
    ldx $d010
    cpx #%00000001      
    bne button2         
    ldx $d000           
    cpx #89             
    bne button2
    lda #0              
    sta $d010           
    ldx #$01            
    stx $d000
button2:
    lda $dc00
    and #%00010000
    beq donecontrols2 
    ldx #$99
    stx gotocow2
    //jmp cow1range.landcow 
donecontrols2:
    rts 


// World to the right 
mooscreen3:
    sei              
    jsr mooscreen3init
    jsr mooscreen3loadworld
    lda #$00                    
    ldy #$7f    
    sty $dc0d   
    sty $dd0d   
    lda $dc0d   
    lda $dd0d   
     
    lda #$01    
    sta $d01a   

    lda #<irq2   
    ldx #>irq2 
    sta $0314   
    stx $0315  

    lda #$00    
    sta $d012

    lda #$06    
    sta $d020

    cli         
    jmp *

irq3:
    dec $d019 
    // Do stuff 
    jsr movejets
    jsr movejets 
    jsr movejets 
    jsr movejets
    jsr movejets
    jsr movejets2 
    jsr movejets2 
    jsr movejets2 
    jsr movejets2 
    //jsr checklanded 
    //jsr checkleftscene3
    jsr updatecontrols3
    jsr checkcollisions 
    jsr beamcow 
    jsr checkleftplanet 
    jmp $ea31

checkleftscene3:
    lda $d010        // If we are on the right side 
    ora #%00000001
    cmp $d010 
    bne checkleft3
checkright3:
    lda #86       // If we go off the edge of the right side
    cmp spr0_x
    bne notset3 
goright3:
    ldx #1
    sta movingright
    jmp mooscreen2
    rts
checkleft3:
    lda #1
    cmp spr0_x
    bne notset3
goleft3:
    ldx #0
    sta movingright
    jmp mooscreen1 
notset3:
    rts 

mooscreen3init: 
    ldx #$06
    stx $d020
    ldx #$00
    stx $d021 
    jsr $e544

    // Enable sprites 0 (UFO) and 1 (COW) and 2 (COW) and 3 and 4 (JETS)
    lda #%00011111
    sta $d015 

    // Set multicolor mode for both UFO and COW
    lda #%00011111
    sta $d01c

    // Sprite 0 is at $2000, so set pointer to point to it
    lda #$2000/64
    sta $07f8 
    // Sprite 1 is at $2100, so set pointer to point to it
    lda #$2100/64
    sta $07f9 
    // Sprite 2 is at $2100 also
    lda #$2100/64
    sta $07fa
    // Sprite 3 is at $2300
    lda #$2300/64
    sta $07fb 
    // Sprite 4 is at $2300 also 
    lda #$2300/64 
    sta $07fc  

    // Set ufo position
    ldx movingright
    cmp #1
    bne comingfromright3
    jsr comingfromleft3
comingfromright3:
    // coming from the right going left
    lda #89
    sta spr0_x
    lda #$64 
    sta spr0_y
    lda $d010
    ora #%00000001
    sta $d010
    jsr spawnend3
comingfromleft3:
    lda #1
    sta spr0_x 
    lda #$64
    sta spr0_y
    
    lda $d010 
    and #%11111110
    sta $d010
    jsr spawnend3
spawnend3: 
    // Set cow position
    lda #$50
    sta spr1_x
    lda #$d5 
    sta spr1_y 
    // Set cow 2 position
    lda #$fe 
    sta spr2_x
    lda #$d5 
    sta spr2_y
    // Set jet 1 position
    lda #$50
    sta spr3_x
    lda #$50
    sta spr3_y
    // Set jet 2 position 
    lda #$19
    sta spr4_x
    lda #$a7 
    sta spr4_y
    // Jet 2 starts off on the right side of the split 
    lda $d010
    ora #%00010000
    sta $d010 

    // Global multicolor sprite colors 
    lda #$04 // Purple         
    sta $d025
    lda #$06 // Blue 
    sta $d026 
    // Set ufo color
    lda #$0e // Light Blue 
    sta $d027
    // Set cow color
    lda #$01 // White 
    sta $d028 
    // Set cow 2 color
    sta $d029 
    // Set jet 1 color 
    lda #$02 
    sta $d02a
    // Set jet 2 color 
    lda #$02 
    sta $d02b 
    rts

mooscreen3loadworld:
loadmap3:  
    jsr $e544
    ldx #$00
lmloop3:
    lda mooworldright+2,x // Load the first bank of the map 
    sta $0400,x
    lda mooworldright+$3ea,x
    sta $d800,x     // Load first color bank 
    
    lda mooworldright+$102,x
    sta $0500,x
    lda mooworldright+$4ea,x
    sta $d900,x

    lda mooworldright+$202,x
    sta $0600,x
    lda mooworldright+$5ea,x
    sta $da00,x

    lda mooworldright+$2ea,x
    sta $06e8,x
    lda mooworldright+$6d2,x
    sta $dae8,x
    inx
    bne lmloop3
    rts  

updatecontrols3:
moveup3: 
    lda $dc00          
    and #%00000001     
    bne movedown3       
    dec $d001          
movedown3:
    lda $dc00
    and #%00000010     
    bne moveleft3
    inc $d001          
moveleft3:
    lda $dc00
    and #%00000100
    bne moveright3 
    dec $d000  
checkbitleft3:
    ldx spr0_x
    cpx #255 
    bne leftbounds3
    lda $d010
    and #%11111110 
    sta $d010 
leftbounds3:
    ldx spr0_x
    cpx #1 
    bne moveright3 
    lda $d010 
    ora #%00000001
    cmp $d010 
    beq moveright3 
    lda $d010 
    ora #%00000001
    sta $d010 
    ldx #89 
    stx spr0_x
    //jmp mooscreen1
moveright3:     
    lda $dc00
    and #%00001000
    bne button3
    inc $d000
checkbitright3:          
    ldx $d000                 
    cpx #0              
    bne rightbounds3     
    lda #%00000001      
    sta $d010           
rightbounds3:
    ldx $d010
    cpx #%00000001      
    bne button3        
    ldx $d000           
    cpx #89             
    bne button3
    lda #0              
    sta $d010           
    ldx #$01            
    stx $d000
button3:
    lda $dc00
    and #%00010000
    beq donecontrols3 
    ldx #$99
    stx gotocow2
    //jmp cow1range.landcow 
donecontrols3:
    rts


// End screen
endscreen:
    ldx #$00
    stx $d020
    ldx #$0a
    stx $d021 
    ldx #1
    stx $0286
    
loadendscreen:
    jsr $e544 
    ldx #$00
leloop:
    lda returnscreen+2,x 
    sta $0400,x
    lda returnscreen+$3ea,x 
    sta $d800,x     
    
    lda returnscreen+$102,x
    sta $0500,x
    lda returnscreen+$4ea,x
    sta $d900,x

    lda returnscreen+$202,x
    sta $0600,x
    lda returnscreen+$5ea,x
    sta $da00,x

    lda returnscreen+$2ea,x
    sta $06e8,x
    lda returnscreen+$6d2,x
    sta $dae8,x
    inx
    // Now put the score in 
    //ldy score 
    //sty $04e2
    bne leloop 

    // Set cursor pos 
    ldx #2
    ldy #24
    clc 
    jsr $fff0
    ldx score
    lda #0
    //jsr $ffd2
    jsr $bdcd 
endloop:
    lda $dc00
    and #%00010000
    beq resetgame 
    jmp endloop

enddeadscreen:
    ldx #0
    stx $d020
    stx $d021 
    ldx #1 
    stx $0286 
loadenddeadscreen:
    jsr $e544 
    ldx #$00 
ledloop:
    lda retrundeadscreen+2,x 
    sta $0400,x
    lda retrundeadscreen+$3ea,x 
    sta $d800,x     
    
    lda retrundeadscreen+$102,x
    sta $0500,x
    lda retrundeadscreen+$4ea,x
    sta $d900,x

    lda retrundeadscreen+$202,x
    sta $0600,x
    lda retrundeadscreen+$5ea,x
    sta $da00,x

    lda retrundeadscreen+$2ea,x
    sta $06e8,x
    lda retrundeadscreen+$6d2,x
    sta $dae8,x
    inx  
    bne ledloop 
enddeadloop:
    lda $dc00 
    and #%00010000
    beq resetgame 
    jmp enddeadloop

resetgame:
    // Reset all the variables and memory locations 
    sei 
    ldx #0 
    stx score 
    stx inufo 
    stx haswon 
    stx isbeamingcow 
    stx haslanded 
    stx gotocow2 
    stx cow1canmove
    stx cow2canmove
    jmp start 

movingright:
    .byte 0 

score:
    .byte 0

inufo:
    .byte 0 

haswon:
    .byte 0 

isbeamingcow:
    .byte 0 

haslanded:
    .byte 0 

gotocow2:
    .byte 0 

cow1canmove:
    .byte 1

cow2canmove:
    .byte 1



    // UFO sprite data 
    * = $2000
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$aa,$00,$01,$dd,$c0
    .byte $0a,$aa,$a0,$2a,$aa,$a8,$15,$55
    .byte $54,$3f,$ff,$fc,$2a,$aa,$a8,$0a
    .byte $aa,$a0,$00,$55,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$8e

     // Cow sprite data 
     * = $2100 
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$82,$00,$00
    .byte $28,$00,$00,$28,$00,$00,$28,$00
    .byte $00,$2a,$af,$e0,$2a,$ab,$88,$2a
    .byte $aa,$88,$0a,$aa,$88,$0a,$ba,$88
    .byte $0a,$fe,$88,$02,$00,$80,$02,$00
    .byte $80,$02,$00,$80,$02,$00,$80,$81

    // Squidlet sprite data
    * = $2200 
    .byte $00,$00,$00,$00,$00,$00,$01,$55
    .byte $50,$01,$55,$50,$01,$95,$90,$01
    .byte $95,$90,$01,$95,$90,$01,$95,$90
    .byte $01,$95,$90,$01,$95,$90,$01,$55
    .byte $50,$01,$55,$50,$01,$55,$50,$01
    .byte $11,$10,$01,$11,$10,$01,$11,$10
    .byte $01,$11,$10,$01,$11,$10,$01,$11
    .byte $10,$01,$11,$10,$01,$11,$10,$8e

    // Enemy sprite data 
    * = $2300
    enemy:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$02,$00
    .byte $00,$0a,$01,$00,$28,$05,$40,$a8
    .byte $2a,$aa,$a8,$aa,$aa,$aa,$2a,$aa
    .byte $a0,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$82

    // Bullet sprite data 
    *  = $2400 
    // singlecolor / color: $01
    bullet:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$3c,$00
    .byte $00,$3c,$00,$00,$3c,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$01


mooworld:
.byte 14,0
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,104,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,104,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,32,104,32,32,32,32,32,32,32,32,32
.byte 32,104,104,104,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,32
.byte 32,104,104,104,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,32
.byte 32,104,104,104,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,32
.byte 32,104,104,104,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,32
.byte 32,32,93,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,93,32,32,32,32,32,32,32,93,32,32,32,32,32,32,32,32,32
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,13,13,13,13,13,13,14,14,14,14,13,14,14,14,14,14,14,14,14,14
.byte 14,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,13,13,13,13,13,14,14,14,13,13,13,14,14,14,14,14,14,14,14
.byte 14,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,13,13,13,13,13,13,14,14,14,13,13,13,14,14,14,14,14,14,14,14
.byte 14,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,13,13,13,13,13,13,14,14,14,13,13,13,14,14,14,14,14,14,14,14
.byte 14,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,13,13,13,13,13,13,14,14,14,13,13,13,14,14,14,14,14,14,14,14
.byte 14,14,9,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,9,14,14,14,14,14,14,14,9,14,14,14,14,14,14,14,14,14
.byte 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
.byte 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4




msg:
	.text "         the cow was delectable         "

title:
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

homeworld:
.byte 0,10
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,7,5,20,32,9,14,32,25,15,21,18,32,19,8,9,16,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,7,15,32,20,15,32,20,8,5,32,13,15,15,32,23,15,18,12,4,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,23,5,32,14,5,5,4,32,13,15,18,5,32,13,15,15,19,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,92,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,92,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,92,32,32,32,32,32,92,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,92,32
.byte 32,160,160,160,160,160,160,160,160,32,32,32,32,32,92,32,32,32,92,32,92,32,32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,92,32
.byte 160,160,160,160,160,160,160,160,160,160,32,32,32,32,92,32,32,32,92,32,92,32,32,160,160,160,160,160,160,160,160,160,160,160,160,160,32,32,92,32
.byte 160,160,160,160,160,160,160,160,160,160,160,32,32,32,92,32,32,32,92,32,92,32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,32,92,32
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14
.byte 14,14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,7,7,7,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,7,7,7,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,7,7,7,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,7,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,7,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,2,2,2,2,2,14,14,14,14,14,14,7,14,14,14,14,14,7,14,14,14,14,14,14,14,14,14,14,2,2,14,14,14,14,14,7,14
.byte 14,0,0,0,0,0,0,0,0,2,2,14,14,14,7,14,14,14,7,14,7,14,14,14,2,0,0,0,0,0,0,0,0,2,14,14,14,14,7,14
.byte 0,0,0,0,0,0,0,0,0,0,2,2,14,14,7,14,14,14,7,14,7,14,2,0,0,0,0,0,0,0,0,0,0,0,0,0,2,14,7,14
.byte 0,0,0,0,0,0,0,0,0,0,0,2,2,2,7,14,14,14,7,14,7,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,7,14
.byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2

mooworldleft:
.byte 14,0
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,104,32,32,32,32,32,32,32,104,32,32,32,32,32,32,32,32
.byte 32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32
.byte 32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32
.byte 32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32
.byte 32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,104,104,104,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32
.byte 32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,93,32,32,32,32,32,32,32,93,32,32,32,32,32,32,32,32
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,8,8,8,8,8,8,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,8,8,8,8,8,8,8,8,8,8,14,14,14,14,14,14,14,14,14,14,14,13,14,14,14,14,14,14,14,13,14,14,14,14,14,14,14,14
.byte 14,14,14,6,6,6,6,6,6,6,6,10,14,10,14,14,14,14,14,14,14,14,13,13,13,14,14,14,14,14,13,13,13,14,14,14,14,14,14,14
.byte 14,14,14,6,14,6,6,6,6,14,6,10,10,10,14,14,14,14,14,14,14,14,13,13,13,14,14,14,14,14,13,13,13,14,14,14,14,14,14,14
.byte 14,14,14,6,14,6,6,6,6,14,6,10,10,14,14,14,14,14,14,14,14,14,13,13,13,14,14,14,14,14,13,13,13,14,14,14,14,14,14,14
.byte 14,14,14,6,6,6,9,6,6,6,6,10,10,14,14,14,14,14,14,14,14,13,13,13,13,14,14,14,14,14,13,13,13,14,14,14,14,14,14,14
.byte 14,14,14,6,6,6,9,6,6,6,6,10,10,14,14,14,14,14,14,14,14,14,14,9,14,14,14,14,14,14,14,9,14,14,14,14,14,14,14,14
.byte 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
.byte 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4

mooworldright:
.byte 14,0
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,104,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,32,104,32,160,160,160,160,160,160,160,160,32,32,104,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,104,104,104,160,160,160,160,160,160,160,160,32,104,104,104,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,104,104,104,160,160,160,160,160,160,160,160,32,104,104,104,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,104,104,104,160,160,160,160,160,160,160,160,32,104,104,104,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,104,104,104,32,32,32,32,32,32,32,104,104,104,160,160,160,160,160,160,160,160,32,104,104,104,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,93,32,32,32,32,32,32,32,32,32,93,32,160,160,160,160,160,160,160,160,32,32,93,32,32,32,32,32,32,32,32,32,32
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,9,9,9,9,9,9,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,9,9,9,9,9,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,9,9,9,9,9,9,9,9,9,9,9,9,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,9,9,9,9,9,9,9,9,9,9,9,9,9,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,9,9,9,9,9,9,9,9,9,9,9,14,14,14,9,9,9,9,9,9,9,9,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,9,9,9,13,9,9,9,9,9,9,9,9,14,14,9,9,9,9,9,9,9,9,9,9,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,9,13,13,13,9,9,9,9,9,9,14,14,14,14,2,2,2,2,2,2,2,2,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,9,9,13,13,13,9,9,9,9,9,9,9,9,9,14,2,14,14,2,2,14,14,2,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,9,9,13,13,13,9,9,9,9,9,9,14,14,13,14,2,14,14,2,2,14,14,2,14,14,13,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,13,13,13,9,9,9,9,9,9,9,13,13,13,2,14,14,2,2,14,14,2,14,13,13,13,14,14,14,14,14,14,14,14,14
.byte 9,9,9,9,9,9,13,13,13,9,9,9,9,9,9,14,13,13,13,2,2,2,2,2,2,2,2,14,13,13,13,14,14,14,14,14,14,14,14,14
.byte 9,9,9,9,9,9,13,13,13,9,9,9,9,9,9,9,13,13,13,2,2,2,2,2,2,2,2,14,13,13,13,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,9,13,13,13,13,13,9,9,9,9,9,9,13,13,13,2,2,2,9,2,2,2,2,14,13,13,13,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,9,9,9,9,9,9,9,9,9,9,14,9,14,2,2,2,9,2,2,2,2,14,14,9,14,14,14,14,14,14,14,14,14,14
.byte 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
.byte 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4

returnscreen:
.byte 14,10
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,25,15,21,32,18,5,20,21,18,14,5,4,32,38,32,13,15,15,19,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32,32,160,32,32,160,32,32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32,32,160,32,32,32,160,32,32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,160,32,32,160,32,32,32,160,32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32,32,32,160,32,32,160,32,32,160,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32,32,32,160,32,32,160,32,32,160,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32,32,32,32,160,32,32,160,32,32,160,160,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,32,32,32,160,32,32,160,32,32,32,32,160,160,32,32,32,32,32,32,32,32,32
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 160,160,160,160,160,160,160,160,160,16,18,5,19,19,32,6,9,18,5,32,20,15,32,16,12,1,25,32,1,7,1,9,14,160,160,160,160,160,160,160
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,4,4,4,4,4,4,4,4,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,0,0,4,4,4,4,0,0,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,0,0,4,4,4,4,0,0,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,0,0,4,4,4,4,0,0,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,0,0,4,4,4,4,0,0,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,0,0,4,4,4,4,0,0,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,4,14,4,4,4,4,4,4,4,4,4,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,1,14,14,14,4,4,4,4,4,4,4,4,4,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,1,14,14,14,4,14,14,4,14,14,4,14,14,4,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,1,1,14,14,14,14,4,14,14,4,14,14,14,4,14,14,4,1,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,1,1,1,1,1,1,1,1,1,1,4,4,1,1,4,1,1,1,4,1,4,1,1,1,1,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,14,14,14,4,14,14,4,14,1,4,1,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,14,14,14,4,14,14,4,14,14,4,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,14,14,14,14,4,14,14,4,14,14,4,4,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,4,14,14,14,4,14,14,4,14,14,14,14,4,4,14,14,14,14,14,14,14,14,14
.byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,4,2,2,2,2,4,2,2,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2

retrundeadscreen:
.byte 14,0
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,25,15,21,32,23,5,18,5,32,11,9,12,12,5,4,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,25,15,21,32,4,9,4,32,14,15,20,32,2,18,9,14,7,32,2,1,3,11,32,1,14,25,32,13,15,15,19,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,20,8,5,32,5,12,4,5,18,19,32,1,18,5,32,14,15,20,32,16,12,5,1,19,5,4,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,16,18,5,19,19,32,6,9,18,5,32,20,15,32,18,5,19,20,1,18,20,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
.byte 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
