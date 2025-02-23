TUTORIAL_SAVE_SLOT = 2

; Map locations for the tutorial rooms
TUTORIAL_START_LOCATION = $F1
TUTORIAL_LOCATION_2 = $E1
TUTORIAL_LOCATION_3 = $E0
TUTORIAL_LOCATION_4 = $D0
TUTORIAL_LOCATION_5 = $C0
TUTORIAL_LOCATION_6 = $B0

; Dialog pointers for tutorial owl text
TUTORIAL_DIALOG_INDEX_1 = $B0
TUTORIAL_DIALOG_INDEX_2 = $B1
TUTORIAL_DIALOG_INDEX_3 = $B2
TUTORIAL_DIALOG_INDEX_4 = $B3
TUTORIAL_DIALOG_INDEX_5 = $B4
TUTORIAL_DIALOG_INDEX_6 = $B5
TUTORIAL_DIALOG_SIGNPOST_1 = $B6

; Bit flags used to toggle gameplay features in the tutorial
TUTORIAL_DISABLE_RL             = $01
TUTORIAL_DISABLE_QUICK_LIFT     = $02
TUTORIAL_DISABLE_QUICK_DASH     = $04
TUTORIAL_DISABLE_START          = $08
TUTORIAL_DISABLE_SELECT         = $10
TUTORIAL_HAS_OWL_OVERRIDE_TILES = $20
TUTORIAL_DISABLE_DIRECTIONS     = $40

TUTORIAL_STARTING_FLAGS = ( TUTORIAL_DISABLE_RL | TUTORIAL_DISABLE_QUICK_LIFT | TUTORIAL_DISABLE_QUICK_DASH | TUTORIAL_DISABLE_START | TUTORIAL_DISABLE_START | TUTORIAL_DISABLE_SELECT | TUTORIAL_HAS_OWL_OVERRIDE_TILES | TUTORIAL_DISABLE_DIRECTIONS)

ALL_DUENGON_MAP_IDS = (MAP_TAIL_CAVE | MAP_BOTTLE_GROTTO | MAP_KEY_CAVERN | MAP_ANGLERS_TUNNEL | MAP_CATFISHS_MAW | MAP_FACE_SHRINE | MAP_EAGLES_TOWER | MAP_TURTLE_ROCK | MAP_WINDFISHS_EGG )

; Sets [bc] to the room list to load
; Also, configres any tutorial status flags on room load
SuperAwakening_Tutorial_Room::

    ; Skip if we've completed the tutorial
    ld a, [wSuperAwakening.Tutorial_Status]
    cp 0
    jp z, .return

    ; Check if we need to run cleanup
    cp TUTORIAL_HAS_OWL_OVERRIDE_TILES
    jp z, .tutorial_reset

    jp .tutorial_room_override

.tutorial_reset
    ; Need to restore [bc] after this
    push bc

    ; Return tiles to temple keys
    ld a, 0
    ld [wSuperAwakening.Tutorial_Status], a

.poll_for_vblank_reset
    ldh  a, [hNeedsRenderingFrame]                ; $0374: $F0 $D1
    and  a                                        ; $0376: $A7
    jr   z, .poll_for_vblank_reset              ; $0377: $28 $FB
    ; Clear hNeedsRenderingFrame
    xor  a                                        ; $0379: $AF
    ldh  [hNeedsRenderingFrame], a                ; $037A: $E0 $D1
.poll_for_vblank_end_reset

    ; Restore fist 2 keys
    ld   hl, SuperAwakening_InventoryOverworldItemsTiles
    ld   de, vTiles1 + $400                       ; $2D41: $11 $00 $8C
    ld   bc, TILE_SIZE * 4
    call CopyData

.poll_for_vblank_reset_b
    ldh  a, [hNeedsRenderingFrame]                ; $0374: $F0 $D1
    and  a                                        ; $0376: $A7
    jr   z, .poll_for_vblank_reset_b              ; $0377: $28 $FB
    ; Clear hNeedsRenderingFrame
    xor  a                                        ; $0379: $AF
    ldh  [hNeedsRenderingFrame], a                ; $037A: $E0 $D1
