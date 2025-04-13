from PIL import Image


file_name = 'cracked-0'
path = './src/super-awakening/snes/gfx/border-cracked'
in_file = f'{path}/{file_name}.png'
out_file = f'{path}/{file_name}.4bpp'

image = Image.open(in_file).convert('RGB')  # Ensure it's in RGB mode

width, height = image.size

tile_pallet_map = [
    [1, 1, 1],
    [1, 0, 0],
    [0, 0, 0]
]

palettes = [
    [
        [0,0,255],
        [82, 74, 57],
        [107, 99, 82],
        [57, 99, 57],
        [74, 132, 74],
        [123, 165, 115],
        [90, 107, 140],
        [132, 123, 107],
        [99, 132, 156],
        [107, 148, 165],
        [132, 148, 173],
        [156, 173, 198],
        [148, 148, 140],
        [165, 165, 156],
        [181, 82, 140],
        [189, 189, 189]
    ],
    [
        [0,0,255],
        [82, 74, 57],
        [107, 99, 82],
        [57, 99, 57],
        [74, 132, 74],
        [123, 165, 115],
        [107, 148, 165],
        [90, 115, 156],
        [99, 132, 156],
        [90, 107, 140],
        [189, 189, 189],
        [156, 173, 198],
        [148, 148, 132],
        [148, 148, 165],
        [165, 165, 173],
        [132, 148, 173]
    ]
]

def main():
    all_bytes = []
    validate_all_tile_pixels()
    all_bytes.extend(create_tile([0,0]))
    all_bytes.extend(create_tile([0,1]))
    all_bytes.extend(create_tile([0,2]))
    all_bytes.extend(create_tile([1,0]))
    all_bytes.extend(create_tile([1,1]))
    all_bytes.extend(create_tile([1,2]))
    all_bytes.extend(create_tile([2,0]))
    all_bytes.extend(create_tile([2,1]))
    all_bytes.extend(create_tile([2,2]))

    with open(out_file, 'wb') as f:
        f.write(bytearray(all_bytes))


def get_pallet_index_from_pixel(pixel, palette):
    for p in range(len(palette)):
        if( pixel[0] == palette[p][0] and pixel[1] == palette[p][1] and pixel[2] == palette[p][2] ):
            return p
    raise Exception(f'Pixel not found in palette')

def get_pallet_from_tile(tile, tile_pallet_map):
    return tile_pallet_map[tile[0]][tile[1]]


def validate_all_tile_pixels():
    # Loop over every pixel
    tile = [0, 0]
    for y in range(height):
        for x in range(width):
            tile[0] = (int)(y/8)
            tile[1] = (int)(x/8)
            try:
                current_palette_number = get_pallet_from_tile(tile, tile_pallet_map)
                current_palette = palettes[current_palette_number]
                pixel = image.getpixel((x, y))
                palette_index = get_pallet_index_from_pixel(pixel, current_palette)
                #print(f'Pixel at ({tile[1]}, {tile[0]}) ({x}, {y}): R={pixel[0]}, G={pixel[1]}, B={pixel[2]}')
            except:
                print(f'Pixel not found at ({tile[1]}, {tile[0]}) ({x}, {y}): R={pixel[0]}, G={pixel[1]}, B={pixel[2]}')
                raise Exception(f'Pixel not found in palette')

    print(f'All tile pixel valid')

def create_tile(tile):
    
    row_bytes_high = []
    row_bytes_low = []
    for y in range(0,8):
        row_bytes = [0,0,0,0]
        for x in range(0,8):
            pixel_y = tile[0]*8 + y
            pixel_x = tile[1]*8 + x
            current_palette_number = get_pallet_from_tile(tile, tile_pallet_map)
            current_palette = palettes[current_palette_number]
            pixel = image.getpixel((pixel_x, pixel_y))
            palette_index = get_pallet_index_from_pixel(pixel, current_palette)
            
            row_bytes[0] = row_bytes[0] | (((palette_index & 0b0001) >> 0) << (7-x))
            row_bytes[1] = row_bytes[1] | (((palette_index & 0b0010) >> 1) << (7-x))
            row_bytes[2] = row_bytes[2] | (((palette_index & 0b0100) >> 2) << (7-x))
            row_bytes[3] = row_bytes[3] | (((palette_index & 0b1000) >> 3) << (7-x))

        row_bytes_low.append(row_bytes[0])
        row_bytes_low.append(row_bytes[1])
        row_bytes_high.append(row_bytes[2])
        row_bytes_high.append(row_bytes[3])

    all_bytes = []
    all_bytes.extend(row_bytes_low)
    all_bytes.extend(row_bytes_high)

    return all_bytes
    
main()