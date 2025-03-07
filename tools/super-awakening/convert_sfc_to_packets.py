# Script to convert an .sfc file into packet chunks for sending to SGB

def print_hexadecimal(file_path, skip_bytes=18, bytes_per_line=11):
    try:
        with open(file_path, 'rb') as file:
            # Skip the specified number of bytes
            file.seek(skip_bytes)

            # Read the remaining content of the file
            file_content = file.read()

            # Initialize a counter for zero readings
            zero_count = 0

            total_packets = 0

            # Convert each byte to hexadecimal and print with line breaks
            print("Awakening_Patch_Data:");
            print(f"Awakening_Patch_Data_0:")
            print("\tsgb_data_send_cmd $0000, $7F, 11")
            print("\tdb $", end='')
            for i, byte in enumerate(file_content, start=1):
                
                print(format(byte, '02x'), end='')

                # Check if the byte is zero
                if byte == 0:
                    zero_count += 1

                    # Stop the loop when zero is read three times
                    if zero_count == 3:
                        break
                else:
                    # Reset the zero count if a non-zero byte is encountered
                    zero_count = 0

                # Add a line break after every specified number of bytes
                if i % bytes_per_line == 0:
                    total_packets += 1
                    print()
                    print(f"Awakening_Patch_Data_{total_packets}:")
                    offset = f"{i:x}"
                    print(f"\tsgb_data_send_cmd ${f'{i:x}'.zfill(4)}, $7F, 11")
                    print("\tdb $", end='')
                else: 
                    print(", $", end='')

            if i % bytes_per_line != 0:
                total_packets += 1
                for c in range(0, bytes_per_line- (i % bytes_per_line) ):
                    print(", $00", end='')

                
            print()
            print()
            print(f"AWAKENING_LOAD_PACKETS = {total_packets}")


    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

file_path = 'snes_injection_data.smc'
skip_bytes = 0
bytes_per_line = 11

print_hexadecimal(file_path, skip_bytes, bytes_per_line)
