; Saves the X/Y item mapping (and the sword/shield swap) with each save file.
;
; The data lives in SuperAwakeningSaveExt, after the three original save files,
; so the original save layout is untouched and old saves keep working.
; Per file (SAVE_EXT_SIZE bytes):
;   0 - SAVE_EXT_MAGIC (marks the data as ours)
;   1 - X item inventory index  (Weapon3)
;   2 - Y item inventory index  (Weapon4)
;   3 - sword/shield swap       (0 or 1)
;   4 - sum of bytes 0-3
; If the marker, sum or any value is wrong (old save, new file, garbage), or
; the saved items are no longer in the inventory, the defaults are used:
; X on slot 2, Y on slot 1, no swap.
IF SUPER_AWAKENING_SAVE_MAPPING

SAVE_EXT_MAGIC equ $5A

; In:  a = save slot (0-2)
; Out: hl = address of that slot's extra data
; Clobbers a, de
SuperAwakening_SaveExt_Address:
    sla  a
    ld   e, a
    ld   d, $00
    ld   hl, SuperAwakening_SaveExt_Table
    add  hl, de
    ld   a, [hl+]
    ld   h, [hl]
    ld   l, a
    ret

SuperAwakening_SaveExt_Table:
    dw   SuperAwakeningSaveExt.slot1
    dw   SuperAwakeningSaveExt.slot2
    dw   SuperAwakeningSaveExt.slot3

; Writes the current mapping for the current file. Called when saving.
SuperAwakening_SaveExt_Save:
    ld   a, [wSaveSlot]
    call SuperAwakening_SaveExt_Address

    call EnableSRAM
    ld   a, SAVE_EXT_MAGIC
    ld   [hl+], a
    ld   b, a

    ld   a, [wSuperAwakening.Weapon3_Inventory_Index]
    call EnableSRAM
    ld   [hl+], a
    add  b
    ld   b, a

    ld   a, [wSuperAwakening.Weapon4_Inventory_Index]
    call EnableSRAM
    ld   [hl+], a
    add  b
    ld   b, a

IF SUPER_AWAKENING_MENU_MAPPING
    ld   a, [wSuperAwakening.ButtonSwap]
ELSE
    xor  a
ENDC
    call EnableSRAM
    ld   [hl+], a
    add  b

    call EnableSRAM
    ld   [hl], a
    ret

; Reads the mapping of the current file. Called after the defaults are set,
; and leaves them alone if the file has no valid data.
SuperAwakening_SaveExt_Load:
    ld   a, [wSaveSlot]
    call SuperAwakening_SaveExt_Address

    call EnableSRAM
    ld   a, [hl+]
    cp   SAVE_EXT_MAGIC
    ret  nz
    ld   b, a

    call EnableSRAM
    ld   a, [hl+]
    ld   d, a                       ; d = X index
    add  b
    ld   b, a

    call EnableSRAM
    ld   a, [hl+]
    ld   e, a                       ; e = Y index
    add  b
    ld   b, a

    call EnableSRAM
    ld   a, [hl+]
    ld   c, a                       ; c = swap
    add  b
    ld   b, a

    call EnableSRAM
    ld   a, [hl]
    cp   b
    ret  nz

    ld   a, d
    cp   OVERRIDE_INVENTORY_LENGTH
    ret  nc
    ld   a, e
    cp   OVERRIDE_INVENTORY_LENGTH
    ret  nc
    ld   a, c
    cp   $02
    ret  nc

    ; Both items must still be in the inventory (the file may have been
    ; changed in vanilla), and they can't be the same item.
    push af                         ; keep the swap
    ld   a, d
    cp   e
    jr   z, .items_missing
    ld   b, $00
    ld   c, d
    ld   hl, wInventoryItems.subscreen
    add  hl, bc
    ld   a, [hl]
    cp   INVENTORY_EMPTY
    jr   z, .items_missing
    ld   c, e
    ld   hl, wInventoryItems.subscreen
    add  hl, bc
    ld   a, [hl]
    cp   INVENTORY_EMPTY
    jr   z, .items_missing
    pop  af
    jr   .apply

.items_missing
    pop  af
    ret

.apply
    ; Valid, apply it
IF SUPER_AWAKENING_MENU_MAPPING
    ld   [wSuperAwakening.ButtonSwap], a
ENDC

    ld   b, $00
    ld   c, d
    ld   hl, wInventoryItems.subscreen
    add  hl, bc
    ld   a, [hl]
    ld   [wSuperAwakening.Weapon3_Value], a
    ld   a, d
    ld   [wSuperAwakening.Weapon3_Inventory_Index], a

    ld   c, e
    ld   hl, wInventoryItems.subscreen
    add  hl, bc
    ld   a, [hl]
    ld   [wSuperAwakening.Weapon4_Value], a
    ld   a, e
    ld   [wSuperAwakening.Weapon4_Inventory_Index], a
    ret

; Clears the data of the current file. Called when a file is erased.
SuperAwakening_SaveExt_Clear::
    ld   a, [wSaveSlot]
    call SuperAwakening_SaveExt_Address

    ld   b, SAVE_EXT_SIZE
    xor  a
.loop
    call EnableSRAM
    ld   [hl+], a
    dec  b
    jr   nz, .loop

    ld   a, $01
    jp   SuperAwakening_Trampoline.returnToBank

; Copies the data from the file being copied to the file it is copied onto.
SuperAwakening_SaveExt_Copy::
    ld   a, [wIntroTimer]           ; Source file
    call SuperAwakening_SaveExt_Address
    ld   b, h
    ld   c, l

    ld   a, [wIntroSubTimer]        ; Destination file
    call SuperAwakening_SaveExt_Address

    ld   d, SAVE_EXT_SIZE
.loop
    call EnableSRAM
    ld   a, [bc]
    inc  bc
    call EnableSRAM
    ld   [hl+], a
    dec  d
    jr   nz, .loop

    ld   a, $01
    jp   SuperAwakening_Trampoline.returnToBank

ENDC