.poll_for_vblank_end_reset_b

    ; Restore second 2 keys
    ld   hl, ( SuperAwakening_InventoryOverworldItemsTiles + TILE_SIZE*4 )
    ld   de, vTiles1 + $440                       ; $2D41: $11 $00 $8C
    ld   bc, TILE_SIZE * 4
    call CopyData
    
    pop bc
    jp .return

.tutorial_room_override
    ldh  a, [hMapRoom]

.check_location_1      
    cp TUTORIAL_START_LOCATION
    jp nz, .check_location_2
    ld b, HIGH(Tutorial_Override_1+1)
    ld c, LOW(Tutorial_Override_1+1)
    jp .return
    
.check_location_2
    cp TUTORIAL_LOCATION_2
    jp nz, .check_location_3
    
    ; Enable RL
    ld a, [wSuperAwakening.Tutorial_Status]
    and (~TUTORIAL_DISABLE_RL)
    ld [wSuperAwakening.Tutorial_Status], a

    ld b, HIGH(Tutorial_Override_2+1)
    ld c, LOW(Tutorial_Override_2+1)
    jp .return

.check_location_3
    cp TUTORIAL_LOCATION_3
    jp nz, .check_location_4
    
    ; Enable Quick Lift
    ld a, [wSuperAwakening.Tutorial_Status]
    and (~TUTORIAL_DISABLE_QUICK_LIFT)
    ld [wSuperAwakening.Tutorial_Status], a

    ld b, HIGH(Tutorial_Override_3+1)
    ld c, LOW(Tutorial_Override_3+1)
    jp .return

.check_location_4
    cp TUTORIAL_LOCATION_4
    jp nz, .check_location_5

    ; Enable Quick Dash
    ld a, [wSuperAwakening.Tutorial_Status]
    and (~TUTORIAL_DISABLE_QUICK_DASH)
    ld [wSuperAwakening.Tutorial_Status], a

    ; Copy over the block tileset

    ; Inputs:
    ;   bc : number of bytes to copy
    ;   de : destination address
    ;   hl : source address
.poll_for_vblank_5
    ldh  a, [hNeedsRenderingFrame]                ; $0374: $F0 $D1
    and  a                                        ; $0376: $A7
    jr   z, .poll_for_vblank_5              ; $0377: $28 $FB
    ; Clear hNeedsRenderingFrame
    xor  a                                        ; $0379: $AF
    ldh  [hNeedsRenderingFrame], a                ; $037A: $E0 $D1
.poll_for_vblank_end_5

    ; Replace top open chest with top dash rock
    ld de, $9620
    ld hl, (SuperAwakening_Gfx_Tutorial + ($20*0))
    ld   bc, $20
    call CopyData

    ; Replace bottom chest with top bottom rock
    ld de, $9700
    ld hl, (SuperAwakening_Gfx_Tutorial + ($20*1))
    ld   bc, $20
    call CopyData

    ld b, HIGH(Tutorial_Override_4+1)
    ld c, LOW(Tutorial_Override_4+1)
    jp .return

.check_location_5
    cp TUTORIAL_LOCATION_5
    jp nz, .check_location_6

    ; Enable Start
    ld a, [wSuperAwakening.Tutorial_Status]
    and (~TUTORIAL_DISABLE_START)
    ld [wSuperAwakening.Tutorial_Status], a

    ld b, HIGH(Tutorial_Override_5+1)
    ld c, LOW(Tutorial_Override_5+1)
    jp .return

.check_location_6
    cp TUTORIAL_LOCATION_6
    jp nz, .return

    push bc

    ; Copy over the owl tileset again

    ; Inputs:
    ;   bc : number of bytes to copy
    ;   de : destination address
    ;   hl : source address
