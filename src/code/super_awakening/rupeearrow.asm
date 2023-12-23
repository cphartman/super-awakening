; [b] is the inventory item we're checking
.CheckPurchaseConsumable
    ld a, b
    cp INVENTORY_MAGIC_POWDER
    jp z, .Powder_Check
    cp INVENTORY_BOMBS
    jp z, .Bomb_Check
    ; Default
    jp .Arrow_Check

.Powder_Check
    ; Skip if we have powder
    ld   a, [wMagicPowderCount]
    cp $00
    jp nz, .CheckPurchaseConsumable_end
    ; Skip if we have the toadstool
    ld   a, [wHasToadstool]
    cp $00
    jp nz, .CheckPurchaseConsumable_end
    ; Check if we have rupees
    ld a, [wRupeeCountLow]
    cp $00
    jp nz, .Powder_Purchase
    ld a, [wRupeeCountHigh]
    cp $00
    jp nz, .Powder_Purchase
    jp .CheckPurchaseConsumable_end


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
    jp .CheckPurchaseConsumable_end

.Arrow_Check
    ; Skip if we have powder
    ld   a, [wArrowCount]
    cp $00
    jp nz, .CheckPurchaseConsumable_end
    ; Check if we have rupees
    ld a, [wRupeeCountLow]
    cp $00
    jp nz, .Arrow_Purchase
    ld a, [wRupeeCountHigh]
    cp $00
    jp nz, .Arrow_Purchase
    jp .CheckPurchaseConsumable_end

.Arrow_Purchase    
    ld a, $01
    ld [wArrowCount], a
    ld hl, wSubstractRupeeBufferLow 
    ld a, [hl]
    inc a
    ld [hl], a
    jp .CheckPurchaseConsumable_end

.Bomb_Check
    ; Skip if we have powder
    ld   a, [wBombCount]
    cp $00
    jp nz, .CheckPurchaseConsumable_end
    ; Check if we have rupees
    ld a, [wRupeeCountLow]
    cp $00
    jp nz, .Bomb_Purchase
    ld a, [wRupeeCountHigh]
    cp $00
    jp nz, .Bomb_Purchase
    jp .CheckPurchaseConsumable_end

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
    jp .CheckPurchaseConsumable_end

.CheckPurchaseConsumable_end
    ret