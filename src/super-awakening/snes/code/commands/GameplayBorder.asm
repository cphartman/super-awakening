; States
GAMEPLAYBORDER_STATE_NONE = 0
GAMEPLAYBORDER_LOAD = 1
;FILEMENU_SHOW = FILEMENU_SHOW_PALETTE

; Sub-States
;FILEMENU_LOAD_BLANKPALETTE = 1
;FILEMENU_LOAD_TILES = 2
;FILEMENU_LOAD_TILEMAP = 3
;FILEMENU_SHOW_PALETTE = 4

;FILEMENU_SHOW_PALETTE_FRAME_DELAY = 4

seta8

GameplayBorder:
GameplayBorder_Init:
   ; Set flags we use
   .i16
   setxy16
   .a8
   seta8

    ; Set rom bank to Super Awakening
    LDA #^SuperAwakeining_Snes_Wram
    PHA
    PLB

GameplayBorder_StateCheck:
    ; Are we in a state?
    lda GameplayBorder_State
    cmp #0
    bne GameplayBorder_StateJump
    
    ; No state
    jmp GameplayBorder_End

GameplayBorder_StateJump:
    ; Jump to the curernt state
    tax
    lda GameplayBorder_JumpTable_Low,X
    sta $00  ; Store low byte
    lda GameplayBorder_JumpTable_High,X
    sta $01  ; Store high byte
    lda GameplayBorder_JumpTable_Bank,X
    sta $02  ; Store bank byte

    JML [$00]

; Jump table for the states
GameplayBorder_JumpTable:
GameplayBorder_JumpTable_Low:
.byte <FileMenu_End
.byte <GameplayBorder_Load
GameplayBorder_JumpTable_High:
.byte >FileMenu_End
.byte >GameplayBorder_Load
GameplayBorder_JumpTable_Bank:
.byte ^FileMenu_End
.byte ^GameplayBorder_Load

GameplayBorder_Load:

    DMA_PALETTE border_gameplay_palette, $40, $40

    ; Only show BG 2+3
    lda #$06
    sta f:$212C

    lda #GAMEPLAYBORDER_STATE_NONE
    sta f:GameplayBorder_State

    jml GameplayBorder_End

border_gameplay_palette:
    .include "../..//gfx/border_gameplay.pal.asm"

GameplayBorder_End:
    nop
