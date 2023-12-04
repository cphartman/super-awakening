# Inventory progression
Describes persisting and progressing available items with the custom inventory system

## Inventory system in Links Awakening

### Inventory data structure
The `A`, `B` and `10 inventory items` are stored in a linear address space in wram.  The list starts with B button in `DB00`, then the A button in `DB01`, and then the `10 inventory items` in `DB02` - `DB0B`.  Each slot represents the value of an [item](inventory.asm#empty).  A value of `0` represents an empty item slot.  Values `1` - `13` represent one of the possible items. Values `14` and `15` are undefined.

### Inventory during gameplay
When `A` or `B` is pressed, the gameplay loop will check the item value in `DB00` or `DB01` and execute any necessary item logic.

The pause menu allow you to switch items between `DB00`-`DB01` and `DB02`-`DB0B`.  The game loop for handling this input happens in `[5F06].moveInventoryCursor`.

For a new game, this list from `DB00`-`DB0B` starts empty.  When an item is obtained, it is added to the first un-occupied slot in the inventory.  By the end of the game, the user will have all `11` slots filled with their items.  

The shovel and boomerang are separate items.  The shop keeper swaps the values in your inventory between them.

The powder and toadstool are the same item.  There is a toggle that is disabled when talking to the witch and changing it from toadstool to powder.

### Saving and Loading
Progression variables used in gameplay are stored from `D800` to `DB7F`.  On game save, this memory range is written to one of the 3 save slots on save.  On game load, the save slot data is written back to `D800` to `DB7F`.  This range include the inventory slots from `DB00`-`DB0B`.

## Super Links Awakening

### Data structures
### Using items
### Custom Inventory System
### Progression system
### Save/Load system

The same logic of saving/restoring between the save slot and `D800` to `DB7F` is unchanged.  A hook before saving populates the inventory slots of `DB01`-`DB0B`.  Progression is read from `wSuperAwakening.Items_Unlocked` and any unlocked item is added to the inventory slots.
