SUBSATE_SHOW_DIALOG                 = $00
SUBSATE_WAIT_FOR_TRANSITION_START   = $01
SUBSATE_WAIT_FOR_TRANSITION_END     = $02


SuperAwakening_Demo::

.is_demo_mode
    ld a, [wSuperAwakening.DemoMode_State]
    cp 0
    jp z, .return

    ld a, [wSuperAwakening.DemoMode_SubState]
    cp SUBSATE_SHOW_DIALOG
    jp z, .show_dialog
    cp SUBSATE_WAIT_FOR_TRANSITION_START
    jp z, .wait_for_transition_start
    cp SUBSATE_WAIT_FOR_TRANSITION_END
    jp z, .wait_for_transition_end
    jp .return

.wait_for_transition_start
    ld a, [wRoomTransitionState]
    cp 0
    jp z, .return
    ld a, SUBSATE_WAIT_FOR_TRANSITION_END
    ld [wSuperAwakening.DemoMode_SubState], a
    jp .return

.wait_for_transition_end
    ld a, [wRoomTransitionState]
    cp 0
    jp nz, .return
    ; Go to the next demo mode
    ld a, [wSuperAwakening.DemoMode_State]
    inc a
    ld [wSuperAwakening.DemoMode_State], a

    ld a, SUBSATE_SHOW_DIALOG
    ld [wSuperAwakening.DemoMode_SubState], a
    jp .return

.show_dialog
    ld a, SUBSATE_WAIT_FOR_TRANSITION_START
    ld [wSuperAwakening.DemoMode_SubState], a
    
    ld a, [wSuperAwakening.DemoMode_State]
    cp 2
    jp z, .show_dialog_2
    cp 3
    jp z, .show_dialog_3
    cp 4
    jp z, .show_dialog_4
    cp 5
    jp z, .show_dialog_5
    jp .return

.show_dialog_2
    call_open_dialog Dialog2B1
    jp .return
.show_dialog_3
    ld a, $01
    ld [wSuperAwakening.Jump_Enabled], a
    call_open_dialog Dialog2B3
    jp .return
.show_dialog_4
    call_open_dialog Dialog2B5
    jp .return
.show_dialog_5
    ld a, $01
    ld [wSuperAwakening.Dash_Enabled], a
    call_open_dialog Dialog2B4
    jp .return

.return
