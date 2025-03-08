.scope
; Command Service recieved data from the GB to set up appropriate services

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
    .byte <GameplayBorderShow
    .byte <TitleScreenLoad
    .byte <TitleScreenShow
 JumpTable_High:
    .byte >Return
    .byte >FileMenuLoad
    .byte >FileMenuShow
    .byte >GameplayBorderShow
    .byte >TitleScreenLoad
    .byte >TitleScreenShow
 JumpTable_Bank:
    .byte ^Return
    .byte ^FileMenuLoad
    .byte ^FileMenuShow
    .byte ^GameplayBorderShow
    .byte ^TitleScreenLoad
    .byte ^TitleScreenShow

FileMenuLoad:
    lda #FILEMENU_LOAD
    sta a:FileMenu_State

    lda #0
    sta a:command

    jmp Return

FileMenuShow:
    lda #FILEMENU_SHOW
    sta a:FileMenu_State

    ; Setup the counter to skip the first frame of Show_Palette
    lda #FILEMENU_SHOW_PALETTE_FRAME_DELAY
    sta f:FileMenu_Counter

    lda #0
    sta a:command

    jmp Return

GameplayBorderShow:
    lda #GAMEPLAYBORDER_LOAD
    sta a:GameplayBorder_State

    lda #0
    sta a:command

    jmp Return

TitleScreenLoad:
    lda #TITLESCREEN_LOAD
    sta a:TitleScreen_State

    lda #0
    sta a:command

    jmp Return

TitleScreenShow:
    lda #TITLESCREEN_SHOW
    sta a:TitleScreen_State

    lda #0
    sta a:command

    jmp Return


Return:
    PLB
    PLP
    
    

.endscope