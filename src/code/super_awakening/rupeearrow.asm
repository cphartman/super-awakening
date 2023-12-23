; [a] is [wArrowCount]
.CheckArrowForRupee
    ; Check if we're out of arrows
    ld   a, [wArrowCount]
    cp $00
    jp nz, .CheckArrowForRupee_end

    ; Check if we have rupees
    ld a, [wRupeeCountLow]
    cp $00
    jp nz, .CheckArrowForRupee_purchase_arrow
    ld a, [wRupeeCountHigh]
    cp $00
    jp nz, .CheckArrowForRupee_purchase_arrow
    jp .CheckArrowForRupee_end
    
    ; Add 1 arrow
.CheckArrowForRupee_purchase_arrow
    ld a, $01
    ld [wArrowCount], a
    ld a, $01
    ld hl, wSubstractRupeeBufferLow 
    ld a, [hl]
    inc a
    ld [hl], a

.CheckArrowForRupee_end
    ret