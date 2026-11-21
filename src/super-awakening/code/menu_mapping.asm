;
; Start menu button prompts
;   A      => hide/show the selected item (see inventory_screen.asm)
;   B      => swap the sword and shield buttons
;   X / Y  => put the selected item on that button
;
IF SUPER_AWAKENING_MENU_MAPPING

IF !SUPER_AWAKENING_MENU_SWORD_SHIELD
    FAIL "SUPER_AWAKENING_MENU_MAPPING needs SUPER_AWAKENING_MENU_SWORD_SHIELD"
ENDC

; The HUD letters are tiles in the items sheet, so while the menu is open
; we draw B and A over the X and Y ones. The sheet gets reloaded when the
; game resumes, which puts them back.
MENU_TILE_B_LETTER  equ $BD
MENU_TILE_A_LETTER  equ $BB

; Blank tiles in the items sheet, used for the X and Y letters in the item list
MENU_TILE_X_LETTER  equ $A2
MENU_TILE_Y_LETTER  equ $A8

MENU_TILE_ADDRESS   equ $8800 - ($80 * TILE_SIZE)  ; Tile ids from $80 are at $8800

; Called while the menu loads, with the screen off
SuperAwakening_MenuOpen:
    ; Show the sword and shield on the buttons they are on
    ld   a, [wSuperAwakening.ButtonSwap]
    and  a
    call nz, SuperAwakening_MenuExchangeBA

    ld   hl, SuperAwakening_MenuGlyph_B
    ld   de, MENU_TILE_ADDRESS + (MENU_TILE_B_LETTER * TILE_SIZE)
    ld   bc, TILE_SIZE
    call CopyData
    ld   hl, SuperAwakening_MenuGlyph_A
    ld   de, MENU_TILE_ADDRESS + (MENU_TILE_A_LETTER * TILE_SIZE)
    ld   bc, TILE_SIZE
    call CopyData
    ld   hl, SuperAwakening_MenuGlyph_X
    ld   de, MENU_TILE_ADDRESS + (MENU_TILE_X_LETTER * TILE_SIZE)
    ld   bc, TILE_SIZE
    call CopyData
    ld   hl, SuperAwakening_MenuGlyph_Y
    ld   de, MENU_TILE_ADDRESS + (MENU_TILE_Y_LETTER * TILE_SIZE)
    ld   bc, TILE_SIZE
    jp   CopyData

SuperAwakening_MenuExchangeBA:
    ld   a, [wInventoryItems.BButtonSlot]
    ld   b, a
    ld   a, [wInventoryItems.AButtonSlot]
    ld   [wInventoryItems.BButtonSlot], a
    ld   a, b
    ld   [wInventoryItems.AButtonSlot], a
    ret

; B pressed: put the sword where the shield is, and the other way around
SuperAwakening_MenuSwapSwordShield:
    ld   hl, wSuperAwakening.ButtonSwap
    ld   a, [hl]
    xor  1
    ld   [hl], a
    call SuperAwakening_MenuExchangeBA

    ld   hl, hJingle
    ld   [hl], JINGLE_MOVE_SELECTION

    ; Redraw the two boxes from wInventoryItems
    xor  a
    ld   [wSuperAwakening.OverrideInventoryDisplaySlots], a
    ld   c, $01
    ld   b, $00
    ld   e, $FF
    call SuperAwakening_Trampoline.jumpToDrawInventorySlots

    ld   a, $20
    jp   SuperAwakening_Trampoline.returnToBank

; X or Y pressed: put the selected item on that button
SuperAwakening_MenuMapToX:
    ld   hl, wSuperAwakening.Weapon3_Inventory_Index
    ld   de, wSuperAwakening.Weapon4_Inventory_Index
    jr   SuperAwakening_MenuMapWeapon

SuperAwakening_MenuMapToY:
    ld   hl, wSuperAwakening.Weapon4_Inventory_Index
    ld   de, wSuperAwakening.Weapon3_Inventory_Index

; hl = index of the button being set, de = index of the other button
SuperAwakening_MenuMapWeapon:
    ld   a, [wInventorySelection]
    ld   c, a
    ld   b, $00

    ; Empty or hidden slots can't go on a button
    push hl
    ld   hl, wInventoryItems.subscreen
    add  hl, bc
    ld   a, [hl]
    cp   INVENTORY_EMPTY
    jr   z, .refuse
    ld   hl, wSuperAwakening.Items_Hidden
    add  hl, bc
    ld   a, [hl]
    and  a
    jr   nz, .refuse
    pop  hl

    ; Already on this button
    ld   a, c
    cp   [hl]
    jp   z, SuperAwakening_InventoryScreen_More.return

    ; If the other button has this item, it gets the one we're replacing
    ld   a, [de]
    cp   c
    jr   nz, .store
    ld   a, [hl]
    ld   [de], a
