GAMEPLAYBORDER_LOAD = GAMEPLAYBORDER_LOAD_PALETTE
SYSTEMBORDER_LOAD = SYSTEMBORDER_LOAD_PALETTE
GAMEPLAYBORDER_FADE_IN = GAMEPLAYBORDER_FADE_IN_1

; States
GAMEPLAYBORDER_STATE_NONE = 0
GAMEPLAYBORDER_LOAD_PALETTE = 1
GAMEPLAYBORDER_LOAD_TILES = 2
GAMEPLAYBORDER_LOAD_TILEMAP = 3
SYSTEMBORDER_LOAD_PALETTE = 4
SYSTEMBORDER_LOAD_TILES = 5
SYSTEMBORDER_LOAD_TILEMAP = 6
GAMEPLAYBORDER_FADE_IN_1 = 7
GAMEPLAYBORDER_FADE_IN_2 = 8
GAMEPLAYBORDER_FADE_IN_3 = 9
seta8

GAMEPLAYBORDER_FADE_IN_DELAY = 4

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
    jmp GameplayBorder_Exit

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
.byte <GameplayBorder_Fade_In_1
.byte <GameplayBorder_Fade_In_2
.byte <GameplayBorder_Fade_In_3
GameplayBorder_JumpTable_High:
.byte >GameplayBorder_End
.byte >GameplayBorder_Load_Palette
.byte >GameplayBorder_Load_Tiles
.byte >GameplayBorder_Load_TileMap
.byte >SystemBorder_Load_Palette
.byte >SystemBorder_Load_Tiles
.byte >SystemBorder_Load_TileMap
.byte >GameplayBorder_Fade_In_1
.byte >GameplayBorder_Fade_In_2
.byte >GameplayBorder_Fade_In_3
GameplayBorder_JumpTable_Bank:
.byte ^GameplayBorder_End
.byte ^GameplayBorder_Load_Palette
.byte ^GameplayBorder_Load_Tiles
.byte ^GameplayBorder_Load_TileMap
.byte ^SystemBorder_Load_Palette
.byte ^SystemBorder_Load_Tiles
.byte ^SystemBorder_Load_TileMap
.byte ^GameplayBorder_Fade_In_1
.byte ^GameplayBorder_Fade_In_2
.byte ^GameplayBorder_Fade_In_3
GameplayBorder_Load_Palette:

    DMA_PALETTE gb_white_palette, $40, $80
    DMA_PALETTE gb_white_palette, $60, $80

    ; DMA_PALETTE border_gameplay_palette, $40, $40

    ; Only show BG 2+3
    lda #$06
    sta f:$212C

    ; Configure BG2 to use the correct tile location offset
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
    lda #GAMEPLAYBORDER_FADE_IN
    sta f:GameplayBorder_State

    lda #0
    sta f:GameplayBorder_Counter

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

GameplayBorder_Fade_In_1:
    lda f:GameplayBorder_Counter
    inc a
    sta f:GameplayBorder_Counter

    DMA_PALETTE border_gameplay_palette_fade_in_1, $40, $80
    
    lda #GAMEPLAYBORDER_FADE_IN_2
    sta f:GameplayBorder_State
    
    jml GameplayBorder_End

GameplayBorder_Fade_In_2:
GameplayBorder_Fade_In_2_delay:
    lda f:GameplayBorder_Counter
    inc a
    sta f:GameplayBorder_Counter

    cmp #GAMEPLAYBORDER_FADE_IN_DELAY
    beq GameplayBorder_Fade_In_2_update
    jml GameplayBorder_End
GameplayBorder_Fade_In_2_update:
    DMA_PALETTE border_gameplay_palette_fade_in_2, $40, $80
    
    lda #GAMEPLAYBORDER_FADE_IN_3
    sta f:GameplayBorder_State
    
    jml GameplayBorder_End

GameplayBorder_Fade_In_3:
GameplayBorder_Fade_In_3_delay:
    lda f:GameplayBorder_Counter
    inc a
    sta f:GameplayBorder_Counter

    cmp #(GAMEPLAYBORDER_FADE_IN_DELAY*2)
    beq GameplayBorder_Fade_In_3_update
    jml GameplayBorder_End
GameplayBorder_Fade_In_3_update:
    DMA_PALETTE border_gameplay_palette, $40, $80
    
    lda #GAMEPLAYBORDER_STATE_NONE
    sta f:GameplayBorder_State
    
    jml GameplayBorder_End

gb_white_palette:
    .incbin "../../gfx/gb_white.pal"
border_gameplay_palette_fade_in_1:
    .incbin "../../gfx/border_gameplay_fade_in_2.pal"
border_gameplay_palette_fade_in_2:
    .incbin "../../gfx/border_gameplay_fade_in_2.pal"

border_gameplay_palette:
    .incbin "../..//gfx/border_gameplay.pal"
border_gameplay_tiles:
    .incbin "../..//gfx/border_gameplay.4bpp"
border_gameplay_tilemap:
    .incbin "../..//gfx/border_gameplay.map"

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
    jml INJECTION_EXIT

GameplayBorder_Exit:
    nop
