; States
FILEMENU_STATE_NONE = 0
FILEMENU_LOAD = FILEMENU_LOAD_BLANKPALETTE
FILEMENU_SHOW = FILEMENU_SHOW_PALETTE

; Sub-States
FILEMENU_LOAD_BLANKPALETTE = 1
FILEMENU_LOAD_TILES = 2
FILEMENU_LOAD_TILEMAP = 3
FILEMENU_SHOW_PALETTE = 4

FILEMENU_SHOW_PALETTE_FRAME_DELAY = 4

seta8

FileMenu:
FileMenu_Init:
   ; Set flags we use
   .i16
   setxy16
   .a8
   seta8

    ; Set rom bank to Super Awakening
    LDA #^SuperAwakeining_Snes_Wram
    PHA
    PLB

FileMenu_StateCheck:
    ; Are we in a state?
    lda FileMenu_State
    cmp #0
    bne FileMenu_StateJump
    
    ; No state
    jmp FileMenu_End

FileMenu_StateJump:
    ; Jump to the curernt state
    tax
    lda FileMenu_JumpTable_Low,X
    sta $00  ; Store low byte
    lda FileMenu_JumpTable_High,X
    sta $01  ; Store high byte
    lda FileMenu_JumpTable_Bank,X
    sta $02  ; Store bank byte

    JML [$00]

; Jump table for the states
FileMenu_JumpTable:
FileMenu_JumpTable_Low:
.byte <FileMenu_End
.byte <FileMenu_Load_BlankPalette
.byte <FileMenu_Load_Tiles
.byte <FileMenu_Load_TileMap
.byte <FileMenu_Show_Palette
FileMenu_JumpTable_High:
.byte >FileMenu_End
.byte >FileMenu_Load_BlankPalette
.byte >FileMenu_Load_Tiles
.byte >FileMenu_Load_TileMap
.byte >FileMenu_Show_Palette
FileMenu_JumpTable_Bank:
.byte ^FileMenu_End
.byte ^FileMenu_Load_BlankPalette
.byte ^FileMenu_Load_Tiles
.byte ^FileMenu_Load_TileMap
.byte ^FileMenu_Show_Palette

FileMenu_Load:

FileMenu_Load_BlankPalette:
    DMA_PALETTE FileMenu_Palette_Blank, $40, $40
    
    ; Only show BG 3
    lda #$04
    sta $212C

    ; Configure BG1 to use the correct tile location offset
    lda #1
    sta $210B

    CHUNK_LOAD_INIT border_file_menu_tiles, BG_1_TILES, BORDER_FILE_MENU_TILE_CHUNK_COUNT, BORDER_FILE_MENU_TILE_LAST_CHUNK_SIZE

    lda #FILEMENU_LOAD_TILES
    sta f:FileMenu_State
    
    jml FileMenu_End

FileMenu_Load_Tiles:
    CHUNK_LOAD_EXECUTE FileMenu_End, FileMenu_Load_Tiles_End

FileMenu_Load_Tiles_End:
    CHUNK_LOAD_INIT border_file_menu_tilemap, BG_1_TILEMAP, BORDER_FILE_MENU_MAP_CHUNK_COUNT, BORDER_FILE_MENU_MAP_LAST_CHUNK_SIZE
    
    lda #FILEMENU_LOAD_TILEMAP
    sta f:FileMenu_State
    
    jml FileMenu_End

FileMenu_Load_TileMap:
    CHUNK_LOAD_EXECUTE FileMenu_End, FileMenu_Load_TileMap_End

FileMenu_Load_TileMap_End:
    lda #FILEMENU_STATE_NONE
    sta f:FileMenu_State

    jml FileMenu_End

FileMenu_Show_Palette:

FileMenu_Show_Palette_CheckFrameSkip:
    lda f:FileMenu_Counter
    dec a
    sta f:FileMenu_Counter
    cmp #0
    beq FileMenu_Show_Palette_CheckFrameSkip_end
    jml FileMenu_End
FileMenu_Show_Palette_CheckFrameSkip_end:

    DMA_PALETTE border_file_menu_palette, $60, $40

    ; Show BG 1 and 3
    lda #$05
    sta $212C

    lda #FILEMENU_STATE_NONE
    sta f:FileMenu_State

    jml FileMenu_End

FileMenu_Palette_Blank: 
   .byte $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B
   .byte $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B

border_file_menu_tiles:
.incbin "src/super-awakening/snes/gfx/border_file_menu.4bpp"
border_file_menu_tilemap:
.incbin "src/super-awakening/snes/gfx/border_file_menu.map"
border_file_menu_palette:
.incbin "src/super-awakening/snes/gfx/border_file_menu.pal"

CHUNK_SIZE = $A0
BG_1_TILES = $1000
BG_1_TILEMAP = $3800
BG_2_TILES = $2000
BG_2_TILEMAP = $3C00

BORDER_FILE_MENU_MAP_SIZE = 1792
BORDER_FILE_MENU_MAP_CHUNK_COUNT = (BORDER_FILE_MENU_MAP_SIZE/CHUNK_SIZE)+1
BORDER_FILE_MENU_MAP_LAST_CHUNK_SIZE = BORDER_FILE_MENU_MAP_SIZE - (BORDER_FILE_MENU_MAP_SIZE/CHUNK_SIZE)*CHUNK_SIZE

BORDER_FILE_MENU_TILE_SIZE = 416
BORDER_FILE_MENU_TILE_CHUNK_COUNT = (BORDER_FILE_MENU_TILE_SIZE/CHUNK_SIZE)+1
BORDER_FILE_MENU_TILE_LAST_CHUNK_SIZE = BORDER_FILE_MENU_TILE_SIZE - (BORDER_FILE_MENU_TILE_SIZE/CHUNK_SIZE)*CHUNK_SIZE


FileMenu_End:
    nop
