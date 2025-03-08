.debuginfo + ; Enable symbols
.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits
.feature c_comments

.include "snes.inc"
.segment "CODE"

; To make debugging easier, put our heap at the top of the injection
; so the addresses doesn't shift around with code changes
   JMP INJECTION_START
SuperAwakeining_Snes_Wram:   
   .include "wram.asm"

SuperAwakeining_Snes_Utils:
   .include "util.asm" 

INJECTION_START:
   PHP
   PHB
   .include "map-snes1-to-gb2.asm" 
   .include "command-service.asm"
   .include "border-service.asm" 
   .include "palette-service.asm"
   .include "commands/FileMenu.asm"
   PLB
   PLP

INJECTION_END:
   JML $00080C

clouds_tiles:
.incbin "src/super-awakening/snes/gfx/clouds.4bpp"
clouds_tilemap:
.incbin "src/super-awakening/snes/gfx/clouds.map"
clouds_palette:
.incbin "src/super-awakening/snes/gfx/clouds.pal"

; EOF marker for convert_sfc_to_packets.py
.byte 0,0,0