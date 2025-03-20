; SGB injection payload

; ----------------------------------
; Copied from code/super_gameboy.asm
; ----------------------------------
SuperAwakening_copy_SendUploadCommand::
    ld   a, [hl]                                  ; $6B51: $7E
    and  %00000111                                ; $6B52: $E6 $07
    ret  z                                        ; $6B54: $C8
    ld   b, a                                     ; $6B55: $47
    ld   c, $00                                   ; $6B56: $0E $00
.func_03C_6B58
    push bc                                       ; $6B58: $C5
    xor  a                                        ; $6B59: $AF
    ld   [$ff00+c], a                             ; $6B5A: $E2
    ld   a, $30                                   ; $6B5B: $3E $30
    ld   [$ff00+c], a                             ; $6B5D: $E2
    ld   b, $10                                   ; $6B5E: $06 $10
.loop_6B60_3C
    ld   e, $08                                   ; $6B60: $1E $08
    ldi  a, [hl]                                  ; $6B62: $2A
    ld   d, a                                     ; $6B63: $57
.loop_6B64_3C
    bit  0, d                                     ; $6B64: $CB $42
    ld   a, $10                                   ; $6B66: $3E $10
    jr   nz, .else_6B6C_3C                        ; $6B68: $20 $02
    ld   a, $20                                   ; $6B6A: $3E $20
.else_6B6C_3C
    ld   [$ff00+c], a                             ; $6B6C: $E2
    ld   a, $30                                   ; $6B6D: $3E $30
    ld   [$ff00+c], a                             ; $6B6F: $E2
    rr   d                                        ; $6B70: $CB $1A
    dec  e                                        ; $6B72: $1D
    jr   nz, .loop_6B64_3C                        ; $6B73: $20 $EF
    dec  b                                        ; $6B75: $05
    jr   nz, .loop_6B60_3C                        ; $6B76: $20 $E8
    ld   a, $20                                   ; $6B78: $3E $20
    ld   [$ff00+c], a                             ; $6B7A: $E2
    ld   a, $30                                   ; $6B7B: $3E $30
    ld   [$ff00+c], a                             ; $6B7D: $E2
    pop  bc                                       ; $6B7E: $C1
    dec  b                                        ; $6B7F: $05
    ret  z                                        ; $6B80: $C8
    call SuperAwakening_copy_WaitFor3Frames                           ; $6B81: $CD $86 $6B
    jr   .func_03C_6B58                           ; $6B84: $18 $D2

SuperAwakening_copy_WaitFor3Frames::
    ld   de, $1B58                                ; $6B86: $11 $58 $1B
.loop_6B89_3C
    nop                                           ; $6B89: $00
    nop                                           ; $6B8A: $00
    nop                                           ; $6B8B: $00
    dec  de                                       ; $6B8C: $1B
    ld   a, d                                     ; $6B8D: $7A
    or   e                                        ; $6B8E: $B3
    jr   nz, .loop_6B89_3C                        ; $6B8F: $20 $F8
    ret                                           ; $6B91: $C9

; Busy-loop the duration required for the number of
; frames in BC.
;
; Inputs:
;  - bc:   the number of frames to wait for
SuperAwakening_copy_WaitForBCFrames::
    ; Inner loop: wait for one frame.
    ;
    ; As the LCD screen is off, we can't use VBlank for timing.
    ; Instead, as we know the number of cycles per frame is 69905,
    ; let's way for approximately this number of cycles.

    ld   de, $6D6                                 ; $6B92: $11 $D6 $06
    ; Loop while (de-- != 0)
.whileDE
    ; (the instructions in this loop take 36 clock cycles)
    nop                                           ; $6B95: $00
    nop                                           ; $6B96: $00
    nop                                           ; $6B97: $00
    dec  de                                       ; $6B98: $1B
    ld   a, d                                     ; $6B99: $7A
    or   e                                        ; $6B9A: $B3
    jr   nz, .whileDE                             ; $6B9B: $20 $F8

    ; Repeat the inner loop while the number of frames is > 0
    dec  bc                                       ; $6B9D: $0B
    ld   a, b                                     ; $6B9E: $78
    or   c                                        ; $6B9F: $B1
    jr   nz, SuperAwakening_copy_WaitForBCFrames                      ; $6BA0: $20 $F0
    ret                                           ; $6BA2: $C9

; Copy some data to VRAM, then send an SGB command to transfer
; the VRAM content to the SGB memory.
; Inputs:
;   hl   data origin address
;   de   addess of the SGB command to send
SuperAwakening_copy_SendVRAMCommand::
    push de                                       ; $6BA3: $D5
    ld   a, $E4                                   ; $6BA4: $3E $E4
    ld   [rBGP], a                                ; $6BA6: $E0 $47
    ld   de, $8800                                ; $6BA8: $11 $00 $88
    ld   bc, $1000                                ; $6BAB: $01 $00 $10
    call CopyData                                 ; $6BAE: $CD $14 $29
    ld   hl, vBGMap0                              ; $6BB1: $21 $00 $98
    ld   de, $0C                                  ; $6BB4: $11 $0C $00
    ld   a, $80                                   ; $6BB7: $3E $80
    ld   c, $0D                                   ; $6BB9: $0E $0D