.store
    ld   [hl], c

    ld   hl, hJingle
    ld   [hl], JINGLE_VALIDATE
    call SuperAwakening_MenuRedrawLetters
    ; Updates the HUD values, then returns to the menu bank
    jp   SuperAwakening_InventoryScreen_More.refresh_weapon_3

.refuse
    pop  hl
    ld   hl, hJingle
    ld   [hl], JINGLE_WRONG_ANSWER
    jp   SuperAwakening_InventoryScreen_More.return

; Items moved with L/R: the buttons stay with their items.
; [wInventorySelection] = slot it's moving from, c = slot it's moving to
SuperAwakening_MenuFollowSwap:
    push bc
    ld   a, [wInventorySelection]
    ld   b, a
    ld   hl, wSuperAwakening.Weapon3_Inventory_Index
    call .follow
    ld   hl, wSuperAwakening.Weapon4_Inventory_Index
    call .follow
    pop  bc
    ret

.follow
    ld   a, [hl]
    cp   b
    jr   nz, .not_moving
    ld   [hl], c
    ret
.not_moving
    cp   c
    ret  nz
    ld   [hl], b
    ret

; Wait for vblank, then draw the letters
SuperAwakening_MenuRedrawLetters:
.poll_for_vblank
    ldh  a, [hNeedsRenderingFrame]
    and  a
    jr   z, .poll_for_vblank
    xor  a
    ldh  [hNeedsRenderingFrame], a

; Draws X and Y next to the items on those buttons. Writes straight to
; the tile map, so call it with the screen off or right after a vblank.
; Keeps bc, de and hl.
SuperAwakening_MenuDrawLetters:
    push bc
    push de
    push hl
    ld   c, $00
.loop
    ld   b, $7F ; Blank
    ld   a, [wSuperAwakening.Weapon3_Inventory_Index]
    cp   c
    jr   nz, .not_x
    ld   b, MENU_TILE_X_LETTER
.not_x
    ld   a, [wSuperAwakening.Weapon4_Inventory_Index]
    cp   c
    jr   nz, .not_y
    ld   b, MENU_TILE_Y_LETTER
.not_y
    ld   hl, SuperAwakening_MenuLetterCells
    ld   a, c
    add  a
    ld   e, a
    ld   d, $00
    add  hl, de
    ld   a, [hl+]
    ld   e, a
    ld   d, [hl]
    ld   a, b
    ld   [de], a
    inc  c
    ld   a, c
    cp   OVERRIDE_INVENTORY_LENGTH
    jr   nz, .loop
    pop  hl
    pop  de
    pop  bc
    ret

; Called from bank $20 once the menu is drawn, with the screen off
SuperAwakening_MenuDrawLettersFromLoad::
    call SuperAwakening_MenuDrawLetters
    ld   a, $20
    jp   SuperAwakening_Trampoline.returnToBank

; The tile left of each item in the list, in the order of the slots
SuperAwakening_MenuLetterCells:
    dw   vBGMap1 + $60, vBGMap1 + $64
    dw   vBGMap1 + $C0, vBGMap1 + $C4
    dw   vBGMap1 + $120, vBGMap1 + $124
    dw   vBGMap1 + $180, vBGMap1 + $184
    dw   vBGMap1 + $1E0, vBGMap1 + $1E4

; Same pixels as the HUD letters (B and A have the bracket, X and Y don't)
SuperAwakening_MenuGlyph_B:
    db   $00, $00, $73, $73, $4A, $4A, $4A, $4A, $72, $72, $4A, $4A, $4A, $4A, $72, $72
SuperAwakening_MenuGlyph_A:
    db   $00, $00, $33, $33, $4A, $4A, $4A, $4A, $7A, $7A, $4A, $4A, $4A, $4A, $4A, $4A
SuperAwakening_MenuGlyph_X:
    db   $00, $00, $88, $88, $88, $88, $50, $50, $20, $20, $50, $50, $88, $88, $88, $88
SuperAwakening_MenuGlyph_Y:
    db   $00, $00, $88, $88, $88, $88, $50, $50, $20, $20, $20, $20, $20, $20, $20, $20

; Swap the A and B buttons in the controller state at [hl]
SuperAwakening_SwapAB:
    ld   a, [hl]
    and  J_A | J_B
    ret  z
    cp   J_A | J_B
    ret  z
    ld   a, [hl]
    xor  J_A | J_B
    ld   [hl], a
    ret

ENDC
