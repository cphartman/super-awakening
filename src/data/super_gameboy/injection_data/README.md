# SNES SGB Injection

Patch in SNES assembly to SGB via the LA boot sequence.

> bash build.sh

or

1) Build the SNES code
    * `cl65 -v -C smc.cfg -o snes_out.smc snes_in.asm`
1) Generate GB packets data from the SNES build
    * `convert_sfc_to_packets.py > gb_data.asm`
        * The path to the input smc is hardcoded in the script :/
        * `build.sh` generates [this file](https://github.com/cphartman/super-awakening/blob/sgb-injection/src/data/super_gameboy/injection_data.asm)
1) Send generated packets to the SNES during the boot sequence
    [`src/code/super_gameboy.asm`](https://github.com/cphartman/super-awakening/sgb-injection/src/code/super_gameboy.asm#L126-L149)
1) Add a hook to the code
    * Hijack `SGBPatch8Cmd` by adding a [JUMP to our code](https://github.com/cphartman/super-awakening/blob/sgb-injection/src/data/super_gameboy/commands.asm#L116-L117)
    * Make sure to [jump back](https://github.com/cphartman/super-awakening/blob/sgb-injection/src/data/super_gameboy/injection_data/injection_script.asm#L22)
        * Maybe this could be a function or something nicer
        * There are probably better points to hook in, but will require analysis of the rom.  It looks like we're deep in the call stack at this hook point.