const parseHexList = (hexString) => 
    hexString.split(',').map(hex => parseInt(hex.trim(), 16));
  
const parseSNESColor = (num) => [
    (num & 0x1F),
    ((num >> 5) & 0x1F),
    ((num >> 10) & 0x1F)
  ];

const packSNESColor = (r, g, b) => (b << 10) | (g << 5) | r;

const toHex = (num) => num.toString(16).toUpperCase();

function FadePalette(in_palette) {
    pallet_step_0 = [];
    pallet_step_1 = [];
    pallet_step_2 = [];
    pallet_step_3 = [];
    for( let i = 0; i < in_palette.length; i+=2 ) {
        let packedColor = in_palette[i+1]<<8 | in_palette[i];

        pallet_step_0[i] = toHex(in_palette[i])
        pallet_step_0[i+1] = toHex(in_palette[i+1])
        
        let unpackedColor = parseSNESColor(packedColor);
        unpackedColor[0] = parseInt(unpackedColor[0]*(2/3) + targetColor[0]*(1/3))
        unpackedColor[1] = parseInt(unpackedColor[1]*(2/3) + targetColor[1]*(1/3))
        unpackedColor[2] = parseInt(unpackedColor[2]*(2/3) + targetColor[2]*(1/3))

        packed_new_color = packSNESColor(unpackedColor[0], unpackedColor[1], unpackedColor[2]);
        pallet_step_1[i] = toHex(packed_new_color&0xFF)
        pallet_step_1[i+1] = toHex((packed_new_color>>8)&0xFF)

        unpackedColor = parseSNESColor(packedColor);
        unpackedColor[0] = parseInt(unpackedColor[0]*(1/3) + targetColor[0]*(2/3))
        unpackedColor[1] = parseInt(unpackedColor[1]*(1/3) + targetColor[1]*(2/3))
        unpackedColor[2] = parseInt(unpackedColor[2]*(1/3) + targetColor[2]*(2/3))

        packed_new_color = packSNESColor(unpackedColor[0], unpackedColor[1], unpackedColor[2]);
        pallet_step_2[i] = toHex(packed_new_color&0xFF)
        pallet_step_2[i+1] = toHex((packed_new_color>>8)&0xFF)

        pallet_step_3[i] = toHex(targetPalette[i])
        pallet_step_3[i+1] = toHex(targetPalette[i+1])
    }
    console.log( pallet_step_0.join(', $'));
    console.log( pallet_step_1.join(', $'));
    console.log( pallet_step_2.join(', $'));
    console.log( pallet_step_3.join(', $'));
}

const targetColor = [31, 31, 22];
const targetPalette = parseHexList("FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5, FF, B5");
// PAL_SGB2 data
const input1 = "00, 7C, 2A, 1D, 8D, 29, 87, 1D, 09, 26, 8F, 3A, AB, 45, F0, 35, 0C, 4E, 4D, 52, 50, 56, B3, 62, 52, 46, 94, 4E, 56, 45, F7, 5E";
const input2 = "00, 7C, 2A, 1D, 8D, 29, 87, 1D, 09, 26, 8F, 3A, 4D, 52, CB, 4D, 0C, 4E, AB, 45, F7, 5E, B3, 62, 52, 42, 52, 52, 94, 56, 50, 56";
const palette = parseHexList(input2);
FadePalette(palette);
//console.log(output); // [10, 255, 28, 43]
  