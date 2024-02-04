SuperAwakening_QuickRestock::

.Powder:
    ; Skip if we have powder
    ld   a, [wMagicPowderCount]
    cp $00
    jp nz, .return
    ; Skip if we have the toadstool
    ld   a, [wHasToadstool]
    cp $00
    jp nz, .return
    ; Check if we have rupees
    ld a, [wRupeeCountLow]
    cp $00
    jp nz, .Powder_Purchase
    ld a, [wRupeeCountHigh]
    cp $00
    jp nz, .Powder_Purchase
    jp .return


.Powder_Purchase    
    ld a, $01
    ld [wMagicPowderCount], a
    ld hl, wSubstractRupeeBufferLow 
    ld a, [hl]

    ; Costs 5 rupees
    inc a
    inc a
    inc a
    inc a
    inc a
    ld [hl], a
    jp .return

.Arrow:
    ; Skip if we have powder
    ld   a, [wArrowCount]
    cp $00
    jp nz, .return
    ; Check if we have rupees
    ld a, [wRupeeCountLow]
    cp $00
    jp nz, .Arrow_Purchase
    ld a, [wRupeeCountHigh]
    cp $00
    jp nz, .Arrow_Purchase
    jp .return

.Arrow_Purchase    
    ld a, $01
    ld [wArrowCount], a
    ld hl, wSubstractRupeeBufferLow 
    ld a, [hl]
    inc a
    ld [hl], a
    jp .return

.Bomb:
    ; Skip if we have powder
    ld   a, [wBombCount]
    cp $00
    jp nz, .return
    ; Check if we have rupees
    ld a, [wRupeeCountLow]
    cp $00
    jp nz, .Bomb_Purchase
    ld a, [wRupeeCountHigh]
    cp $00
    jp nz, .Bomb_Purchase
    jp .return

.Bomb_Purchase    
    ld a, $01
    ld [wBombCount], a
    ld a, $05
    ld hl, wSubstractRupeeBufferLow 
    ld a, [hl]

    ; Costs 5 rupees
    inc a
    inc a
    inc a
    inc a
    inc a
    ld [hl], a
    jp .return

.return
    ; Restore the rombank
    ld   a, BANK(JoypadToLinkDirection)
    jp SuperAwakening_Trampoline.returnToBank