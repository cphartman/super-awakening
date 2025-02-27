def binary_to_hex_text(input_file, output_file):
    with open(input_file, "rb") as f, open(output_file, "w") as out:
        while chunk := f.read(8):
            hex_pairs = [f"${byte:02X}" for byte in chunk]
            out.write("db "+", ".join(hex_pairs) + "\n")

binary_to_hex_text("src/super-awakening/snes/gfx/azle_000.4bpp", "src/data/super_gameboy/frame_tiles_a.asm")
binary_to_hex_text("src/super-awakening/snes/gfx/azle_000.map", "src/data/super_gameboy/frame_tilemap.asm")

binary_to_hex_text("src/super-awakening/snes/gfx/azle_000.pal", "src/data/super_gameboy/frame_palette_1.asm")
#binary_to_hex_text("src/super-awakening/snes/gfx/azle_000.pal", "src/super-awakening/snes/gfx/azle_000.pal.asm")