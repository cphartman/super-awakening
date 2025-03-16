; States
TITLESCREEN_STATE_NONE = 0
TITLESCREEN_LOAD = TITLESCREEN_LOAD_BLANKPALETTE
TITLESCREEN_ANIMATE = TITLESCREEN_ANIMATE_INIT
TITLESCREEN_SHOW = TITLESCREEN_ANIMATE_SHOW

; Sub-States
TITLESCREEN_LOAD_BLANKPALETTE = 1
TITLESCREEN_LOAD_TILES = 2
TITLESCREEN_LOAD_TILEMAP = 3
TITLESCREEN_SHOW_PALETTE = 4
TITLESCREEN_ANIMATE_INIT = 5
TITLESCREEN_ANIMATE_UPDATE = 6
TITLESCREEN_ANIMATE_SHOW = 7
 
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
    lda f:TitleScreen_State
    cmp #0
    bne TitleScreen_StateJump
    
    ; No state
    jml TitleScreen_End

TitleScreen_StateJump:
    .a16
    seta16
    AND #$00FF
    .a8
    seta8

    ; Jump to the curernt state
    tax
    lda f:TitleScreen_JumpTable_Low,X
    sta $00  ; Store low byte
    lda f:TitleScreen_JumpTable_High,X
    sta $01  ; Store high byte
    lda f:TitleScreen_JumpTable_Bank,X
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
.byte <TitleScreen_Animate_Init
.byte <TitleScreen_Animate_Update
.byte <TitleScreen_Animate_Show
TitleScreen_JumpTable_High:
.byte >TitleScreen_End
.byte >TitleScreen_Load_BlankPalette
.byte >TitleScreen_Load_Tiles
.byte >TitleScreen_Load_TileMap
.byte >TitleScreen_Show_Palette
.byte >TitleScreen_Animate_Init
.byte >TitleScreen_Animate_Update
.byte >TitleScreen_Animate_Show
TitleScreen_JumpTable_Bank:
.byte ^TitleScreen_End
.byte ^TitleScreen_Load_BlankPalette
.byte ^TitleScreen_Load_Tiles
.byte ^TitleScreen_Load_TileMap
.byte ^TitleScreen_Show_Palette
.byte ^TitleScreen_Animate_Init
.byte ^TitleScreen_Animate_Update
.byte ^TitleScreen_Animate_Show

TitleScreen_Load:

TitleScreen_Load_BlankPalette:

    ;DMA_PALETTE gb_palette, $00, $40
    DMA_PALETTE border_title_palette, $60, $40

    ; Only show BG 2+3
    lda #$06
    sta f:$212C

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

    lda #TITLESCREEN_ANIMATE
    sta f:TitleScreen_State

    jml TitleScreen_End

