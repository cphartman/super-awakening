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
GAMEPLAYBORDER_LOAD_CRACKED = 10
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
.byte <GameplayBorder_Load_TileMap_Cracked
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
.byte >GameplayBorder_Load_TileMap_Cracked
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
.byte ^GameplayBorder_Load_TileMap_Cracked
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
    lda #GAMEPLAYBORDER_LOAD_CRACKED
    sta f:GameplayBorder_State

    lda #0
    sta f:GameplayBorder_Counter

    jml GameplayBorder_End
    
GameplayBorder_Load_TileMap_Cracked:

GameplayBorder_Load_TileMap_Cracked_SetupChunkLoader:
    seta16
    .a16
    lda #$25A0
    sta f:ChunkLoader_Dest
    seta8
    .a8

    ; Address in the table is index*(3 bytes)
    lda f:GameplayBorder_CrackedIndex
    clc
    adc f:GameplayBorder_CrackedIndex
    adc f:GameplayBorder_CrackedIndex

    ; Copy to index16
    seta16
    .a16
    and #$00FF
    tax
    
    ; Set the src image address in the chunk loader  
    lda f:GameplayBorder_CrackedImages, x
    sta f:ChunkLoader_Src
    
    ; Set src bank
    seta8
    .a8
    lda f:GameplayBorder_CrackedImages+2, x
    sta f:ChunkLoader_Src_Bank
    
    lda #$60
    sta f:ChunkLoader_CurrentChunkSize

GameplayBorder_Load_TileMap_Cracked_SetupChunkLoader_end:

GameplayBorder_Load_TileMap_Cracked_SetChunkRow:


    ; Get Index for the offset/address table
    lda f:GameplayBorder_Counter
    clc
    adc f:GameplayBorder_Counter
    
    seta16
    .a16
    ; Drop top byte
    and #$00FF
    tax

    ; Offset src address
    lda f:ChunkLoader_Src
    clc
    adc f:GameplayBorder_CrackedImages_ChunkLoaderSrcRowOffset,X
    sta f:ChunkLoader_Src

    ; Set dest address
    lda f:GameplayBorder_CrackedImages_ChunkLoaderDestRowAddress,X
    sta f:ChunkLoader_Dest

    seta8
    .a8

GameplayBorder_Load_TileMap_Cracked_SetChunkRow_end:

GameplayBorder_Load_TileMap_Cracked_DoCopy:
    WAIT_FOR_VBLANK
    CHUNK_LOAD_DMA

GameplayBorder_Load_TileMap_Cracked_NextState:
    lda f:GameplayBorder_Counter
    inc a
    sta f:GameplayBorder_Counter

    cmp #03
    beq GameplayBorder_Load_TileMap_Cracked_StartFadeIn
    jml GameplayBorder_End

GameplayBorder_Load_TileMap_Cracked_StartFadeIn:
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
    .incbin "../../gfx/border_gameplay.4bpp"
border_gameplay_tilemap:
    .incbin "../../gfx/border_gameplay.map"

border_system_palette:
    .incbin "../../gfx/border_system.pal"
border_system_tiles:
    .incbin "../../gfx/border_system.4bpp", 0, 2048
border_system_tilemap:
    .incbin "../../gfx/border_system.map"

border_gameplay_cracked_tiles_0:
    .incbin "../../gfx/border-cracked/cracked-0.4bpp"
border_gameplay_cracked_tiles_1:
    .incbin "../../gfx/border-cracked/cracked-1.4bpp"
border_gameplay_cracked_tiles_2:
    .incbin "../../gfx/border-cracked/cracked-2.4bpp"
border_gameplay_cracked_tiles_3:
    .incbin "../../gfx/border-cracked/cracked-3.4bpp"
border_gameplay_cracked_tiles_4:
    .incbin "../../gfx/border-cracked/cracked-4.4bpp"
border_gameplay_cracked_tiles_5:
    .incbin "../../gfx/border-cracked/cracked-5.4bpp"
border_gameplay_cracked_tiles_6:
    .incbin "../../gfx/border-cracked/cracked-6.4bpp"
border_gameplay_cracked_tiles_7:
    .incbin "../../gfx/border-cracked/cracked-7.4bpp"
border_gameplay_cracked_tiles_8:
    .incbin "../../gfx/border-cracked/cracked-8.4bpp"

GameplayBorder_CrackedImages:
GameplayBorder_CrackedImages_0:
    .byte <border_gameplay_cracked_tiles_0
    .byte >border_gameplay_cracked_tiles_0
    .byte ^border_gameplay_cracked_tiles_0
GameplayBorder_CrackedImages_1:
    .byte <border_gameplay_cracked_tiles_1
    .byte >border_gameplay_cracked_tiles_1
    .byte ^border_gameplay_cracked_tiles_1
GameplayBorder_CrackedImages_2:
    .byte <border_gameplay_cracked_tiles_2
    .byte >border_gameplay_cracked_tiles_2
    .byte ^border_gameplay_cracked_tiles_2
GameplayBorder_CrackedImages_3:
    .byte <border_gameplay_cracked_tiles_3
    .byte >border_gameplay_cracked_tiles_3
    .byte ^border_gameplay_cracked_tiles_3
GameplayBorder_CrackedImages_4:
    .byte <border_gameplay_cracked_tiles_4
    .byte >border_gameplay_cracked_tiles_4
    .byte ^border_gameplay_cracked_tiles_4
GameplayBorder_CrackedImages_5:
    .byte <border_gameplay_cracked_tiles_5
    .byte >border_gameplay_cracked_tiles_5
    .byte ^border_gameplay_cracked_tiles_5
GameplayBorder_CrackedImages_6:
    .byte <border_gameplay_cracked_tiles_6
    .byte >border_gameplay_cracked_tiles_6
    .byte ^border_gameplay_cracked_tiles_6
GameplayBorder_CrackedImages_7:
    .byte <border_gameplay_cracked_tiles_7
    .byte >border_gameplay_cracked_tiles_7
    .byte ^border_gameplay_cracked_tiles_7
GameplayBorder_CrackedImages_8:
    .byte <border_gameplay_cracked_tiles_8
    .byte >border_gameplay_cracked_tiles_8
    .byte ^border_gameplay_cracked_tiles_8
    
GameplayBorder_CrackedImages_ChunkLoaderSrcRowOffset:
    .byte $00, $00
    .byte $60, $00
    .byte $C0, $00
GameplayBorder_CrackedImages_ChunkLoaderDestRowAddress:
    .byte $A0, $25
    .byte $30, $26
    .byte $E0, $26

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

