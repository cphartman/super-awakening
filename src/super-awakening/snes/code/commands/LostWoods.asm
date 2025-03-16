; States
LOSTWOODS_STATE_NONE = 0
LOSTWOODS_START = LOSTWOODS_LOAD_INIT
LOSTWOODS_STOP = LOSTWOODS_SHOW_HIDE

; Sub-States
LOSTWOODS_LOAD_INIT = 1
LOSTWOODS_LOAD_TILES = 2
LOSTWOODS_LOAD_TILEMAP_TOP = 3
LOSTWOODS_LOAD_TILEMAP_BOTTOM = 4
LOSTWOODS_SHOW_UPDATE = 5
LOSTWOODS_SHOW_HIDE = 6
 
LOSTWOODS_SHOW_PALETTE_FRAME_DELAY = 4
LOSTWOODS_SCROLL_DELAY_X = 5
LOSTWOODS_SCROLL_DELAY_Y = 20

seta8

LostWoods:
LostWoods_Init:
   ; Set flags we use
   .i16
   setxy16
   .a8
   seta8

    ; Set rom bank to Super Awakening
    LDA #^SuperAwakeining_Snes_Wram
    PHA
    PLB

LostWoods_StateCheck:
    ; Are we in a state?
    lda LostWoods_State
    cmp #0
    bne LostWoods_StateJump
    
    ; No state
    jml LostWoods_End

LostWoods_StateJump:
    ; Jump to the curernt state
    tax
    lda LostWoods_JumpTable_Low,X
    sta $00  ; Store low byte
    lda LostWoods_JumpTable_High,X
    sta $01  ; Store high byte
    lda LostWoods_JumpTable_Bank,X
    sta $02  ; Store bank byte

    JML [$00]

; Jump table for the states
LostWoods_JumpTable:
LostWoods_JumpTable_Low:
.byte <LostWoods_End
.byte <LostWoods_Load_Init
.byte <LostWoods_Load_Tiles
.byte <LostWoods_Load_TileMap_Top
.byte <LostWoods_Load_TileMap_Bottom
.byte <LostWoods_Update
.byte <LostWoods_Hide
LostWoods_JumpTable_High:
.byte >LostWoods_End
.byte >LostWoods_Load_Init
.byte >LostWoods_Load_Tiles
.byte >LostWoods_Load_TileMap_Top
.byte >LostWoods_Load_TileMap_Bottom
.byte >LostWoods_Update
.byte >LostWoods_Hide
LostWoods_JumpTable_Bank:
.byte ^LostWoods_End
.byte ^LostWoods_Load_Init
.byte ^LostWoods_Load_Tiles
.byte ^LostWoods_Load_TileMap_Top
.byte ^LostWoods_Load_TileMap_Bottom
.byte ^LostWoods_Update
.byte ^LostWoods_Hide

LostWoods_Load:

LostWoods_Load_Init:

    CHUNK_LOAD_INIT fog_tiles, BG_1_TILES, FOG_TILE_CHUNK_COUNT, FOG_TILE_LAST_CHUNK_SIZE

    lda #LOSTWOODS_LOAD_TILES
    sta f:LostWoods_State
    
    jml LostWoods_Load_Tiles

LostWoods_Load_Tiles:
    
    CHUNK_LOAD_EXECUTE LostWoods_End, LostWoods_Load_Tiles_End

LostWoods_Load_Tiles_End:
    CHUNK_LOAD_INIT fog_tilemap, BG_1_TILEMAP, FOG_MAP_CHUNK_COUNT, FOG_MAP_LAST_CHUNK_SIZE
    
    lda #LOSTWOODS_LOAD_TILEMAP_TOP
    sta f:LostWoods_State
    
    jml LostWoods_End

LostWoods_Load_TileMap_Top:
    CHUNK_LOAD_EXECUTE LostWoods_End, LostWoods_Load_TileMap_Top_End

LostWoods_Load_TileMap_Top_End:
    ; I assumed this fix perfectly in the window, but it's overflowing $100 byes to the next tilemanp?
    CHUNK_LOAD_INIT fog_tilemap, BG_1_TILEMAP+$200, FOG_MAP_CHUNK_COUNT, FOG_MAP_LAST_CHUNK_SIZE

    lda #LOSTWOODS_LOAD_TILEMAP_BOTTOM
    sta f:LostWoods_State

    jml LostWoods_End

