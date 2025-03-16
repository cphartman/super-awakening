import sys
import struct
import os

def read_palette(path):
    with open(path, "rb") as f:
        data = f.read()
        if len(data) % 2 != 0:
            raise ValueError(f"Palette file '{path}' must be an even number of bytes (16-bit colors).")
        return [struct.unpack("<H", data[i:i+2])[0] for i in range(0, len(data), 2)]

def write_palette(path, colors):
    with open(path, "wb") as f:
        for color in colors:
            f.write(struct.pack("<H", color))

def fade_color(c1, c2, step, total_steps):
    r1, g1, b1 = (c1 & 0x1F), ((c1 >> 5) & 0x1F), ((c1 >> 10) & 0x1F)
    r2, g2, b2 = (c2 & 0x1F), ((c2 >> 5) & 0x1F), ((c2 >> 10) & 0x1F)

    r = r1 + ((r2 - r1) * step) // total_steps
    g = g1 + ((g2 - g1) * step) // total_steps
    b = b1 + ((b2 - b1) * step) // total_steps

    return (b << 10) | (g << 5) | r

def main():
    if len(sys.argv) != 3:
        print("Usage: python fade_palette.py palette1.pal palette2.pal")
        return

    pal1 = read_palette(sys.argv[1])
    pal2 = read_palette(sys.argv[2])

    if len(pal1) != len(pal2):
        raise ValueError("Both palette files must have the same number of colors.")

    base1 = os.path.splitext(os.path.basename(sys.argv[1]))[0]
    base2 = os.path.splitext(os.path.basename(sys.argv[2]))[0]

    total_steps = 5  # 0 = palette1, 5 = palette2; so intermediate fades will be 1..4

    for step in range(1, total_steps):
        fade = [fade_color(c1, c2, step, total_steps) for c1, c2 in zip(pal1, pal2)]
        filename = f"{base1}_{base2}_fade{step}.pal"
        write_palette(filename, fade)
        print(f"Generated {filename}")

if __name__ == "__main__":
    main()