.loop_6BBB_3C
    ld   b, $14                                   ; $6BBB: $06 $14
.loop_6BBD_3C
    ldi  [hl], a                                  ; $6BBD: $22
    inc  a                                        ; $6BBE: $3C
    dec  b                                        ; $6BBF: $05
    jr   nz, .loop_6BBD_3C                        ; $6BC0: $20 $FB
    add  hl, de                                   ; $6BC2: $19
    dec  c                                        ; $6BC3: $0D
    jr   nz, .loop_6BBB_3C                        ; $6BC4: $20 $F5
    ld   a, LCDCF_ON | LCDCF_BGON                 ; $6BC6: $3E $81
    ld   [rLCDC], a                               ; $6BC8: $E0 $40
    ld   bc, $05                                  ; $6BCA: $01 $05 $00
    call SuperAwakening_copy_WaitForBCFrames                          ; $6BCD: $CD $92 $6B
    pop  hl                                       ; $6BD0: $E1
    call SuperAwakening_copy_SendUploadCommand                        ; $6BD1: $CD $51 $6B
    ld   bc, $06                                  ; $6BD4: $01 $06 $00
    call SuperAwakening_copy_WaitForBCFrames                          ; $6BD7: $CD $92 $6B
    xor  a                                        ; $6BDA: $AF
    ld   [rLCDC], a                               ; $6BDB: $E0 $40
    ret                                           ; $6BDD: $C9

SuperAwakening_InitPacket:
    ld a, $79
    ld [wSuperAwakening.SGB_PacketCommand], a
    ld a, $03
    ld [wSuperAwakening.SGB_PacketDest_Low], a
    ld a, $00
    ld [wSuperAwakening.SGB_PacketDest_High], a
    ld a, $7F
    ld [wSuperAwakening.SGB_PacketDest_Bank], a
    ld a, 11
    ld [wSuperAwakening.SGB_PacketLength], a
    
    ld a, $F
    ld [wSuperAwakening.SGB_PacketData], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+1], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+2], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+3], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+4], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+5], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+6], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+7], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+8], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+9], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+10], a
    inc a
    ld [wSuperAwakening.SGB_PacketData+11], a

    ret

SuperAwakening_SGB_FileMenuLoad:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $01
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_FileMenuShow:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $02
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_GameplayBoder_Show:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $03
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_TitleScreen_Load:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $04
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_TitleScreen_Show:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, 10
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_TitleScreen_Animate:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $05
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_SendScreenScroll:
    call SuperAwakening_InitPacket
    
    ld a, 3
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $06
    ld [wSuperAwakening.SGB_PacketData], a

    ld a, [hLinkPositionY]
    ld [wSuperAwakening.SGB_PacketData+1], a

    ld a, [hLinkPositionX]
    ld [wSuperAwakening.SGB_PacketData+2], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ret

SuperAwakening_SGB_DisableScreenScroll:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $07
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ret

SuperAwakening_SGB_LostWoodsStart:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $08
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ret

SuperAwakening_SGB_LostWoodsStop:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $09
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ret

SuperAwakening_SGB_SystemBorderLoad:
    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, 11
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_LostWoods_InventoryStart:
    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 1
    jp nz, .return

    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $09
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

.return
    ld a, $20
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_LostWoods_InventoryEnd:
    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 1
    jp nz, .return

    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $08
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

.return
    ld a, $20
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_LostWoods_Death:
    ldh  a, [hLinkCountdown]
    cp $A0
    jp nz, .return

    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 1
    jp nz, .return

    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $09
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

.return
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank


SuperAwakening_SGB_LostWoods_SaveStart:

    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 1
    jp nz, .return

    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $09
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

.return
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_LostWoods_SaveEnd:
    ld a, [wTransitionSequenceCounter]
    cp 0
    jp nz, .return

    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 1
    jp nz, .return

    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $08
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

.return
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_LostWoods_MapStart:

    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 1
    jp nz, .return

    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $09
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

.return
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

SuperAwakening_SGB_LostWoods_MapEnd:
    ld a, [wTransitionSequenceCounter]
    cp 0
    jp nz, .return

    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 1
    jp nz, .return

    call SuperAwakening_InitPacket
    
    ld a, 1
    ld [wSuperAwakening.SGB_PacketLength], a

    ld a, $08
    ld [wSuperAwakening.SGB_PacketData], a

    ld hl, wSuperAwakening.SGB_Packet
    call SuperAwakening_copy_SendUploadCommand

.return
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank