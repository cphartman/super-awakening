; Adapted from https://github.com/gitendo/helloworld

SuperAwakening_SgbFailScreen::

.Show

	di					; disable interrupts

	ld	hl,_HRAM			; clear hram
	ld	c,$80				; a = 0, b = 0 here, so let's save a byte and 4 cycles (ld c,$80 - 2/8 vs ld bc,$80 - 3/12)
	call	fill

	ld	hl,picture_chr			; picture data
	ld	de,_VRAM			; place it between $8000-8FFF (tiles are numbered here from 0 to 255)
	ld	bc,3872				; gbhorror.chr file size
	call 	copy

	ld	hl,picture_map			; picture map (not padded, 160x144px = 20*18)
	ld	de,_SCRN0			; place it at $9800
	call	copy_map			; should have used bmp2cgb with -e option :)

	ld	a,%10100111			; color values: 00 - light, 01 - gray, 10 - dark gray, 11 - dark
	ld	[rBGP],a			; bg palette
	ld	[rOBP0],a			; obj palettes (not used in this example)
	ld	[rOBP1],a
	
	
	; Setup GBC pallets
	ld	hl,picture_pal		; picture palette
	ld	b,64				; gbcyus.pal file size
							; 1 palette has 4 colors, 1 color takes 2 bytes, so 8 palettes = 64 bytes
	call	set_bg_pal


	ld	a,LCDCF_ON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJOFF | LCDCF_WINOFF | LCDCF_BGON
						; lcd setup: tiles at $8000, map at $9800, 8x8 sprites (disabled), no window, etc.
	ld	[rLCDC],a			; enable lcd

.the_end
	halt					; save battery
;	nop					; nop after halt is mandatory but rgbasm takes care of it :)
	jr	.the_end			; endless loop


;-------------------------------------------------------------------------------	
copy:
;-------------------------------------------------------------------------------
; hl - source address
; de - destination
; bc - size

	inc	b
	inc	c
	jr	.skip
.copy
	ld	a,[hl+]
	ld	[de],a
	inc	de
.skip
	dec	c
	jr	nz,.copy
	dec	b
	jr	nz,.copy
	ret


;-------------------------------------------------------------------------------	
copy_map:
;-------------------------------------------------------------------------------
; hl - map data
; de - _SCRN0 or _SCRN1
; b  - rows
; c  - columns
						; picture is 160x144px,
	ld	b,18				; 144/8 = 18 rows
.next_row
	ld	c,20				; 160/8 = 20 tiles each
.row
	ld	a,[hl+]				; fetch one byte from rom and increase hl to point to another one
	ld	[de],a				; store it at _SCRN0
	inc	de				; unfortunately there's no [de+]
	dec	c				; one byte done
	jr	nz,.row				; next byte, copy untill c=0

	ld	a,e				; our row = 20 which is what you can see on the screen
	add	a,12				; the part you don't see is 12, so we need to add it
	jr	nc,.skip			; to make sure the next row is copied at right offset
	inc	d                               ; nc flag is set when a+12 > 255
.skip
	ld	e,a

	dec	b				; next row, copy untill b=0
	jr	nz,.next_row
	ret


;-------------------------------------------------------------------------------
fill:
;-------------------------------------------------------------------------------
; a - byte to fill with
; hl - destination address
; bc - size of area to fill

	inc	b
	inc	c
	jr	.skip
.fill
	ld	[hl+],a
.skip
	dec	c
	jr	nz,.fill
	dec	b
	jr	nz,.fill
	ret

;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
set_bg_pal:
;-------------------------------------------------------------------------------
	ld	a,%10000000			; bit 7 - enable palette auto increment
						; bits 5,4,3 - palette number (0-7)
						; bits 2,1 - color number (0-3)
	ld	[rBCPS],a			; we start from color #0 in palette #0 and let the hardware to auto increment those values while we copy palette data
.copy
	ld	a,[hl+]				; this is really basic = slow way of doing things
	ldh	[rBCPD],a
	dec	b
	jr	nz,.copy
	ret

picture_chr:					; bmp2cgb -x -y -z gbhorror.bmp
    INCBIN	"/gfx/super_awakening/sgb_fail_screen.2bpp"
picture_map:
	INCBIN	"/gfx/super_awakening/sgb_fail_screen.tilemap"
picture_pal:
	INCBIN	"/gfx/super_awakening/sgb_fail_screen.pal"