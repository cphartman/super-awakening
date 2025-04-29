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
    .byte <TitleScreenAnimate
    .byte <SendScreenScroll
    .byte <DisableScreenScroll
    .byte <LostWoodsStart
    .byte <LostWoodsStop
    .byte <TitleScreenShow
    .byte <SystemBorderShow
    .byte <GameplayBorderShowCracked
    .byte <GameplayBorderHide
 JumpTable_High:
    .byte >Return
    .byte >FileMenuLoad
    .byte >FileMenuShow
    .byte >GameplayBorderShow
    .byte >TitleScreenLoad
    .byte >TitleScreenAnimate
    .byte >SendScreenScroll
    .byte >DisableScreenScroll
    .byte >LostWoodsStart
    .byte >LostWoodsStop
    .byte >TitleScreenShow
    .byte >SystemBorderShow
    .byte >GameplayBorderShowCracked
    .byte >GameplayBorderHide
 JumpTable_Bank:
    .byte ^Return
    .byte ^FileMenuLoad
    .byte ^FileMenuShow
    .byte ^GameplayBorderShow
    .byte ^TitleScreenLoad
    .byte ^TitleScreenAnimate
    .byte ^SendScreenScroll
    .byte ^DisableScreenScroll
    .byte ^LostWoodsStart
    .byte ^LostWoodsStop
    .byte ^TitleScreenShow
    .byte ^SystemBorderShow
    .byte ^GameplayBorderShowCracked
    .byte ^GameplayBorderHide

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

    lda a:command+1
    sta a:GameplayBorder_CrackedIndex

    lda #0
    sta a:command

    jmp Return

TitleScreenLoad:
    lda #TITLESCREEN_LOAD
    sta a:TitleScreen_State

    lda #0
    sta a:command

    jmp Return

TitleScreenAnimate:
    lda #TITLESCREEN_ANIMATE
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

SendScreenScroll:

    lda #SCREENSCROLL_FOLLOW_LINK
    sta a:ScreenScroll_State

    lda #0
    sta a:command

    jmp Return

DisableScreenScroll:

    lda #SCREENSCROLL_DISABLE
    sta a:ScreenScroll_State

    lda #0
    sta a:command

    jmp Return

LostWoodsStart:

    lda #LOSTWOODS_START
    sta a:LostWoods_State

    lda #0
    sta a:command

    jmp Return

LostWoodsStop:

    lda #LOSTWOODS_STOP
    sta a:LostWoods_State

    lda #0
    sta a:command

    jmp Return

SystemBorderShow:
    lda #SYSTEMBORDER_LOAD
    sta a:GameplayBorder_State

    lda #0
    sta a:command

    jmp Return

GameplayBorderShowCracked:
    lda #GAMEPLAYBORDER_LOAD_CRACKED
    sta a:GameplayBorder_State

    lda #0
    sta a:GameplayBorder_Counter
    sta a:command

    jmp Return

GameplayBorderHide:

    lda #GAMEPLAYBORDER_FADE_OUT
    sta a:GameplayBorder_State

    lda #0
    sta a:GameplayBorder_Counter
    sta a:command

Return:
    PLB
    PLP
    
    

.endscope