
SuperAwakening_InventoryScreen:

    ; Check for button press
    ldh  a, [hJoypadState]
    and  J_A
    cp J_A
    jp nz, .return

    ; Get the inventory item value from the inventory selection index => [a]
.get_inventory_item_value
    ld a, [wInventorySelection]
    ld c, a
    ld b, $00
    ld hl, wInventoryItems.subscreen
    add  hl, bc
    ld a, [hl]

    
.check_for_mushroom
    ld b, a  ; Backup [a] to [b]
    cp INVENTORY_MAGIC_POWDER
    jp nz, .get_tile_index
    ld a, [wHasToadstool]
    cp 1
    ld a, b ; Restore [a] from [b]
    jp nz, .get_tile_index
    ; We have a mushroom, enable or disable?
    ld   a, [wInventorySelection]
    ld   hl, wSuperAwakening.Items_Hidden
    ld c, a
    ld b, $00
    add  hl, bc
    ld a, [hl]
    xor 1 ; Toggle
    ld [hl], a
    cp 0
    jp z, .show_mushroom
.hide_mushroom
    ld a, $0E
    ld de, $88E0 ; Address of powder tiles
    ld hl, (SuperAwakening_Gfx_ItemsOutline + ($20*10))
    jp .copy_data
.show_mushroom
    ld a, $0E
    ld de, $88E0 ; Address of powder tiles
    ld hl, (SuperAwakening_Gfx_ItemsOutline + $0200 + ($20*10))
    jp .copy_data
  
    ; Get the tile index from the inventory item value => [a]
.get_tile_index
    ld hl, Inventory_Item_Index_Map
    ld c, a
    ld b, $00
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
    xor 1 ; Toggle
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
    ; 0x20=32 so I think this can be replaced with <<5 or something simpler
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

.copy_data

.poll_for_vblank
    ldh  a, [hNeedsRenderingFrame]                ; $0374: $F0 $D1
    and  a                                        ; $0376: $A7
    jr   z, .poll_for_vblank              ; $0377: $28 $FB
    ; Clear hNeedsRenderingFrame
    xor  a                                        ; $0379: $AF
    ldh  [hNeedsRenderingFrame], a                ; $037A: $E0 $D1
.poll_for_vblank_end

;   bc : number of bytes to copy
;   de : destination address
;   hl : source address
    ld   bc, $20
    call CopyData                                 

.return
    ; Restore bank
    ld a, $20
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_Inventory_HideSlot::
.get_item_value
    ; Get the inventory item value from the inventory selection index => [a]
    ld   hl, wInventoryItems.subscreen
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

    ; Get address offset of the tile
    ; hl = a*bc
    ; while( a-- ) { hl += bc }
.get_tile_address_offset
    ld hl, $0000    ; results
    ld bc, $0020    ; multiplicand
.get_tile_address_offset_multiply_loop
    cp 0
    jp z, .get_tile_address_offset_end
    add hl, bc
    dec a
    jp .get_tile_address_offset_multiply_loop
.get_tile_address_offset_end

.get_tile_addresses
    ; bc = hl
    ld b, h
    ld c, l

    ; de = $8800 + bc
    ld hl, $8800
    add hl, bc
    ld d, h
    ld e, l

    ; hl = $GFX + bc
    ld hl, SuperAwakening_Gfx_ItemsOutline
    add hl, bc
/*
.wait_for_vlbank
    ldh  a, [hNeedsRenderingFrame]                ; $0374: $F0 $D1
    and  a                                        ; $0376: $A7
    jr   z, .wait_for_vlbank_end              ; $0377: $28 $FB
    ; Clear hNeedsRenderingFrame
    xor  a                                        ; $0379: $AF
    ldh  [hNeedsRenderingFrame], a                ; $037A: $E0 $D1
.wait_for_vlbank_end
*/
.copy_tiles
    ;   bc : number of bytes to copy
    ;   de : destination address    
    ;   hl : source address
    ld   bc, $20
    call CopyData    

    ret

SuperAwakening_InventoryScreen_Open:
    ld hl, wSuperAwakening.Items_Hidden
    ld c, $0
    
.set_items_hidden_loop
    ; Check if item slot is hidden
    ld a, [hl]
    cp 0
    jp z, .set_items_hidden_loop_next
    
    ; Update slot index to hidden
    push hl
    push af
    push bc
    ld a, c
    call SuperAwakening_Inventory_HideSlot
    pop bc
    pop af
    pop hl

.set_items_hidden_loop_next
    inc hl
    inc c
    ld a, c
    cp SUPER_AWAKENING_INVENTORY_SLOT_COUNT+2
    jp z, .set_items_hidden_loop_end
    jp .set_items_hidden_loop

.set_items_hidden_loop_end

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
    db $0A ; Powder
