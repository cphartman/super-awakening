cl65 -v -C src/data/super_gameboy/injection_data/smc.cfg -o snes_injection_data.smc src/data/super_gameboy/injection_data/injection_script.asm
python3 tools/convert_sfc_to_packets.py > src/data/super_gameboy/injection_data.asm
make build