; States
SCREENSCROLL_STATE_NONE = 0
SCREENSCROLL_FOLLOW_LINK = 1
SCREENSCROLL_DISABLE = 2

; Perform calculations on the center of the window instead of the top left
; This prevents needing to deal with wrapping issues around 0
SCREENSCROLL_WINDOW_OFFSET = $8000

seta8

ScreenScroll:
ScreenScroll_Init:
   ; Set flags we use
   .i16
   setxy16
   .a8
   seta8

    ; Set rom bank to Super Awakening
    LDA #^SuperAwakeining_Snes_Wram
    PHA
    PLB

ScreenScroll_StateCheck:
    ; Are we in a state?
    lda ScreenScroll_State
    cmp #0
    bne ScreenScroll_StateJump
    
    ; No state
    jml ScreenScroll_End

ScreenScroll_StateJump:
    ; Jump to the curernt state
    tax
    lda ScreenScroll_JumpTable_Low,X
    sta $00  ; Store low byte
    lda ScreenScroll_JumpTable_High,X
    sta $01  ; Store high byte
    lda ScreenScroll_JumpTable_Bank,X
    sta $02  ; Store bank byte

    JML [$00]

; Jump table for the states
ScreenScroll_JumpTable:
ScreenScroll_JumpTable_Low:
.byte <ScreenScroll_End
.byte <ScreenScroll_FollowLink
.byte <ScreenScroll_Disable
ScreenScroll_JumpTable_High:
.byte >ScreenScroll_End
.byte >ScreenScroll_FollowLink
.byte >ScreenScroll_Disable
ScreenScroll_JumpTable_Bank:
.byte ^ScreenScroll_End
.byte ^ScreenScroll_FollowLink
.byte ^ScreenScroll_Disable


ScreenScroll_FollowLink:

ScreenScroll_FollowLink_Init:
    ; If current link position is 0...
    lda f:ScreenScroll_LinkPositionX
    bne ScreenScroll_FollowLink_Scroll
    lda f:ScreenScroll_LinkPositionY
    bne ScreenScroll_FollowLink_Scroll

    ; .. set current link position to new link position
    lda f:command+1
    sta f:ScreenScroll_LinkPositionX
    lda f:command+2
    sta f:ScreenScroll_LinkPositionY

    ; .. set window position to default position
    .a16
    seta16
    lda #SCREENSCROLL_WINDOW_OFFSET
    sta f:ScreenScroll_WindowPositionX
    sta f:ScreenScroll_WindowPositionY
    sta f:ScreenScroll_WindowTargetX
    sta f:ScreenScroll_WindowTargetY
    .a8
    seta8

    jml ScreenScroll_End

ScreenScroll_FollowLink_Scroll:
    WAIT_FOR_VBLANK

    ; Only show BG 3
    lda #$04
    sta f:$212C

ScreenScroll_FollowLink_ScrollX:
    ; Get X Delta
    sec
    lda f:command+1
    sbc f:ScreenScroll_LinkPositionX

    beq ScreenScroll_FollowLink_ScrollX_End
    bcs ScreenScroll_FollowLink_ScrollX_Increment
    jmp ScreenScroll_FollowLink_ScrollX_Decrement

ScreenScroll_FollowLink_ScrollX_Increment:

    ; Add delta to window position
    .a16
    seta16
    and #$00FF
    pha
    clc
    lda f:ScreenScroll_WindowTargetX
    adc $01, s
    sta f:ScreenScroll_WindowTargetX
    pla
    lda f:ScreenScroll_WindowTargetX


ScreenScroll_FollowLink_ScrollX_ClampMax:
SCREENSCROLL_CLAMP_X_MAX = $8030
ScreenScroll_FollowLink_ScrollX_ClampMax_Check:
    sec
    sbc #SCREENSCROLL_CLAMP_X_MAX
    bcs ScreenScroll_FollowLink_ScrollX_ClampMax_Apply
    jmp ScreenScroll_FollowLink_ScrollX_ClampMax_End
ScreenScroll_FollowLink_ScrollX_ClampMax_Apply:
    lda #SCREENSCROLL_CLAMP_X_MAX
    sta f:ScreenScroll_WindowTargetX
ScreenScroll_FollowLink_ScrollX_ClampMax_End:

    jmp ScreenScroll_FollowLink_ScrollX_End

