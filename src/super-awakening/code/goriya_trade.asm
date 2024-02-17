
; [a] and [wSuperAwakening.Weapon3_Value] contains the item value
SuperAwakening_GoriyaTradeItem::
/*
	ld d, a 	; Keep the old item value in [d]

	; Disable item in progression
	ld b, $00
	ld c, a
	ld hl, wSuperAwakening.Items_Unlocked
	add hl, bc
	ld a, 0
	ld [hl], a

	; Enable boomerang in progression
	ld hl, (wSuperAwakening.Items_Unlocked+INVENTORY_BOOMERANG)
	ld a, 1
	ld [hl], a

	; Swap item in the inventory
.inventory_loop_init
	ld b, $00
	ld c, $FF

.inventory_loop

	inc c

	; Check for overflow
	ld a, c
	cp (INVENTORY_SLOT_COUNT+1)
	jp z, .inventory_loop_end

	; Check the inventory weapon slot value
	ld hl, wSuperAwakening.Weapon_Inventory
	add hl, bc
	ld a, [hl]
	cp d
	jp nz, .inventory_loop

	; Matches traded item, set to boomerang
	ld [hl], INVENTORY_BOOMERANG
	jp .inventory_loop

.inventory_loop_end

.inventory_update_equipped_items
	; Swap the boomerand into the equpped Y item
	ld a, INVENTORY_BOOMERANG
	ld [wSuperAwakening.Weapon4_Value], a

	; It's possible to have both X/Y pointing at the same inventory slot
	; Check if this happened, and update the X equipped item too
	ld a, [wSuperAwakening.Weapon3_Value]
	cp d
	jp nz, .inventory_update_equipped_items_end
	ld a, INVENTORY_BOOMERANG
	ld [wSuperAwakening.Weapon3_Value], a


.inventory_update_equipped_items_end
*/
	ret


SuperAwakening_GoriyaTradeReturnItem::
/*
; Swap out boomerang from the inventory
.find_boomerang_inventory_slot_loop_init
    ld   hl, wSuperAwakening.Weapon_Inventory
    ld   de, $0000                                ; $46F8: $11 $00 $00

.find_boomerang_inventory_slot_loop
    ld   a, [hl]                                  ; $46FB: $7E
    cp   INVENTORY_BOOMERANG                      ; $46FC: $FE $0D
    jr   z, .find_boomerang_inventory_slot_loop_end  ; $46FE: $28 $07

    inc  hl                                       ; $4700: $23
    inc  e                                        ; $4701: $1C
    ld   a, e                                     ; $4702: $7B
    cp   INVENTORY_SLOT_COUNT                     ; $4703: $FE $0C
    jr   nz, .find_boomerang_inventory_slot_loop  ; $4705: $20 $F4
.find_boomerang_inventory_slot_loop_end

.set_inventory_to_traded_item
    ld   a, [wBoomerangTradedItem]                ; $4707: $FA $7D $DB
    ld   [hl], a                                  ; $470A: $77


; Check if the boomerang is equipped
.inventory_update_equipped_items
	ld d, a
.inventory_update_equipped_items_check_weapon3
	ld a, [wSuperAwakening.Weapon3_Value]
	cp INVENTORY_BOOMERANG
	jp nz, .inventory_update_equipped_items_check_weapon4
	ld a, [wBoomerangTradedItem]
	ld [wSuperAwakening.Weapon3_Value], a
.inventory_update_equipped_items_check_weapon4
	ld a, [wSuperAwakening.Weapon4_Value]
	cp INVENTORY_BOOMERANG
	jp nz, .inventory_update_equipped_items_end
	ld a, [wBoomerangTradedItem]
	ld [wSuperAwakening.Weapon4_Value], a
.inventory_update_equipped_items_end

; Update progression flags
.update_progression
	; Enable traded item
	ld b, $00
	ld c, d
	ld hl, wSuperAwakening.Items_Unlocked
	add hl, bc
	ld a, 1
	ld [hl], a

	; Disable boomerang
	ld hl, (wSuperAwakening.Items_Unlocked+INVENTORY_BOOMERANG)
	ld a, 0
	ld [hl], a
*/
	ret
