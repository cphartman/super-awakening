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

   .include "map-snes1-to-gb2.asm" 
   .include "border-service.asm" 

INJECTION_END:
   JML $00080C

border_file_menu_tiles:
.incbin "src/super-awakening/snes/gfx/border_file_menu.4bpp"
border_file_menu_tilemap:
.incbin "src/super-awakening/snes/gfx/border_file_menu.map"
border_file_menu_palette:
.incbin "src/super-awakening/snes/gfx/border_file_menu.pal"

; EOF marker for convert_sfc_to_packets.py
.byte 0,0,0