.debuginfo + ; Enable symbols
.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits
.feature c_comments

.include "snes.inc"
.segment "CODE"

; To make debugging easier, put our heap at the top of the injection
; so the addresses doesn't shift around with code changes
INJECTION_HEAD:
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
   .include "commands/FileMenu.asm"
   .include "commands/GameplayBorder.asm"
   .include "commands/TitleScreen.asm"
   .include "commands/ScreenScroll.asm"
   .include "commands/LostWoods.asm"
   PLB
   PLP

INJECTION_END:
   JML $00080C

; EOF marker for convert_sfc_to_packets.py
.byte 0,0,0