TitleScreen_Animate_Init:

    ; Setup the initial window values to animate`
    lda #40
    sta f:TitleScreen_Wipe_Top

    lda #72
    sta f:TitleScreen_Wipe_Bottom

    lda #208
    sta f:TitleScreen_Wipe_Right

    lda #19
    sta f:TitleScreen_Counter

    lda #48
    sta f:TitleScreen_Wipe_Left

    LDA #0
    PHA
    PLB

    ; Show 1+2+3
    lda #%00000111
    sta f:$212C

    ; Configure BG1 to use the correct tile location offset
    lda #1
    sta f:$210B

    ; Temp window values
    LDA #$FF      ; Window starts at X = 64
    STA $2126       ; Set Window 1 Left/Right Position (Window Cutout Area)
    
    LDA #$00      ; Window starts at X = 64
    STA $2127   ; Set Window 1 Left/Right Position (Window Cutout Area)

    ; Enable Window 1 for the Subscreen ($212F)
    LDA #%00000001  ; Apply windowing to BG1 (main)
    STA $212E

    ; Set Window Mask Logic (Inside window is visible)
    LDA #%00000011  ; Inside window = Show BG2 (Subscreen)
    STA $2123

    lda #TITLESCREEN_ANIMATE_UPDATE
    sta f:TitleScreen_State

TitleScreen_Animate_Update:
    WAIT_FOR_VBLANK

    LDA #0
    PHA
    PLB


    ; Set HDMA channel 2
    LDA #$00
    STA $4320    ; Mode 0 (1 byte per scanline)

    LDA #$26
    STA $4321    ; Window 1 Left Position ($2126)

    LDA #<TitleScreen_HDMA_Table_WindowLeft
    STA $4322    ; Low byte of table address
    LDA #>TitleScreen_HDMA_Table_WindowLeft
    STA $4323    ; High byte of table address
    LDA #^TitleScreen_HDMA_Table_WindowLeft
    STA $4324    ; Bank byte of table address

    ; Set HDMA channel 3
    LDA #$00        ; Mode 0 (1 byte per scanline)
    STA $4330    

    LDA #$27        ; Window 1 Left Position ($2126)
    STA $4331

    LDA #<TitleScreen_HDMA_Table_WindowRight
    STA $4332    ; Low byte of table address
    LDA #>TitleScreen_HDMA_Table_WindowRight
    STA $4333    ; High byte of table address
    LDA #^TitleScreen_HDMA_Table_WindowRight
    STA $4334    ; Bank byte of table address

    LDA #%00001100
    STA $420C    ; Enable HDMA channel 2 and 3

    
    ; Setup the default window values
    LDA #$FF      ; Window starts at X = 64
    STA $2126       ; Set Window 1 Left/Right Position (Window Cutout Area)
    
    LDA #$00      ; Window starts at X = 64
    STA $2127   ; Set Window 1 Left/Right Position (Window Cutout Area)

TitleScreen_HDMA_Update:
    lda f:TitleScreen_Counter
    beq TitleScreen_Animate_Show
    
    dec
    sta f:TitleScreen_Counter

    lda f:TitleScreen_Wipe_Top
    dec
    dec
    sta f:TitleScreen_Wipe_Top

    lda f:TitleScreen_Wipe_Bottom
    inc
    inc
    sta f:TitleScreen_Wipe_Bottom

    lda f:TitleScreen_Wipe_Left
    dec
    dec
    sta f:TitleScreen_Wipe_Left

    lda f:TitleScreen_Wipe_Right
    inc
    inc
    sta f:TitleScreen_Wipe_Right

    ; Setup the values HDMA
    lda f:TitleScreen_Wipe_Top
    sta f:TitleScreen_HDMA_Table_WindowLeft
    sta f:TitleScreen_HDMA_Table_WindowLeft+6
    sta f:TitleScreen_HDMA_Table_WindowRight
    sta f:TitleScreen_HDMA_Table_WindowRight+6

    ; The max value for line count is 128, so we need to have 2 entries
    lda f:TitleScreen_Wipe_Bottom
    sta f:TitleScreen_HDMA_Table_WindowLeft+2
    sta f:TitleScreen_HDMA_Table_WindowLeft+4
    sta f:TitleScreen_HDMA_Table_WindowRight+2
    sta f:TitleScreen_HDMA_Table_WindowRight+4

    lda f:TitleScreen_Wipe_Left
    sta f:TitleScreen_HDMA_Table_WindowLeft+3
    sta f:TitleScreen_HDMA_Table_WindowLeft+5

    lda f:TitleScreen_Wipe_Right
    sta f:TitleScreen_HDMA_Table_WindowRight+3
    sta f:TitleScreen_HDMA_Table_WindowRight+5

    jml TitleScreen_End


TitleScreen_Animate_Show:

    LDA #0
    PHA
    PLB

    LDA #%00000000
    STA $420C    ; Disable HDMA channel 2 and 3

    ; Disable Window 1 for the mainscreen
    LDA #%00000000
    STA $212E

    ; Configure BG1 to use the correct tile location offset
    lda #1
    sta f:$210B

    ; Show 1+3
    lda #%00000111
    sta f:$212C

    lda #TITLESCREEN_STATE_NONE
    sta f:TitleScreen_State

    jml TitleScreen_End

TitleScreen_HDMA_Table_WindowLeft:
    ; Top clip
    .byte 1
    .byte 255
    ; Left Clip 1
    .byte 1
    .byte 1
    ; Left Clip 2
    .byte 1
    .byte 1
    ; Bottom Clip
    .byte $FF
    .byte $FF
    .byte 0      ; End of HDMA table

TitleScreen_HDMA_Table_WindowRight:
    ; Top clip
    .byte 1
    .byte 1
    ; Left Clip 1
    .byte 1
    .byte 1
    ; Left Clip 2
    .byte 1
    .byte 1
    ; Bottom Clip
    .byte $FF
    .byte 01
    .byte 0      ; End of HDMA table

border_title_tiles:
    .incbin "src/super-awakening/snes/gfx/border_title.4bpp"
border_title_tilemap:
    .incbin "src/super-awakening/snes/gfx/border_title.map"
border_title_palette:
    .incbin "src/super-awakening/snes/gfx/border_title.pal"
white_palette:
    .incbin "src/super-awakening/snes/gfx/white.pal"
gb_palette:
    .incbin "src/super-awakening/snes/gfx/gb.pal"

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
