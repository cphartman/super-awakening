.scope PaletteService

; Create local shorthand varables to use in this scope
State = PaletteService_State

STATE_NONE      = 0
STATE_FADE_OUT   = 1

.a8
seta8

; Palette service manages palette transitions
; Set [PaletteService_State] = EFFECT_NAME to start the process
Init:
    ; Backup flags and bank
   PHP
   PHB

    ; Set flags we use
   .i16
   rep #$10        ; X/Y 16-bit
   .a8
   sep #$20        ; A 8-bit

    ; Load Super Awakening Bank
    LDA #^SuperAwakeining_Snes_Wram
    PHA         ; Push it onto the stack
    PLB         ; Pull into DBR (set data bank)

StateCheck:
    lda State
    cmp #STATE_NONE
    bne StateJump
    jmp End

StateJump:
    ; Jump to the curernt state
    LDX State
    LDA JumpTable_Low,X
    STA $00  ; Store low byte
    LDA JumpTable_High,X
    STA $01  ; Store high byte
    LDA JumpTable_Bank,X
    STA $02  ; Store bank byte

    JML [$00]

; Jump table for the states
 JumpTable_Low:
    .byte <End
    .byte <FadeOut0
    .byte <FadeOut1
    .byte <FadeOut2
    .byte <FadeOut3
 JumpTable_High:
    .byte >End
    .byte >FadeOut0
    .byte >FadeOut1
    .byte >FadeOut2
    .byte >FadeOut3
 JumpTable_Bank:
    .byte ^End
    .byte ^FadeOut0
    .byte ^FadeOut1
    .byte ^FadeOut2
    .byte ^FadeOut3

FadeOut0:

    WAIT_FOR_VBLANK
    DMA_PALETTE Border_Original_Palette_Fade_0, $40, $40
    jmp End

FadeOut1:

    WAIT_FOR_VBLANK
    DMA_PALETTE Border_Original_Palette_Fade_1, $40, $40
    jmp End

FadeOut2:

    WAIT_FOR_VBLANK
    DMA_PALETTE Border_Original_Palette_Fade_2, $40, $40
    jmp End

FadeOut3:

    WAIT_FOR_VBLANK
    DMA_PALETTE Border_Original_Palette_Fade_3, $40, $40
    jmp End

End:
    PLB
    PLP

.endscope