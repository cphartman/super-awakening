# SNES SGB Injection

1) Build the snes code
    * `cl65 -v -C smc.cfg -o snes_out.smc snes_in.asm`
1) Generate GB patch data from the SNES code
    * `> convert_sfc_to_packets.py > gb_data.asm`
1) Add a loader to [`src/code/super_gameboy.asm`](https://github.com/cphartman/super-awakening/blob/4bb393bb9c20ecfa0e6dccdc8e2788dc3b1782b5/src/code/super_gameboy.asm#L126-L149)
1) Patch a hook into into our code from existing SGB Code.
    * Hijack `SGBPatch8Cmd` by adding a [JUMP to our code](https://github.com/cphartman/super-awakening/blob/5248fabb56cb0a3eab1dd258387af7f743026fd3/src/data/super_gameboy/commands.asm#L116-L117)
    * Make sure to [jump back](https://github.com/cphartman/super-awakening/blob/5248fabb56cb0a3eab1dd258387af7f743026fd3/src/data/super_gameboy/injection_data/injection_script.asm#L22)
        * Maybe this could be a function or something nicer
        * There are probably better points to hook in, but will require analysis of the rom.  It looks like we're deep in the call stack at this hook point.