ScreenScroll_FollowLink_ScrollX_Decrement:

    ; Invert the delta because we are going to subtract
    sec
    lda f:ScreenScroll_LinkPositionX
    sbc f:command+1

    ; Add delta to window position
    .a16
    seta16
    and #$00FF
    pha
    sec
    lda f:ScreenScroll_WindowTargetX
    sbc $01, s
    sta f:ScreenScroll_WindowTargetX
    pla
    lda f:ScreenScroll_WindowTargetX

ScreenScroll_FollowLink_ScrollX_ClampMin:
SCREENSCROLL_CLAMP_X_MIN = $7FD0
ScreenScroll_FollowLink_ScrollX_ClampMin_Check:
    sec
    sbc #SCREENSCROLL_CLAMP_X_MIN
    bcc ScreenScroll_FollowLink_ScrollX_ClampMin_Apply
    jmp ScreenScroll_FollowLink_ScrollX_ClampMin_End
ScreenScroll_FollowLink_ScrollX_ClampMin_Apply:
    lda #SCREENSCROLL_CLAMP_X_MIN
    sta f:ScreenScroll_WindowTargetX
ScreenScroll_FollowLink_ScrollX_ClampMin_End:
    jmp ScreenScroll_FollowLink_ScrollX_End
ScreenScroll_FollowLink_ScrollX_End:
;;
;; Scroll Y
;;

ScreenScroll_FollowLink_ScrollY:
    ; Get X Delta
    sec
    lda f:command+2
    sbc f:ScreenScroll_LinkPositionY

    beq ScreenScroll_FollowLink_ScrollY_End
    bcs ScreenScroll_FollowLink_ScrollY_Increment
    jmp ScreenScroll_FollowLink_ScrollY_Decrement

ScreenScroll_FollowLink_ScrollY_Increment:

    ; Add delta to window position
    .a16
    seta16
    and #$00FF
    pha
    clc
    lda f:ScreenScroll_WindowTargetY
    adc $01, s
    sta f:ScreenScroll_WindowTargetY
    pla
    lda f:ScreenScroll_WindowTargetY


ScreenScroll_FollowLink_ScrollY_ClampMax:
SCREENSCROLL_CLAMP_Y_MAX = $8028
ScreenScroll_FollowLink_ScrollY_ClampMax_Check:
    sec
    sbc #SCREENSCROLL_CLAMP_Y_MAX
    bcs ScreenScroll_FollowLink_ScrollY_ClampMax_Apply
    jmp ScreenScroll_FollowLink_ScrollY_ClampMax_End
ScreenScroll_FollowLink_ScrollY_ClampMax_Apply:
    lda #SCREENSCROLL_CLAMP_Y_MAX
    sta f:ScreenScroll_WindowTargetY
ScreenScroll_FollowLink_ScrollY_ClampMax_End:

    jmp ScreenScroll_FollowLink_ScrollY_End

ScreenScroll_FollowLink_ScrollY_Decrement:

    ; Invert the delta because we are going to subtract
    sec
    lda f:ScreenScroll_LinkPositionY
    sbc f:command+2

    ; Add delta to window position
    .a16
    seta16
    and #$00FF
    pha
    sec
    lda f:ScreenScroll_WindowTargetY
    sbc $01, s
    sta f:ScreenScroll_WindowTargetY
    pla
    lda f:ScreenScroll_WindowTargetY

ScreenScroll_FollowLink_ScrollY_ClampMin:
SCREENSCROLL_CLAMP_Y_MIN = $7FD8
ScreenScroll_FollowLink_ScrollY_ClampMin_Check:
    sec
    sbc #SCREENSCROLL_CLAMP_Y_MIN
    bcc ScreenScroll_FollowLink_ScrollY_ClampMin_Apply
    jmp ScreenScroll_FollowLink_ScrollY_ClampMin_End
ScreenScroll_FollowLink_ScrollY_ClampMin_Apply:
    lda #SCREENSCROLL_CLAMP_Y_MIN
    sta f:ScreenScroll_WindowTargetY
ScreenScroll_FollowLink_ScrollY_ClampMin_End:
    jmp ScreenScroll_FollowLink_ScrollY_End
ScreenScroll_FollowLink_ScrollY_End:

ScreenScroll_FollowLink_UpdatePositionFromTarget:
    .a16
    seta16