.poll_for_vblank_6
    ldh  a, [hNeedsRenderingFrame]                ; $0374: $F0 $D1
    and  a                                        ; $0376: $A7
    jr   z, .poll_for_vblank_6              ; $0377: $28 $FB
    ; Clear hNeedsRenderingFrame
    xor  a                                        ; $0379: $AF
    ldh  [hNeedsRenderingFrame], a                ; $037A: $E0 $D1
.poll_for_vblank_end_6

    ; Replace temple keys with Owl tiles
    ld de, $8C00
    ld hl, (SuperAwakening_Gfx_Tutorial + ($20*2))
    ld bc, $40
    call CopyData

.poll_for_vblank_6_2
    ldh  a, [hNeedsRenderingFrame]                ; $0374: $F0 $D1
    and  a                                        ; $0376: $A7
    jr   z, .poll_for_vblank_6_2
    ; Clear hNeedsRenderingFrame
    xor  a                                        ; $0379: $AF
    ldh  [hNeedsRenderingFrame], a                ; $037A: $E0 $D1
.poll_for_vblank_end_6_2

    ; Replace temple keys with Owl tiles
    ld de, $8C40
    ld hl, (SuperAwakening_Gfx_Tutorial + ($20*4))
    ld   bc, $40
    call CopyData

    pop bc

    jp .return


.return
    ld  a, $1A
    jp SuperAwakening_Trampoline.returnToBank


; Set [bc] to the entity list to load
SuperAwakening_Tutorial_Entities::

    ; Skip if we've not in the tutorial save
    ld a, [wSaveSlot]
    cp TUTORIAL_SAVE_SLOT
    jp nz, .return

.quit_if_entering_dungeon
    ld a, [wIsIndoor]
    cp 1
    jp nz, .quit_if_entering_dungeon_end

    ld a, [hMapId]
    and ALL_DUENGON_MAP_IDS
    jp nz, .quit_if_entering_dungeon_end

.do_exit
    
    ; Kill link
    ld a, 0
    ld [wHealth], a

    ; Prevent dungeon message
    ldh  [hDungeonTitleMessageCountdown], a
    
    ld a, 1
    ld [wSuperAwakening.Tutorial_ForceQuit], a
.quit_if_entering_dungeon_end

    ; Skip if we've completed the tutorial
    ld a, wSuperAwakening.Tutorial_Status
    cp 0
    jp z, .return

    ldh  a, [hMapRoom]

.check_location_1
    cp TUTORIAL_START_LOCATION
    jp nz, .check_location_1_end

    ld a, [wSuperAwakening.Tutorial_Status]
    cp TUTORIAL_STARTING_FLAGS
    jp z, .use_cutscene_entities

    ld b, HIGH(Tutorial_Entities_1)
    ld c, LOW(Tutorial_Entities_1)
    jp .return
.use_cutscene_entities
    ld b, HIGH(Tutorial_Entities_1_cutscene)
    ld c, LOW(Tutorial_Entities_1_cutscene)
    jp .return
.check_location_1_end

.check_location_2
    cp TUTORIAL_LOCATION_2
    jp nz, .check_location_2_end

    ld b, HIGH(Tutorial_Entities_2)
    ld c, LOW(Tutorial_Entities_2)
    jp .return
.check_location_2_end

.check_location_3
    cp TUTORIAL_LOCATION_3
    jp nz, .check_location_3_end
    ld b, HIGH(Tutorial_Entities_3)
    ld c, LOW(Tutorial_Entities_3)
    jp .return
.check_location_3_end

.check_location_4
    cp TUTORIAL_LOCATION_4
    jp nz, .check_location_4_end
    ld b, HIGH(Tutorial_Entities_4)
    ld c, LOW(Tutorial_Entities_4)
    jp .return
.check_location_4_end

.check_location_5
    cp TUTORIAL_LOCATION_5
    jp nz, .check_location_5_end
    ld b, HIGH(Tutorial_Entities_5)
    ld c, LOW(Tutorial_Entities_5)
    jp .return
.check_location_5_end

.check_location_6
    cp TUTORIAL_LOCATION_6
    jp nz, .check_location_6_end
    ld b, HIGH(Tutorial_Entities_6)
    ld c, LOW(Tutorial_Entities_6)
    jp .return