LostWoods_Load_TileMap_Bottom:
    CHUNK_LOAD_EXECUTE LostWoods_End, LostWoods_Load_TileMap_Bottom_End

LostWoods_Load_TileMap_Bottom_End:
    lda #LOSTWOODS_SHOW_UPDATE
    sta f:LostWoods_State

    DMA_PALETTE fog_palette, $60, $20

    ; Configure BG1+2 to use the correct tile location offset
    lda #%00100001
    sta $210B

    ; Initialize the scroll delay
    lda #LOSTWOODS_SCROLL_DELAY_X
    sta f:LostWoods_ScrollDelay_X
    lda #LOSTWOODS_SCROLL_DELAY_Y
    sta f:LostWoods_ScrollDelay_Y

    jml LostWoods_End

LostWoods_Update:
    WAIT_FOR_VBLANK

LostWoods_Update_WindowScroll:

LostWoods_Update_Scroll_X:

LostWoods_Update_Scroll_X_Delay:
    lda f:LostWoods_ScrollDelay_X
    dec a
    sta f:LostWoods_ScrollDelay_X
    bne LostWoods_Update_Scroll_X_End
LostWoods_Update_Scroll_X_Delay_End:

    .a16
    seta16
    lda f:LostWoods_WindowX
    inc a
    and #%0000001111111111
    sta f:LostWoods_WindowX

    .a8
    seta8
    lda f:LostWoods_WindowX
    sta f:BG1HOFS
    lda f:LostWoods_WindowX+1
    sta f:BG1HOFS

    lda #LOSTWOODS_SCROLL_DELAY_X
    sta f:LostWoods_ScrollDelay_X
    

LostWoods_Update_Scroll_X_End:
    
LostWoods_Update_Scroll_Y:

LostWoods_Update_Scroll_Y_Delay:
    lda f:LostWoods_ScrollDelay_Y
    dec a
    sta f:LostWoods_ScrollDelay_Y
    bne LostWoods_Update_Scroll_Y_End
LostWoods_Update_Scroll_Y_Delay_End:

    .a16
    seta16
    lda f:LostWoods_WindowY
    inc a
    and #%0000001111111111
    sta f:LostWoods_WindowY

    .a8
    seta8
    lda f:LostWoods_WindowY
    sta f:BG1VOFS
    lda f:LostWoods_WindowY+1
    sta f:BG1VOFS

    lda #LOSTWOODS_SCROLL_DELAY_Y
    sta f:LostWoods_ScrollDelay_Y

LostWoods_Update_Scroll_Y_End:

LostWoods_Enable_Fog:
    ; Enable b1 on sub screen
    lda #%00000001
    sta f:$212D

    ; Enable color math
    lda #$02
    sta f:$2130

    ; Enable additive color math layers
    lda #%10100101
    sta f:$2131

    jml LostWoods_End

LostWoods_Hide:
    WAIT_FOR_VBLANK

    ; Disable b1 on sub screen
    lda #%00000000
    sta f:$212D

    lda #LOSTWOODS_STATE_NONE
    sta f:LostWoods_State

    ; Reset Window scroll
    lda #0
    sta f:BG1HOFS
    sta f:BG1HOFS
    sta f:BG1VOFS
    sta f:BG1VOFS
    sta f:LostWoods_WindowX
    sta f:LostWoods_WindowX+1
    sta f:LostWoods_WindowY
    sta f:LostWoods_WindowY+1

    jml LostWoods_End

fog_tiles:
    .incbin "src/super-awakening/snes/gfx/clouds.4bpp"
fog_tilemap:
    .incbin "src/super-awakening/snes/gfx/clouds.map"
fog_palette:
    .byte $94, $52, $31, $46, $6B, $2D, $08, $21, $84, $10, $00, $00

FOG_MAP_SIZE = 1024
FOG_MAP_CHUNK_COUNT = (FOG_MAP_SIZE/CHUNK_SIZE)+1
FOG_MAP_LAST_CHUNK_SIZE = FOG_MAP_SIZE - (FOG_MAP_SIZE/CHUNK_SIZE)*CHUNK_SIZE


FOG_TILE_SIZE = 288
FOG_TILE_CHUNK_COUNT = (FOG_TILE_SIZE/CHUNK_SIZE)+1
FOG_TILE_LAST_CHUNK_SIZE = FOG_TILE_SIZE - (FOG_TILE_SIZE/CHUNK_SIZE)*CHUNK_SIZE


LostWoods_End:
    .a8
    seta8
    nop
