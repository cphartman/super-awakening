; States
TITLESCREEN_STATE_NONE = 0
TITLESCREEN_LOAD = TITLESCREEN_LOAD_BLANKPALETTE
TITLESCREEN_SHOW = TITLESCREEN_SHOW_PALETTE

; Sub-States
TITLESCREEN_LOAD_BLANKPALETTE = 1
TITLESCREEN_LOAD_TILES = 2
TITLESCREEN_LOAD_TILEMAP = 3
TITLESCREEN_SHOW_PALETTE = 4
 
TITLESCREEN_SHOW_PALETTE_FRAME_DELAY = 4

seta8

TitleScreen:
TitleScreen_Init:
   ; Set flags we use
   .i16
   setxy16
   .a8
   seta8

    ; Set rom bank to Super Awakening
    LDA #^SuperAwakeining_Snes_Wram
    PHA
    PLB

TitleScreen_StateCheck:
    ; Are we in a state?
    lda TitleScreen_State
    cmp #0
    bne TitleScreen_StateJump
    
    ; No state
    jml TitleScreen_End

TitleScreen_StateJump:
    ; Jump to the curernt state
    tax
    lda TitleScreen_JumpTable_Low,X
    sta $00  ; Store low byte
    lda TitleScreen_JumpTable_High,X
    sta $01  ; Store high byte
    lda TitleScreen_JumpTable_Bank,X
    sta $02  ; Store bank byte

    JML [$00]

; Jump table for the states
TitleScreen_JumpTable:
TitleScreen_JumpTable_Low:
.byte <TitleScreen_End
.byte <TitleScreen_Load_BlankPalette
.byte <TitleScreen_Load_Tiles
.byte <TitleScreen_Load_TileMap
.byte <TitleScreen_Show_Palette
TitleScreen_JumpTable_High:
.byte >TitleScreen_End
.byte >TitleScreen_Load_BlankPalette
.byte >TitleScreen_Load_Tiles
.byte >TitleScreen_Load_TileMap
.byte >TitleScreen_Show_Palette
TitleScreen_JumpTable_Bank:
.byte ^TitleScreen_End
.byte ^TitleScreen_Load_BlankPalette
.byte ^TitleScreen_Load_Tiles
.byte ^TitleScreen_Load_TileMap
.byte ^TitleScreen_Show_Palette

TitleScreen_Load:

TitleScreen_Load_BlankPalette:
    DMA_PALETTE border_title_palette, $40, $40

    ; BG 3
    lda #$04
    sta f:$212C

    ; Configure BG1 to use the correct tile location offset
    lda #1
    sta f:$210B

    CHUNK_LOAD_INIT border_title_tiles, BG_1_TILES, BORDER_TITLE_TILE_CHUNK_COUNT, BORDER_TITLE_TILE_LAST_CHUNK_SIZE

    lda #TITLESCREEN_LOAD_TILES
    sta f:TitleScreen_State
    
    jml TitleScreen_End

TitleScreen_Load_Tiles:
    CHUNK_LOAD_EXECUTE TitleScreen_End, TitleScreen_Load_Tiles_End

TitleScreen_Load_Tiles_End:
    CHUNK_LOAD_INIT border_title_tilemap, BG_1_TILEMAP, BORDER_TITLE_MAP_CHUNK_COUNT, BORDER_TITLE_MAP_LAST_CHUNK_SIZE
    
    lda #TITLESCREEN_LOAD_TILEMAP
    sta f:TitleScreen_State
    
    jml TitleScreen_End

TitleScreen_Load_TileMap:
    CHUNK_LOAD_EXECUTE TitleScreen_End, TitleScreen_Load_TileMap_End

TitleScreen_Load_TileMap_End:
    lda #TITLESCREEN_STATE_NONE
    sta f:TitleScreen_State

    jml TitleScreen_End

TitleScreen_Show_Palette:

TitleScreen_Show_Palette_CheckFrameSkip:
    ;lda f:TitleScreen_Counter
    ;dec a
    ;sta f:TitleScreen_Counter
    ;cmp #0
    ;beq TitleScreen_Show_Palette_CheckFrameSkip_end
    ;jml TitleScreen_End
TitleScreen_Show_Palette_CheckFrameSkip_end:

    DMA_PALETTE border_title_palette, $40, $40

    ; Show BG 1 and 3
    lda #$05
    sta $212C

    lda #TITLESCREEN_STATE_NONE
    sta f:TitleScreen_State

    jml TitleScreen_End

border_title_tiles:
    .incbin "src/super-awakening/snes/gfx/border_title.4bpp"
border_title_tilemap:
    .incbin "src/super-awakening/snes/gfx/border_title.map"
border_title_palette:
    .incbin "src/super-awakening/snes/gfx/border_title.pal"


BORDER_TITLE_MAP_SIZE = 1792
BORDER_TITLE_MAP_CHUNK_COUNT = (BORDER_TITLE_MAP_SIZE/CHUNK_SIZE)+1
BORDER_TITLE_MAP_LAST_CHUNK_SIZE = BORDER_TITLE_MAP_SIZE - (BORDER_TITLE_MAP_SIZE/CHUNK_SIZE)*CHUNK_SIZE

BORDER_TITLE_TILE_SIZE = 448
BORDER_TITLE_TILE_CHUNK_COUNT = (BORDER_TITLE_TILE_SIZE/CHUNK_SIZE)+1
BORDER_TITLE_TILE_LAST_CHUNK_SIZE = BORDER_TITLE_TILE_SIZE - (BORDER_TITLE_TILE_SIZE/CHUNK_SIZE)*CHUNK_SIZE


TitleScreen_End:
    .a8
    seta8
    nop