.check_location_6_end

.return
    ld   a, BANK(OverworldEntitiesPointersTable)
    jp SuperAwakening_Trampoline.returnToBank

; Sets wSuperAwakening.dialog_backup to the entry in the DialogPointerTable to display during own dialogs
SuperAwakening_Tutorial_Dialog::
    
    ; Skip if we've completed the tutorial
    ld a, [wSuperAwakening.Tutorial_Status]
    cp 0
    jp z, .return

    ; Checking map room value
    ldh  a, [hMapRoom]
    
.check_location_1
    cp TUTORIAL_START_LOCATION
    jp nz, .check_location_1_end

    ;; Start Cutscene code
    ; Remove urchin [link placeholder]
    ld a, 0
    ld [wEntitiesStatusTable+1], a

    ; Move link back to position
    ld a, $5B
    ld [hLinkPositionY], a

    ; Make link look up
    ld a, $04
    ld [hLinkAnimationState], a

    ; Enable movement
    ld a, [wSuperAwakening.Tutorial_Status]
    and (~TUTORIAL_DISABLE_DIRECTIONS)
    ld [wSuperAwakening.Tutorial_Status], a

    ;; End Cutscene code
    
    ld a, TUTORIAL_DIALOG_INDEX_1
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_1_end

.check_location_2
    cp TUTORIAL_LOCATION_2
    jp nz, .check_location_2_end
    ld a, TUTORIAL_DIALOG_INDEX_2
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_2_end

.check_location_3
    cp TUTORIAL_LOCATION_3
    jp nz, .check_location_3_end
    ld a, TUTORIAL_DIALOG_INDEX_3
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_3_end

.check_location_4
    cp TUTORIAL_LOCATION_4
    jp nz, .check_location_4_end
    ld a, TUTORIAL_DIALOG_INDEX_4
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_4_end

.check_location_5
    cp TUTORIAL_LOCATION_5
    jp nz, .check_location_5_end
    ld a, TUTORIAL_DIALOG_INDEX_5
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_5_end

.check_location_6
    cp TUTORIAL_LOCATION_6
    jp nz, .check_location_6_end

    ; Enable Select
    ld a, [wSuperAwakening.Tutorial_Status]
    and (~TUTORIAL_DISABLE_SELECT)
    ld [wSuperAwakening.Tutorial_Status], a

    ld a, TUTORIAL_DIALOG_INDEX_6
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_6_end

.return
    ; Restore the rombank
    ld  a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_Tutorial_Tiles::

    ; Skip if we've completed the tutorial
    ld a, wSuperAwakening.Tutorial_Status
    cp 0
    jp z, .return

    ldh  a, [hMapRoom]

.check_location_1
    cp TUTORIAL_START_LOCATION
    jp nz, .check_location_1_end

    ; Copy data
    ; Inputs:
    ;   bc : number of bytes to copy
    ;   de : destination address
    ;   hl : source address

    ; Replace top open chest with top dash rock
    ld de, $9620
    ld hl, (SuperAwakening_Gfx_Tutorial + ($20*0))
    ld   bc, $20
    call CopyData

    ; Replace bottom chest with top bottom rock
    ld de, $9700
    ld hl, (SuperAwakening_Gfx_Tutorial + ($20*1))
    ld   bc, $20
    call CopyData

    ; Replace temple keys with Owl tiles
    ld de, $8C00
    ld hl, (SuperAwakening_Gfx_Tutorial + ($20*2))
    ld   bc, $80
    call CopyData

    ; Replace link with sleeping link
    ld de, $89C0
    ld hl, (SuperAwakening_Gfx_Tutorial + ($20*6))
    ld   bc, $40
    call CopyData

    ; Move urchin/sleep-link to cutscene location
    ld a, $50
    ld [wEntitiesPosXTable+1], a

    ld a, $5B
    ld [wEntitiesPosYTable+1], a

    ld a, DIRECTION_UP
    ld [hLinkDirection], a
.check_location_1_end

.return
    ret