ScreenScroll_FollowLink_UpdatePositionX:
    lda f:ScreenScroll_WindowPositionX
    pha
    lda f:ScreenScroll_WindowTargetX
    sec
    sbc $01, s
    tax
    pla
    txa
    beq ScreenScroll_FollowLink_UpdatePositionX_end
    bcs ScreenScroll_FollowLink_UpdatePositionX_Increment
    jmp ScreenScroll_FollowLink_UpdatePositionX_Decrement
ScreenScroll_FollowLink_UpdatePositionX_Increment:
    lda f:ScreenScroll_WindowPositionX
    inc a
    sta f:ScreenScroll_WindowPositionX
    cmp f:ScreenScroll_WindowTargetX
    beq ScreenScroll_FollowLink_UpdatePositionX_end
    inc a
    sta f:ScreenScroll_WindowPositionX
    jmp ScreenScroll_FollowLink_UpdatePositionX_end
ScreenScroll_FollowLink_UpdatePositionX_Decrement:
    lda f:ScreenScroll_WindowPositionX
    dec a
    sta f:ScreenScroll_WindowPositionX
    cmp f:ScreenScroll_WindowTargetX
    beq ScreenScroll_FollowLink_UpdatePositionX_end
    dec a
    sta f:ScreenScroll_WindowPositionX
    jmp ScreenScroll_FollowLink_UpdatePositionX_end
ScreenScroll_FollowLink_UpdatePositionX_end:

ScreenScroll_FollowLink_UpdatePositionY:
    lda f:ScreenScroll_WindowPositionY
    pha
    lda f:ScreenScroll_WindowTargetY
    sec
    sbc $01, s
    tax
    pla
    txa
    beq ScreenScroll_FollowLink_UpdatePositionY_end
    bcs ScreenScroll_FollowLink_UpdatePositionY_Increment
    jmp ScreenScroll_FollowLink_UpdatePositionY_Decrement
ScreenScroll_FollowLink_UpdatePositionY_Increment:
    lda f:ScreenScroll_WindowPositionY
    inc a
    sta f:ScreenScroll_WindowPositionY
    cmp f:ScreenScroll_WindowTargetY
    beq ScreenScroll_FollowLink_UpdatePositionY_end
    inc a
    sta f:ScreenScroll_WindowPositionY
    jmp ScreenScroll_FollowLink_UpdatePositionY_end
ScreenScroll_FollowLink_UpdatePositionY_Decrement:
    lda f:ScreenScroll_WindowPositionY
    dec a
    sta f:ScreenScroll_WindowPositionY
    cmp f:ScreenScroll_WindowTargetY
    beq ScreenScroll_FollowLink_UpdatePositionY_end
    dec a
    sta f:ScreenScroll_WindowPositionY
    jmp ScreenScroll_FollowLink_UpdatePositionY_end
ScreenScroll_FollowLink_UpdatePositionY_end:

ScreenScroll_FollowLink_UpdatePPU:

    .a16
    seta16
    lda f:ScreenScroll_WindowPositionX
    sec
    sbc #SCREENSCROLL_WINDOW_OFFSET

    ; I cant figure out how to write 16 bits here properly?
    .a8
    seta8
    sta f:BG3HOFS
    xba
    sta f:BG3HOFS

    .a16
    seta16
    lda f:ScreenScroll_WindowPositionY
    sec
    sbc #SCREENSCROLL_WINDOW_OFFSET

    .a8
    seta8
    sta f:BG3VOFS
    xba
    sta f:BG3VOFS

    ; Update link position
    lda f:command+1
    sta f:ScreenScroll_LinkPositionX
    lda f:command+2
    sta f:ScreenScroll_LinkPositionY

    lda #SCREENSCROLL_STATE_NONE
    sta f:ScreenScroll_State

    jml ScreenScroll_End

ScreenScroll_Disable:

    ; Reset everything
    .a8
    seta8
    lda #0
    sta f:BG3VOFS
    sta f:BG3VOFS
    sta f:BG3HOFS
    sta f:BG3HOFS
    sta f:ScreenScroll_LinkPositionX
    sta f:ScreenScroll_LinkPositionY
    
    ; Show BG 2+3
    lda #$06
    sta f:$212C
    
    jml ScreenScroll_End

ScreenScroll_End:
    nop
