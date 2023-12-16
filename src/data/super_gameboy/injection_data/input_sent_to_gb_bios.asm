; Replacement for the skipped SendInputsToGB native code

; Jump into the modified subroutie
   PHB ; Push the current data bank
   LDA #$7f
   PHA ; Push the bank to the stack
   PLB ; Set the data bank from the stack
   
   ;JSR SendInputsToGB
   
   PLB ; Restore the old databank
; ; Manipulate the stack so that the RTS we jump back to will return to a different location
; In this case, we want to skip [SendInputsToGB]
RETURN_AND_SKIP_BIOS_SendInputsToGB:
   ; Pop the return PC off the stack
   PLA
   PLA
   ; Push a new address
   LDA #$BA
   PHA
   LDA #$A9
   PHA
   JML $00080C
RETURN_AND_SKIP_BIOS_SendInputsToGB_end:

; Copy of the input controler code from the BIOS that we're skipping

MultiplayerControl = $02F2
ICD2P1        = $6004
P1GBInput = $0158
MapSNES_BToGB_A = $0C04
PlayerInput = $0010
GBInput = $0008
Player1Input = $0F11
TransmitOnlyStartSelect = $0F01

.proc SendInputsToGB
.a8
.i8
	LDA MultiplayerControl
	BEQ :+
	LDX #1
	JSR SendPlayerInputToGB
	LDA MultiplayerControl
	CMP #1
	BEQ :+
	LDX #2
	JSR SendPlayerInputToGB
	LDX #3
	JSR SendPlayerInputToGB
:
	LDX #0
	JSR SendPlayerInputToGB
	RTS
.endproc

.proc SendPlayerInputToGB
.a8
.i8
	LDA TransmitOnlyStartSelect
	BNE @onlyStartSelect
	TXA
	ASL
	TAY
	LDA Player1Input, Y
	AND #$F
	BNE @disconnected
	LDA Player1Input  , Y
	STA PlayerInput
	LDA Player1Input+1, Y
	STA PlayerInput+1
	JSR ConvertSNESInputToGB
	RTS

@disconnected:
	LDA #$FF
	STA P1GBInput
	STA f:ICD2P1, X
	RTS

@onlyStartSelect:
	TXA
	ASL
	TAY
	LDA Player1Input+1, Y ; Possible mistake?
	AND #$F
	BNE @disconnected
	STZ PlayerInput
	LDA Player1Input+1, Y
	AND #$30
	STA PlayerInput+1
	JSR ConvertSNESInputToGB
	RTS
.endproc

.proc ConvertSNESInputToGB
.a8
	STZ GBInput
	LDA PlayerInput
	AND #$80 ; A
	LSR
	LSR
	LSR
	TSB GBInput
	LDA PlayerInput+1
	AND #$80 ; B
	LSR
	LSR
	LDY MapSNES_BToGB_A
	BEQ :+
	LSR
:
	TSB GBInput
	LDA PlayerInput+1
	AND #$10 ; Start
	ASL
	ASL
	ASL
	TSB GBInput
	LDA PlayerInput+1
	AND #$20 ; Select
	ASL
	TSB GBInput
	LDA PlayerInput+1
	AND #8 ; Up
	LSR
	TSB GBInput
	LDA PlayerInput+1
	AND #4 ; Down
	ASL
	TSB GBInput
	LDA PlayerInput+1
	AND #$40 ; Y
	LSR
	TSB GBInput
	LDA PlayerInput+1
	AND #3 ; Left and Right
	ORA GBInput
	EOR #$FF
	STA P1GBInput
	STA f:ICD2P1, X
	RTS
.endproc

; END INPUT BIOS CODE