GAMEPLAYBORDER_LOAD = GAMEPLAYBORDER_LOAD_PALETTE
SYSTEMBORDER_LOAD = SYSTEMBORDER_LOAD_PALETTE

; States
GAMEPLAYBORDER_STATE_NONE = 0
GAMEPLAYBORDER_LOAD_PALETTE = 1
GAMEPLAYBORDER_LOAD_TILES = 2
GAMEPLAYBORDER_LOAD_TILEMAP = 3
SYSTEMBORDER_LOAD_PALETTE = 4
SYSTEMBORDER_LOAD_TILES = 5
SYSTEMBORDER_LOAD_TILEMAP = 6
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
.byte <GameplayBorder_End
.byte <GameplayBorder_Load_Palette
.byte <GameplayBorder_Load_Tiles
.byte <GameplayBorder_Load_TileMap
.byte <SystemBorder_Load_Palette
.byte <SystemBorder_Load_Tiles
.byte <SystemBorder_Load_TileMap
GameplayBorder_JumpTable_High:
.byte >GameplayBorder_End
.byte >GameplayBorder_Load_Palette
.byte >GameplayBorder_Load_Tiles
.byte >GameplayBorder_Load_TileMap
.byte >SystemBorder_Load_Palette
.byte >SystemBorder_Load_Tiles
.byte >SystemBorder_Load_TileMap
GameplayBorder_JumpTable_Bank:
.byte ^GameplayBorder_End
.byte ^GameplayBorder_Load_Palette
.byte ^GameplayBorder_Load_Tiles
.byte ^GameplayBorder_Load_TileMap
.byte ^SystemBorder_Load_Palette
.byte ^SystemBorder_Load_Tiles
.byte ^SystemBorder_Load_TileMap

GameplayBorder_Load_Palette:

    DMA_PALETTE border_gameplay_palette, $40, $40

    ; Only show BG 2+3
    lda #$06
    sta f:$212C

    ; Configure BG1 to use the correct tile location offset
    lda #%00100000
    sta $210B

    CHUNK_LOAD_INIT border_gameplay_tiles, BG_2_TILES, BORDER_TILE_CHUNK_COUNT, BORDER_TILE_LAST_CHUNK_SIZE

    lda #GAMEPLAYBORDER_LOAD_TILES
    sta f:GameplayBorder_State
    
    jml GameplayBorder_End

GameplayBorder_Load_Tiles:
    CHUNK_LOAD_EXECUTE GameplayBorder_End, GameplayBorder_Load_Tiles_End

GameplayBorder_Load_Tiles_End:
    CHUNK_LOAD_INIT border_gameplay_tilemap, BG_2_TILEMAP, BORDER_MAP_CHUNK_COUNT, BORDER_MAP_LAST_CHUNK_SIZE
    
    lda #GAMEPLAYBORDER_LOAD_TILEMAP
    sta f:GameplayBorder_State
    
    jml GameplayBorder_End

GameplayBorder_Load_TileMap:
    CHUNK_LOAD_EXECUTE GameplayBorder_End, GameplayBorder_Load_TileMap_End

GameplayBorder_Load_TileMap_End:
    lda #GAMEPLAYBORDER_STATE_NONE
    sta f:GameplayBorder_State

    jml GameplayBorder_End

SystemBorder_Load_Palette:

    DMA_PALETTE border_system_palette, $40, $80

    ; Configure BG2 to use the correct tile location offset
    LDA #%00100000
    STA f:$210B

    CHUNK_LOAD_INIT border_system_tiles, BG_2_TILES, SYSTEM_TILE_CHUNK_COUNT, SYSTEM_TILE_LAST_CHUNK_SIZE

    lda #SYSTEMBORDER_LOAD_TILES
    sta f:GameplayBorder_State
    
    jml GameplayBorder_End

SystemBorder_Load_Tiles:
    CHUNK_LOAD_EXECUTE GameplayBorder_End, SystemBorder_Load_Tiles_End

SystemBorder_Load_Tiles_End:
    CHUNK_LOAD_INIT border_system_tilemap, BG_2_TILEMAP, SYSTEM_MAP_CHUNK_COUNT, SYSTEM_MAP_LAST_CHUNK_SIZE
    
    lda #SYSTEMBORDER_LOAD_TILEMAP
    sta f:GameplayBorder_State
    
    jml GameplayBorder_End

SystemBorder_Load_TileMap:
    CHUNK_LOAD_EXECUTE GameplayBorder_End, SystemBorder_Load_TileMap_End

SystemBorder_Load_TileMap_End:
    lda #GAMEPLAYBORDER_STATE_NONE
    sta f:GameplayBorder_State

    jml GameplayBorder_End

border_gameplay_palette:
    .include "../..//gfx/border_gameplay.pal.asm"
border_gameplay_tiles:
    .include "../..//gfx/border_gameplay.4bpp.asm"
border_gameplay_tilemap:
    .include "../..//gfx/border_gameplay.map.asm"

border_system_palette:
    .incbin "../../gfx/border_system.pal"
border_system_tiles:
    .incbin "../../gfx/border_system.4bpp", 0, 2048
border_system_tilemap:
    .incbin "../../gfx/border_system.map"

SYSTEM_TILE_SIZE = 2048
SYSTEM_TILE_CHUNK_COUNT = (SYSTEM_TILE_SIZE/CHUNK_SIZE)+1
SYSTEM_TILE_LAST_CHUNK_SIZE = SYSTEM_TILE_SIZE - (SYSTEM_TILE_SIZE/CHUNK_SIZE)*CHUNK_SIZE

SYSTEM_MAP_SIZE = 1792
SYSTEM_MAP_CHUNK_COUNT = (SYSTEM_MAP_SIZE/CHUNK_SIZE)+1
SYSTEM_MAP_LAST_CHUNK_SIZE = SYSTEM_MAP_SIZE - (SYSTEM_MAP_SIZE/CHUNK_SIZE)*CHUNK_SIZE


BORDER_MAP_SIZE = (8*256)
BORDER_MAP_CHUNK_COUNT = (BORDER_MAP_SIZE/CHUNK_SIZE)+1
BORDER_MAP_LAST_CHUNK_SIZE = BORDER_MAP_SIZE - (BORDER_MAP_SIZE/CHUNK_SIZE)*CHUNK_SIZE

BORDER_TILE_SIZE = (8*1024)
BORDER_TILE_CHUNK_COUNT = (BORDER_TILE_SIZE/CHUNK_SIZE)+1
BORDER_TILE_LAST_CHUNK_SIZE = BORDER_TILE_SIZE - (BORDER_TILE_SIZE/CHUNK_SIZE)*CHUNK_SIZE

GameplayBorder_End:
    nop
