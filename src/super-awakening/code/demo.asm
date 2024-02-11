
SuperAwakening_Demo::

.is_demo_mode
    ld a, [wSuperAwakening.DemoMode]
    cp 0
    jp z, .return

    cp 1
    jp z, .wait_for_first_transition

    cp 2
    jp z, .wait_for_first_transition_end

    cp 3
    jp z, .show_dialog_2

    cp 4
    jp z, .wait_for_second_transition

    cp 5
    jp z, .wait_for_second_transition_end

    cp 6
    jp z, .show_dialog_3

    jp .return

.wait_for_first_transition
    ; Check if the room changed
    ld a, [wRoomTransitionState]
    cp 0
    jp z, .return
    ld a, 2
    ld [wSuperAwakening.DemoMode], a
    jp .return

.wait_for_first_transition_end
    ld a, [wRoomTransitionState]
    cp 0
    jp nz, .return
    ld a, 3
    ld [wSuperAwakening.DemoMode], a
    jp .return

.show_dialog_2
    call_open_dialog Dialog2B1
    ld a, 4
    ld [wSuperAwakening.DemoMode], a
    jp .return


.wait_for_second_transition
    ; Check if the room changed
    ld a, [wRoomTransitionState]
    cp 0
    jp z, .return
    ld a, 5
    ld [wSuperAwakening.DemoMode], a
    jp .return

.wait_for_second_transition_end
    ld a, [wRoomTransitionState]
    cp 0
    jp nz, .return
    ld a, 6
    ld [wSuperAwakening.DemoMode], a
    jp .return

.show_dialog_3
    ld a, $01
    ld [wSuperAwakening.Jump_Enabled], a

    call_open_dialog Dialog2B2
    ld a, 7
    ld [wSuperAwakening.DemoMode], a
    jp .return

.return
