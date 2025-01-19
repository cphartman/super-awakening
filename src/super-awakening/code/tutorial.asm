TUTORIAL_SAVE_SLOT = 2

; Map locations for the tutorial rooms
TUTORIAL_START_LOCATION = $F1
TUTORIAL_LOCATION_2 = $E1
TUTORIAL_LOCATION_3 = $E0
TUTORIAL_LOCATION_4 = $D0
TUTORIAL_LOCATION_5 = $C0
TUTORIAL_LOCATION_6 = $B0

; Bit flags used to toggle gameplay features in the tutorial
TUTORIAL_DISABLE_RL         = $01
TUTORIAL_DISABLE_QUICK_LIFT = $02
TUTORIAL_DISABLE_QUICK_DASH = $04
TUTORIAL_DISABLE_START      = $08
TUTORIAL_DISABLE_SELECT     = $10

TUTORIAL_STARTING_FLAGS = ( TUTORIAL_DISABLE_RL | TUTORIAL_DISABLE_QUICK_LIFT | TUTORIAL_DISABLE_QUICK_DASH | TUTORIAL_DISABLE_START | TUTORIAL_DISABLE_START | TUTORIAL_DISABLE_SELECT )

SuperAwakening_Tutorial_Room::

    ; Skip if we've completed the tutorial
    ld a, [wSuperAwakening.Tutorial_Status]
    cp 0
    jp z, .return

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

    ; Enable Select
    ld a, [wSuperAwakening.Tutorial_Status]
    and (~TUTORIAL_DISABLE_SELECT)
    ld [wSuperAwakening.Tutorial_Status], a

    jp .return


.return
    ld  a, $1A
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_Tutorial_Entitles::
    ; Skip if we've completed the tutorial
    ld a, wSuperAwakening.Tutorial_Status
    cp 0
    jp z, .return

    ldh  a, [hMapRoom]

.check_location_1
    cp TUTORIAL_START_LOCATION
    jp nz, .check_location_1_end

    ld b, HIGH(Tutorial_Entities_1)
    ld c, LOW(Tutorial_Entities_1)
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

SuperAwakening_Tutorial_Dialog::
    
    ; Use current value
    ldh  a, [hMapRoom]
    ld [wSuperAwakening.dialog_backup], a

    ; Skip if we've completed the tutorial
    ld a, wSuperAwakening.Tutorial_Status
    cp 0
    jp z, .return

    ldh  a, [hMapRoom]
    
.check_location_1
    cp TUTORIAL_START_LOCATION
    jp nz, .check_location_1_end
    ld a, $A4
    ld [wSuperAwakening.dialog_backup], a

    ; Remove urchin [link placeholder]
    ld a, 0
    ld [wEntitiesStatusTable+1], a

    ; Move link back to position
    ld a, $5B
    ld [hLinkPositionY], a

    ; Make link look up
    ld a, $04
    ld [hLinkAnimationState], a
    
    jp .return
.check_location_1_end

.check_location_2
    cp TUTORIAL_LOCATION_2
    jp nz, .check_location_2_end
    ld a, $A5
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_2_end

.check_location_3
    cp TUTORIAL_LOCATION_3
    jp nz, .check_location_3_end
    ld a, $A6
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_3_end

.check_location_4
    cp TUTORIAL_LOCATION_4
    jp nz, .check_location_4_end
    ld a, $A7
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_4_end

.check_location_5
    cp TUTORIAL_LOCATION_5
    jp nz, .check_location_5_end
    ld a, $A8
    ld [wSuperAwakening.dialog_backup], a
    jp .return
.check_location_5_end

.check_location_6
    cp TUTORIAL_LOCATION_6
    jp nz, .check_location_6_end
    ld a, $A9
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
    cp TUTORIAL_START_LOCATION
    jp nz, .return

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

.return
    ret