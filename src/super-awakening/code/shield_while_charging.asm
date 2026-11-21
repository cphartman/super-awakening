IF SUPER_AWAKENING_SHIELD_WHILE_CHARGING
; Called from CheckItemsToUse. Sword and shield share the B slot, so if the
; shield button is held while the sword is out, return nz to raise the shield
; too, like having it on A in the original game.
SuperAwakening_ShieldWithSword::
    ld   a, [wInventoryItems.BButtonSlot]
    cp   INVENTORY_SWORD
    jr   nz, .no
    ld   a, [wShieldLevel]
    and  a
    jr   z, .return
    ld   a, [wSuperAwakening.PressedButtonsMask]
    and  J_A
    jr   .return
.no
    xor  a
.return
    ; Keep the flags for the caller
    ld   a, [wCurrentBank]
    jp   SuperAwakening_Trampoline.returnToBank
ENDC
