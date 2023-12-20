# `Super Game Boy` Code Injection Toolchain

Toolchain for injecting `SNES` code from `LADX` via `Super Game Boy`.  Use `make build` to include injected `SNES` assembly when the game boots.  The injected code will be called from the `Super Game Boy` bios once per frame.  Data can also be sent from the `GB` to the `SNES` during gameplay.

# Injection Toolchain

The steps list out how the `SNES` assembly gets built, injected, and executed on the `SNES`.

### 1) Build the `SNES` injection payload
The `SNES` assembly from `entry.asm` is compiled into into `snes_injection_data.smc`.  This file contains the code that will be injected into the `SNES`.

### 2) Build `SGB` injection packet data
The script `convert_sfc_to_packets.py` formats `snes_injection_data.smc` into packet data that can easily be ready by the `GB` and sent to the `SGB`.  This packet data is written to the file `injection_packets.asm`.

### 3) Send injection packet data to `SGB`
`GB` code is added to the `LADX` boot sequence [to send the injection packet data](https://github.com/cphartman/super-awakening/blob/f63f1c053b0411459c79dcac2076e0bdb2083555/src/code/super_gameboy.asm#L81-L89) to the `SGB`.  The payload is uploaded to `WRAM` at `$7f0000`.

### 4) Hook into the `SGB` bios gameloop 
Send a data packet to patch `$000808`.  The patch will add a jump to our injected code at `$7f0000`.

# File Structure

| `SNES` Payload | Notes |
| ---- | ---- |
| `/src/data/super_gameboy/injection/` | Directory of payload source files |
| `./entry.asm` | Entry point for injected code |
| `./scripts/moasic-effect.asm` | *Example:* Trigger a PPU effect |
| `./scripts/controller-remmap.asm` | *Example:* Map `SNES` P1 X/Y/R/L to `GB` P2 Up/Down/Right/Left |
| `./smc.cfg` | Linker config to map labels to the right memory bank |
| `./snes.inc` | Misc constants |

| Injection Toolchain | Notes |
| ---- | ---- |
| `/tools/convert_sfc_to_packets.py` | Converts `smc` to packet data the `GB` can send to `SGB` |
| `/src/code/super_gameboy.asm` | [Upload the payload to the `SGB` on game load](https://github.com/cphartman/super-awakening/blob/f63f1c053b0411459c79dcac2076e0bdb2083555/src/code/super_gameboy.asm#L81-L89) |
| `/src/code/bank0.asm` | *Example:* [Send data from `GB` to `SGB`  during game loop](https://github.com/cphartman/super-awakening/blob/f63f1c053b0411459c79dcac2076e0bdb2083555/src/code/super_gameboy.asm#L81-L89) |

| Generated Files | Notes |
| ---- | ---- |
| `/snes_injection_data.smc` | `SNES` code payload to send |
| `/src/data/super_gameboy/injection_packets.asm` | `GB` will send these packets to the `SGB` |


# `SGB` bios hook
The `SGB` allows the `GB` to write to the `WRAM` locations `$001800-$001FFF` and `$7F0000-$7fFFFF`. The `SGB` bios has a game loop subroutine at `$0000BAA4`, which is what calls `SendInputsToGB`.  The first part of this game loop subroutine calls into an empty subroutine at `$000808`.  The `SGB` bios for this looks like:
```
[00BAA4]  JSR $0808    ; EmptySubroutine (WRAM, writeable)
[00BAA7]  JSR $BC7F    ; SendInputsToGB (ROM, read only)
[00BAAA]  JSR $BD2C    ; Unknown (ROM)
[00BAAD]  JSR $BABA    ; Unknown (ROM)
[00BAB0]  JSR $BBD9    ; Unknown (ROM)
[00BAB3]  JSR $BBD9    ; Unknown (ROM)
[00BAB6]  JSR $0810    ; Unknown (WRAM)
[00BAB9]  RTS          ; return
```  

Adding a jump at `$000808` to `$7f0000` will hook into our injected payload every game frame.  The payload needs to jump back to `$00BAA7` to resume the bios game loop.

The bios code at `$000808` it a 1 byte `RTS`, which means that our injected jump is stomping over 4 bytes in the next section.  The purpose of this next section is not known, but doesn't seem to be used in testing.

# Manual build process

1) Build the SNES code
    * `cl65 -v -C smc.cfg -o snes_out.smc snes_in.asm`
1) Generate packets data from the SNES build
    * `convert_sfc_to_packets.py > gb_data.asm`
        * The path to the input smc is hardcoded in the script :/
        * `build.sh` generates [this file](https://github.com/cphartman/super-awakening/blob/sgb-injection/src/data/super_gameboy/injection_data.asm)
1) Send generated packets to the SNES during the boot sequence
    * [`src/code/super_gameboy.asm`](https://github.com/cphartman/super-awakening/blob/sgb-injection/src/code/super_gameboy.asm#L126-L149)
1) Add a hook from the SGB Bios into our injected code
    * Send a new patch `AwakeningHookPatchCmd` which adds a [JUMP to our code](https://github.com/cphartman/super-awakening/blob/sgb-injection/src/data/super_gameboy/commands.asm#L116-L117)
    * Make sure to [jump back](https://github.com/cphartman/super-awakening/blob/sgb-injection/src/data/super_gameboy/injection_data/injection_script.asm#L22)
