import sys

def modify_file(input_file, output_file):
    with open(input_file, "rb") as infile:
        data = bytearray(infile.read())  # Read file into a mutable bytearray

    # Modify every other byte (1st, 3rd, 5th, etc.)
    for i in range(1, len(data), 2):  # Start at index 1, step by 2
        data[i] = (data[i] & 0xE3) | 0x0C

    with open(output_file, "wb") as outfile:
        outfile.write(data)  # Write modified data back to file

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: set_map_to_palette_4.py <input_file> <output_file>", file=sys.stderr)
        sys.exit(1)

    modify_file(sys.argv[1], sys.argv[2])
