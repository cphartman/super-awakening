.scope
; Command Service recieved data from the GB to set up appropriate services

COMMAND_FILE_MENU_START = 1

PALETTE_STATE_HIDE_BORDER = 4
PALETTE_STATE_SHOW_GB_BORDER = 1

Init:
    ; Backup flags and bank
   PHP
   PHB

   ; Set flags we use
   .i16
   rep #$10        ; X/Y 16-bit
   .a8
   sep #$20        ; A 8-bit

    LDA #^SuperAwakeining_Snes_Wram 
    PHA
    PLB

FetchCommand:
    lda command
    bne CommandJump
    jmp Return

CommandJump:
    
    tax
    LDA JumpTable_Low,X
    STA $00  ; Store low byte
    LDA JumpTable_High,X
    STA $01  ; Store high byte
    LDA JumpTable_Bank,X
    STA $02  ; Store bank byte

    JML [$00]

; Jump table for the states
 JumpTable_Low:
    .byte <Return
    .byte <FileMenuLoad
    .byte <FileMenuShow
 JumpTable_High:
    .byte >Return
    .byte >FileMenuLoad
    .byte >FileMenuShow
 JumpTable_Bank:
    .byte ^Return
    .byte ^FileMenuLoad
    .byte ^FileMenuShow

FileMenuLoad:
    lda #PALETTE_STATE_HIDE_BORDER
    sta a:PaletteService_State

    lda #0
    sta a:command

    jmp Return

FileMenuShow:
    lda #PALETTE_STATE_SHOW_GB_BORDER
    sta a:PaletteService_State

    lda #0
    sta a:command

    jmp Return

Return:
    PLB
    PLP
    
    

.endscope