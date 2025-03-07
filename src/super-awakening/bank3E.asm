include "super-awakening/code/update_loop.asm"
include "super-awakening/code/give_inventory_item.asm"
include "super-awakening/code/rupeearrow.asm"
include "super-awakening/code/save_load.asm"
include "super-awakening/code/inventory_screen.asm"
include "super-awakening/code/tutorial.asm"
include "super-awakening/code/send_sgb_packet.asm"

SuperAwakening_Gfx_ItemsOutline:
incbin "super-awakening/gfx/items_outline.dmg.2bpp"
SuperAwakening_Gfx_Tutorial:
incbin "super-awakening/gfx/tutorial_tiles.dmg.2bpp"
SuperAwakening_InventoryOverworldItemsTiles::
incbin "gfx/items/inventory_overworld_items.dmg.2bpp"