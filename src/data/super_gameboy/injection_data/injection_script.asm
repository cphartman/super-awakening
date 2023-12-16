.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits

.include "snes.inc"
.segment "CODE"
CODE:

INPUT_REMAPPER:

   ;JML PollMulti5
   
   seta8

INPUT_MAP_R_TO_P2_START:   
   LDA Player1Input
   AND #KEY_R
   CMP #KEY_R
   BNE INPUT_MAP_R_TO_P2_START_end
   LDA Player2Input+1
   ORA #KEY_START
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_R_MASK
   STA Player1Input
INPUT_MAP_R_TO_P2_START_end:


INPUT_MAP_L_TO_P2_SELECT:   
   LDA Player1Input
   AND #KEY_L
   CMP #KEY_L
   BNE INPUT_MAP_L_TO_P2_SELECT_end
   LDA Player2Input+1
   ORA #KEY_SELECT
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_L_MASK
   STA Player1Input
INPUT_MAP_L_TO_P2_SELECT_end:

INPUT_MAP_X_TO_P2_UP:   
   LDA Player1Input
   AND #KEY_X
   CMP #KEY_X
   BNE INPUT_MAP_X_TO_P2_UP_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_UP
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_X_MASK
   STA Player1Input
INPUT_MAP_X_TO_P2_UP_end:

INPUT_MAP_Y_TO_P2_LEFT:   
   LDA Player1Input+1
   AND #KEY_Y
   CMP #KEY_Y
   BNE INPUT_MAP_Y_TO_P2_LEFT_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_LEFT
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input+1
   AND #KEY_Y_MASK
   STA Player1Input+1
INPUT_MAP_Y_TO_P2_LEFT_end:

INPUT_MAP_A_TO_P2_RIGHT:   
   LDA Player1Input
   AND #KEY_A
   CMP #KEY_A
   BNE INPUT_MAP_A_TO_P2_RIGHT_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_RIGHT
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_A_MASK
   STA Player1Input
INPUT_MAP_A_TO_P2_RIGHT_end:

INPUT_MAP_B_TO_P2_DOWN:   
   LDA Player1Input+1
   AND #KEY_B
   CMP #KEY_B
   BNE INPUT_MAP_B_TO_P2_DOWN_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_DOWN
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input+1
   AND #KEY_B_MASK
   STA Player1Input+1
INPUT_MAP_B_TO_P2_DOWN_end:

INJECTION_END:
   JML $00080C

   ; Do our own input polling here
JOY0 = $4016
JOY1 = $4017
IgnorePlayer5Input = $0F1F
IgnorePlayer4Input = $0F1E
IgnorePlayer3Input = $0F1D
IgnorePlayer2Input = $0F1C
IgnorePlayer1Input = $0F1B
Player5Input = $0F19
Player4Input = $0F17
Player3Input = $0F15
Player2Input = $0F13
Player1Input = $0F11
JOY2B1CUR = $421E
JOY2CUR = $421A
JOY1CUR = $4218
VBLSTATUS = $4212
Multi5Present = $0F10

.proc PollMulti5
   
	PHP
	setaxy8
	;STZ Multi5Present
:	; Wait for auto-poll to end
	;LDA VBLSTATUS
	;AND #1
	;BNE :- 
	;LDA JOY1CUR+1
	;STA Player1Input+1
	;LDA JOY1CUR
	;STA Player1Input
	;AND #$F
	;STA IgnorePlayer1Input
	;LDA f:JOY0
	;LSR
	;ROL IgnorePlayer1Input

	;LDA JOY2CUR+1
	;STA Player2Input+1
	;LDA JOY2CUR
	;STA Player2Input
	;AND #$F
	;STA IgnorePlayer2Input

	;LDA JOY2B1CUR+1
	;STA Player3Input+1
	;LDA JOY2B1CUR
	;STA Player3Input
	;AND #$F
	;STA IgnorePlayer3Input
	;LDA f:JOY1
	;LSR
	;ROL IgnorePlayer2Input
	;LSR
	;ROL IgnorePlayer3Input

	;LDA #$7F
	;STA WRIO
bar:
   ;setxy8
	;LDY #$10
;:
;	LDA f:JOY1
;	seta16
;	LSR
;	ROL Player4Input
;	LSR
;	ROL Player5Input
;	seta8
;	DEY
;	BNE :-
;	LDA Player4Input
;	AND #$F
;	STA IgnorePlayer4Input
;	LDA Player5Input
;	AND #$F
;	STA IgnorePlayer5Input
;	LDA f:JOY1
;	LSR
;	ROL z:$001E ; `IgnorePlayer4Input` is at $0F1E, this looks like a typo
;	LSR
;	ROL IgnorePlayer5Input

	;LDA #$FF
	;STA WRIO
	PLP
	
   ;RTS
   JML INJECTION_END
.endproc


; EOF marker for convert_sfc_to_packets.py
.byte 0,0,0