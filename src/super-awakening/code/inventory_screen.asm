SuperAwakening_InventoryScreen:

    ; Check for button press
    ldh  a, [hJoypadState]
    and  J_A
    cp J_A
    jp nz, .return

    ; Get the inventory item value from the inventory selection index => [a]
    ld   a, [wInventorySelection]
    ld   hl, wSuperAwakening.Weapon_Inventory
    ld c, a
    ld b, $00
    add  hl, bc
    ld a, [hl]

    ; Get the tile index from the inventory item value => [a]
.get_tile_index
    ld hl, Inventory_Item_Index_Map
    ld c, a
    add  hl, bc
    ld a, [hl]
    
.get_tile_index_end

;InventoryEquipmentItemsTiles
    ; Check if we're hiding or showing this slot
    push af
.get_source_address
    ld   a, [wInventorySelection]
    ld   hl, wSuperAwakening.Items_Hidden
    ld c, a
    ld b, $00
    add  hl, bc
    ld a, [hl]
    xor 1
    ld [hl], a
    cp 0
    jp z, .get_show_address
.get_hide_address
    ld hl, SuperAwakening_Gfx_ItemsOutline
    jp .get_source_address_end
.get_show_address
    ld hl, (SuperAwakening_Gfx_ItemsOutline+$0200)
.get_source_address_end
    pop af

    ; Get address of tile data from tile index: (tile index offset*$20)
    ; [a] = tile index
    
    ld bc, $0020 ; multiplicand
    ld de, $8800
.increment_loop
    cp 0
    jp z, .increment_loop_end
    add hl, bc
    push hl
    push de
    pop hl
    add hl, bc
    push hl
    pop de
    pop hl
    dec a
    jp .increment_loop
.increment_loop_end


    push hl
    push de
.poll_for_vblank
    ldh  a, [hNeedsRenderingFrame]                ; $0374: $F0 $D1
    and  a                                        ; $0376: $A7
    jr   z, .poll_for_vblank              ; $0377: $28 $FB
    ; Clear hNeedsRenderingFrame
    xor  a                                        ; $0379: $AF
    ldh  [hNeedsRenderingFrame], a                ; $037A: $E0 $D1
.poll_for_vblank_end
    pop de
    pop hl
    ;call LCDOff


;   bc : number of bytes to copy
;   de : destination address
;   hl : source address
    ld   bc, $20
    ;ld   de, $8820
    ;ld   hl, items_outline_tiles_bank_3E+$20
    call CopyData                                 ; $7C43: $CD $14 $29

    ;  a   source bank
    ;  b   source address high byte
    ;  c   destination address high byte (starting from $8000)
    ;  h   bank to switch back after the transfer
/*
    ld a, BANK(items_outline_tiles_bank_3E)
    ld b, $40
    ld c, $02
    ld h, BANK(SuperAwakening)
    call CopyDataToVRAM

    ld a, BANK(items_outline_tiles_bank_3E)
    ld b, $41
    ld c, $03
    ld h, BANK(SuperAwakening)
    call CopyDataToVRAM
*/
; Inputs:
;   bc : number of bytes to copy
;   de : destination address
;   hl : source address

    ;ld   bc, $20
    ;ld   de, $8820
    ;ld   hl, items_outline_tiles_bank_3E+$20
    ;call CopyData                                 ; $7C43: $CD $14 $29


    ; Turn on LCD
    ;ld   a, [wLCDControl]                         ; $5D58: $FA $FD $D6
    ;ldh  [rLCDC], a                               ; $5D5B: $E0 $40


.return
    ; Restore bank
    ld a, $20
    jp SuperAwakening_Trampoline.returnToBank

; Similar to InventoryItemTiles, but just the offset index
Inventory_Item_Index_Map::
    db $00 ; INVENTORY_EMPTY
    db $02 ; INVENTORY_SWORD
    db $00 ; INVENTORY_BOMBS
    db $01 ; INVENTORY_POWER_BRACELET
    db $03 ; INVENTORY_SHIELD
    db $04 ; INVENTORY_BOW
    db $05 ; INVENTORY_HOOKSHOT
    db $06 ; INVENTORY_MAGIC_ROD
    db $0C ; INVENTORY_PEGASUS_BOOTS
    db $08 ; INVENTORY_OCARINA
    db $09 ; INVENTORY_ROCS_FEATHER
    db $0B ; INVENTORY_SHOVEL
    db $07 ; INVENTORY_MAGIC_POWDER
    db $12 ; INVENTORY_BOOMERANG
