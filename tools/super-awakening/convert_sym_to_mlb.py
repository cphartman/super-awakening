import sys
import re

def convert_sym_to_mlb(input_file, output_file):
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        for line in infile:
            line = line.strip()
            if line.startswith(";") or not line:
                continue  # Skip comments and empty lines
            
            parts = line.split()
            if len(parts) < 2:
                continue  # Skip malformed lines
            
            bank_addr, label = parts[0], parts[1]
            if ":" not in bank_addr:
                continue  # Skip malformed lines
            
            bank_hex, addr_hex = bank_addr.split(":")

            bank = int(bank_hex, 16)
            addr = int(addr_hex, 16)
            label = re.sub("[.]", "_", label)
            if bank > 1:
                # Label addresses in the sym file are offset by 0x4000 to match the memory mapped layout
                addr = addr - 0x4000

                absolute_addr = (bank * 0x4000)+ addr

                outfile.write(f"GbPrgRom:{absolute_addr:05X}:{label}\n")

            if bank == 1 or bank == 0:
                outfile.write(f"GameboyMemory:{addr:05X}:{label}\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: convert_sym_to_mlb.py <input.sym> <output.mlb>", file=sys.stderr)
        sys.exit(1)
    
    convert_sym_to_mlb(sys.argv[1], sys.argv[2])
