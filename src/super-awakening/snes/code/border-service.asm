seta8

; Border Service will load the tiles, palette, and tilemap into a BG over several frames 
; Set [StartBorderLoad] = 1 to start the process
; TODO: Allow reading from different borders and writing to different BGs

Init:
    ; Backup flags and bank
   PHP
   PHB

   ; Set flags we use
   .i16
   rep #$10        ; X/Y 16-bit
   .a8
   sep #$20        ; A 8-bit

    LDA #^SuperAwakeining_Snes_Wram   ; Load bank byte of foo
    PHA         ; Push it onto the stack
    PLB         ; Pull into DBR (set data bank)

BorderLoad_Check:
    ; Are we trying to load a border?
    lda StartBorderLoad
    cmp #0
    beq BorderLoad_StateCheck
    
BorderLoad_Init:
    ; We are loading a new border
    lda #0
    sta StartBorderLoad
    sta BorderLoadState
    jmp BorderLoad_StateJump

BorderLoad_StateCheck:
    ; Are we currently loading a border?
    lda BorderLoadState
    cmp #0
    bne BorderLoad_StateJump
    
    ; No state
    jmp RETURN

BorderLoad_StateJump:
    ; Jump to the curernt state
    LDX BorderLoadState
    LDA JumpTable_Low,X
    STA $00  ; Store low byte
    LDA JumpTable_High,X
    STA $01  ; Store high byte
    LDA JumpTable_Bank,X
    STA $02  ; Store bank byte

    JML [$00]

; Jump table for the states
 JumpTable_Low:
    .byte <BorderLoad_InitStageTileLoad
    .byte <BorderLoad_StageLoadTiles
    .byte <BorderLoad_StageLoadPalette
    .byte <BorderLoad_LoadTilemap
 JumpTable_High:
    .byte >BorderLoad_InitStageTileLoad
    .byte >BorderLoad_StageLoadTiles
    .byte >BorderLoad_StageLoadPalette
    .byte >BorderLoad_LoadTilemap
 JumpTable_Bank:
    .byte ^BorderLoad_InitStageTileLoad
    .byte ^BorderLoad_StageLoadTiles
    .byte ^BorderLoad_StageLoadPalette
    .byte ^BorderLoad_LoadTilemap

; Handle any setup that should happen once
BorderLoad_InitStageTileLoad:

    LDA #0
    PHA
    PLB

    ; Configure th3 BG to use the correct tile location offset
    lda #0
    sta $210B

    ; Only shown BG1 and BG3 on the main screen
    lda #5
    sta $212C

    LDA #^SuperAwakeining_Snes_Wram   ; Load bank byte of foo
    PHA         ; Push it onto the stack
    PLB         ; Pull into DBR (set data bank)

    CHUNK_LOAD_INIT border_file_menu_tiles, BG_1_TILES, BORDER_FILE_MENU_TILE_CHUNK_COUNT, BORDER_FILE_MENU_TILE_LAST_CHUNK_SIZE
    
    ; Increment the state so we don't init again
    lda #1
    sta BorderLoadState
    ; Fall through to the first state
    
BorderLoad_StageLoadTiles:
    
    CHUNK_LOAD_EXECUTE RETURN, NEXT_STATE_AND_RETURN

BorderLoad_StageLoadPalette:
    WAIT_FOR_VBLANK
    DMA_PALETTE border_file_menu_palette, $40, $20

    CHUNK_LOAD_INIT border_file_menu_tilemap, BG_1_TILEMAP, BORDER_FILE_MENU_MAP_CHUNK_COUNT, BORDER_FILE_MENU_MAP_LAST_CHUNK_SIZE

    jmp NEXT_STATE_AND_RETURN

BorderLoad_LoadTilemap:

    CHUNK_LOAD_EXECUTE RETURN, END_STATE_AND_RETURN

END_STATE_AND_RETURN:
    seta8
    .a8
    lda #0
    sta f:BorderLoadState
    jmp RETURN

NEXT_STATE_AND_RETURN:
    lda f:BorderLoadState
    inc a
    sta f:BorderLoadState

RETURN:
    PLB
    PLP

BG_1_TILES = $0000
BG_1_TILEMAP = $3800


CHUNK_SIZE = $B0

BORDER_FILE_MENU_MAP_SIZE = 1792
BORDER_FILE_MENU_MAP_CHUNK_COUNT = (BORDER_FILE_MENU_MAP_SIZE/CHUNK_SIZE)+1
BORDER_FILE_MENU_MAP_LAST_CHUNK_SIZE = BORDER_FILE_MENU_MAP_SIZE - (BORDER_FILE_MENU_MAP_SIZE/CHUNK_SIZE)*CHUNK_SIZE

BORDER_FILE_MENU_TILE_SIZE = 416
BORDER_FILE_MENU_TILE_CHUNK_COUNT = (BORDER_FILE_MENU_TILE_SIZE/CHUNK_SIZE)+1
BORDER_FILE_MENU_TILE_LAST_CHUNK_SIZE = BORDER_FILE_MENU_TILE_SIZE - (BORDER_FILE_MENU_TILE_SIZE/CHUNK_SIZE)*CHUNK_SIZE