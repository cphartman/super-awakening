ExecuteActiveEntityHandler:
    Jump to entity handler here

Does not overried enemies

Map Layout
    XYAB: 1E
    RL: 1D
    Lift: 1C
    Dash: 0C
    End: 0B

Bank 2 - Apply room transition
    From Bank 0: 
        .wInvincibilityAtZero
            [...]
            callsw ApplyRoomTransition 
    See .mysteriousWoodsEnd for example room jump

Tile format?
    ; Read an individual room object, and write it to the unpacked room objects area.
    ; bc : start address of the object
    ;
    ; Objects can be 2-bytes objects or 3-bytes objects:
    ;
    ; twoBytesObject:
    ;   ds 1 ; location (YX)
    ;   ds 1 ; type
    ;
    ; threeBytesObject:
    ;   ds 1 ; direction and length (8X: horizontal + length ; CX: vertical + length)
    ;   ds 1 ; location (YX)
    ;   ds 1 ; type
    ;


Dashable rocks in the overworld?
    The check to break the rock is short circuited at Bank2 .jr_733B
    Still missing pallet though


; Define an entity in an entities list
; Usage:
;   entity <vertical-position>, <horizontal-position>, <type>

Which owl dialog to show?
    MapSpecialLocationNamesTable => MapSpecialLocationNamesLookupTable


; Open a dialog in the $200-$2FF range
; Input:
;   a: dialog index in table 2
OpenDialogInTable2::
    call OpenDialogInTable0                       ; $237C: $CD $85 $23
    ; Overwrite the table number
    ld   a, $02                                   ; $237F: $3E $02
    ld   [wDialogIndexHi], a                      ; $2381: $EA $12 $C1
    ret       

    Table #2, Dialog $00 => Dialog1FB
    Last in table #2 = Dialog24D


Owl tiles:
    oam_npc_1.dmg.png
    RoomSpritesheetGroupsTable determines which tileset gets loaded into a room
    Tile rows 0D00-0Df0 and 0E00-0EF0 are used for instruments and dialog text
        Maybe we can hijack this for the owl on map B0

Loading SGB BG:

./superfamiconv -i src/super-awakening/snes/gfx/azle_000.png -t src/super-awakening/snes/gfx/azle_000.4bpp -m src/super-awakening/snes/gfx/azle_000.map -p src/super-awakening/snes/gfx/azle_000.pal --bpp 4 -W 8 -H 8 -v -P 4 -R

Set the tiles to use palette 4: -P 4 
Don't mess with palette order: -R

# Expected map size is 2048
truncate -s 2048 src/super-awakening/snes/gfx/azle_000.map

# Copy bin to text files
ython3 convertBinToText.py


I think the -R with the palette generation is conflicting with the tile generation, need to split that into 2 commands?

./superfamiconv palette -i src/super-awakening/snes/gfx/azle_000.png -d src/super-awakening/snes/gfx/azle_000.pal -W 8 -H 8 -v -P 4
