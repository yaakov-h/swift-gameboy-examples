import _Volatile

typealias GBCoordinate = Int
typealias GBColor = UInt16
typealias GBVRAM = UnsafeMutableBufferPointer<UInt16>

@main struct Game {
    static func main() {
        let io = VolatileMappedRegister<UInt32>(unsafeBitPattern: 0x4000000)

        let vram = GBVRAM(
            start: UnsafeMutablePointer<UInt16>(bitPattern: 0x6000000),
            count: 0xc000
        )

        // Set bitmap video mode and enable background rendering
        io.store(0b10000000011)

        // Draw a gradient
        for x in 0..<240 {
            for y in 0..<160 {
                drawPixel(vram, x, y, 0x00, 0x78, 0xD7)
            }
        }

        drawSmiley(vram, 16, 18, 0xFF, 0xFF, 0xFF)
        drawText(vram, 16, 50, "Your PC ran into a problem and needs to restart.", 0xFF, 0xFF, 0xFF)

        drawQrCode(vram, 16, 100, 0xFF, 0xFF, 0xFF)

        while true {}
    }
}

func drawText(_ vram: GBVRAM, _ x: GBCoordinate, _ y: GBCoordinate, _ text: String, _ red: GBColor, _ green: GBColor, _ blue: GBColor) {
    var offset = 0

    for letter in text.unicodeScalars {
        let value = UInt8(ascii: letter)
        offset += drawLetter(vram, x + offset, y, value, red, green, blue)
        offset += 1
    }
}

func drawSmiley(_ vram: UnsafeMutableBufferPointer<UInt16>, _ x: GBCoordinate, _ y: GBCoordinate,  _ red: GBColor, _ green: GBColor, _ blue: GBColor) {
        drawPixelsSquare(vram, x...(x + 2), (y + 5)...(y + 7), red, green, blue)
        drawPixelsSquare(vram, x...(x + 2), 40...42, red, green, blue)

        drawPixelsVertical(vram, x + 8, (y + 9)...(y + 20), red, green, blue)
        drawPixelsVertical(vram, x + 9, (y + 6)...(y + 23), red, green, blue)

        drawPixelsVertical(vram, x + 10, (y + 4)...(y + 8), red, green, blue)
        drawPixelsVertical(vram, x + 10, (y + 21)...(y + 25), red, green, blue)

        drawPixelsVertical(vram, x + 11, (y + 2)...(y + 5), red, green, blue)
        drawPixelsVertical(vram, x + 11, (y + 24)...(y + 27), red, green, blue)

        drawPixelsVertical(vram, x + 12, (y + 1)...(y + 2), red, green, blue)
        drawPixelsVertical(vram, x + 12, (y + 27)...(y + 28), red, green, blue)

        drawPixelsVertical(vram, x + 13, y...(y + 1), red, green, blue)
        drawPixelsVertical(vram, x + 13, (y + 28)...(y + 29), red, green, blue)
}

func drawQrCode(_ vram: UnsafeMutableBufferPointer<UInt16>, _ x: GBCoordinate, _ y: GBCoordinate,  _ r: GBColor, _ g: GBColor, _ b: GBColor) {
    drawQrCodeTargetSquare(vram, x, y, r, g, b)
    drawQrCodeTargetSquare(vram, x, y + 14, r, g, b)
    drawQrCodeTargetSquare(vram, x + 14, y, r, g, b)

    drawPixel(vram, x + 8, y, r, g, b)
    drawPixel(vram, x + 9, y, r, g, b)
    drawPixel(vram, x + 9, y + 1, r, g, b)
    drawPixel(vram, x + 8, y + 2, r, g, b)
    drawPixel(vram, x + 9, y + 2, r, g, b)
    drawPixel(vram, x + 10, y + 2, r, g, b)
    drawPixel(vram, x + 12, y + 2, r, g, b)
    drawPixel(vram, x + 8, y + 3, r, g, b)
    drawPixel(vram, x + 10, y + 3, r, g, b)
    drawPixel(vram, x + 11, y + 3, r, g, b)
    drawPixel(vram, x + 8, y + 4, r, g, b)
    drawPixel(vram, x + 9, y + 4, r, g, b) 
    drawPixel(vram, x + 11, y + 4, r, g, b)
    drawPixel(vram, x + 12, y + 4, r, g, b)
    drawPixel(vram, x + 9, y + 5, r, g, b)
    drawPixel(vram, x + 10, y + 5, r, g, b)
    drawPixel(vram, x + 8, y + 6, r, g, b)
    drawPixel(vram, x + 10, y + 6, r, g, b)
    drawPixel(vram, x + 12, y + 6, r, g, b)
    drawPixel(vram, x + 11, y + 7, r, g, b)
    drawPixel(vram, x + 12, y + 7, r, g, b)

    drawPixel(vram, x, y + 8, r, g, b)
    drawPixel(vram, x + 1, y + 8, r, g, b)
    drawPixel(vram, x + 2, y + 8, r, g, b)
    drawPixel(vram, x + 3, y + 8, r, g, b)
    drawPixel(vram, x + 6, y + 8, r, g, b)
    drawPixel(vram, x + 8, y + 8, r, g, b)
    drawPixel(vram, x + 10, y + 8, r, g, b)
    drawPixel(vram, x + 11, y + 8, r, g, b)
    drawPixel(vram, x + 13, y + 8, r, g, b)
    drawPixel(vram, x + 16, y + 8, r, g, b)
    drawPixel(vram, x + 17, y + 8, r, g, b)
    drawPixel(vram, x + 18, y + 8, r, g, b)
    drawPixel(vram, x + 20, y + 8, r, g, b)

    drawPixel(vram, x, y + 9, r, g, b)
    drawPixel(vram, x + 1, y + 9, r, g, b)
    drawPixel(vram, x + 2, y + 9, r, g, b)
    drawPixel(vram, x + 5, y + 9, r, g, b)
    drawPixel(vram, x + 11, y + 9, r, g, b)
    drawPixelsHorizontal(vram, (x + 13)...(x + 21), y + 9, r, g, b)

    drawPixel(vram, x, y + 10, r, g, b)
    drawPixelsHorizontal(vram, (x + 4)...(x + 8), y + 10, r, g, b)
    drawPixel(vram, x + 10, y + 10, r, g, b)
    drawPixel(vram, x + 13, y + 10, r, g, b)
    drawPixel(vram, x + 17, y + 10, r, g, b)
    drawPixel(vram, x + 19, y + 10, r, g, b)
    drawPixel(vram, x + 20, y + 10, r, g, b)

    drawPixel(vram, x + 2, y + 11, r, g, b)
    drawPixel(vram, x + 4, y + 11, r, g, b)
    drawPixelsHorizontal(vram, (x + 9)...(x + 12), y + 11, r, g, b)
    drawPixel(vram, x + 15, y + 11, r, g, b)
    drawPixel(vram, x + 17, y + 11, r, g, b)
    drawPixel(vram, x + 19, y + 11, r, g, b)

    drawPixel(vram, x + 1, y + 12, r, g, b)
    drawPixel(vram, x + 3, y + 12, r, g, b)
    drawPixel(vram, x + 5, y + 12, r, g, b)
    drawPixel(vram, x + 6, y + 12, r, g, b)
    drawPixelsHorizontal(vram, (x + 9)...(x + 11), y + 12, r, g, b)
    drawPixelsHorizontal(vram, (x + 13)...(x + 14), y + 12, r, g, b)
    drawPixelsHorizontal(vram, (x + 16)...(x + 17), y + 12, r, g, b)
    drawPixel(vram, x + 20, y + 12, r, g, b)

    drawPixel(vram, x + 8, y + 13, r, g, b)
    drawPixelsHorizontal(vram, (x + 11)...(x + 12), y + 13, r, g, b)
    drawPixel(vram, x + 16, y + 13, r, g, b)

    drawPixel(vram, x + 11, y + 14, r, g, b)
    drawPixel(vram, x + 16, y + 14, r, g, b)

    drawPixel(vram, x + 11, y + 15, r, g, b)
    drawPixel(vram, x + 13, y + 15, r, g, b)
    drawPixelsHorizontal(vram, (x + 15)...(x + 19), y + 15, r, g, b)

    drawPixelsHorizontal(vram, (x + 9)...(x + 12), y + 16, r, g, b)
    drawPixel(vram, x + 16, y + 16, r, g, b)
    drawPixel(vram, x + 18, y + 16, r, g, b)
    drawPixel(vram, x + 20, y + 16, r, g, b)

    drawPixel(vram, x + 8, y + 17, r, g, b)
    drawPixel(vram, x + 10, y + 17, r, g, b)
    drawPixelsHorizontal(vram, (x + 12)...(x + 13), y + 17, r, g, b)
    drawPixel(vram, x + 15, y + 17, r, g, b)

    drawPixel(vram, x + 8, y + 18, r, g, b)
    drawPixelsHorizontal(vram, (x + 11)...(x + 13), y + 18, r, g, b)
    drawPixel(vram, x + 15, y + 18, r, g, b)
    drawPixel(vram, x + 18, y + 18, r, g, b)

    drawPixelsHorizontal(vram, (x + 8)...(x + 10), y + 19, r, g, b)
    drawPixelsHorizontal(vram, (x + 13)...(x + 16), y + 19, r, g, b)
    drawPixel(vram, x + 20, y + 19, r, g, b)

    drawPixel(vram, x + 8, y + 20, r, g, b)
    drawPixel(vram, x + 10, y + 20, r, g, b)
    drawPixelsHorizontal(vram, (x + 13)...(x + 14), y + 20, r, g, b)
    drawPixelsHorizontal(vram, (x + 16)...(x + 17), y + 20, r, g, b)
}

func drawQrCodeTargetSquare(_ vram: GBVRAM, _ x: GBCoordinate, _ y: GBCoordinate,  _ r: GBColor, _ g: GBColor, _ b: GBColor) {
    drawPixelsHorizontal(vram, x...(x + 6), y, r, g, b)
    drawPixelsVertical(vram, x, (y + 1)...(y + 5), r, g, b)
    drawPixelsVertical(vram, x + 6, (y + 1)...(y + 5), r, g, b)
    drawPixelsHorizontal(vram, x...(x + 6), y + 6, r, g, b)

    drawPixelsSquare(vram, (x + 2)...(x + 4), (y + 2)...(y + 4), r, g, b)
}

func drawLetter(_ vram: GBVRAM, _ x: GBCoordinate, _ y: GBCoordinate, _ letter: UInt8,  _ r: GBColor, _ g: GBColor, _ b: GBColor) -> Int {
    switch (letter) {
        case UInt8(ascii: " "):
            return 2

        case UInt8(ascii: "."):
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 3, r, g, b)
            drawPixel(vram, x, y + 4, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            return 2

        case UInt8(ascii: "C"):
            drawPixel(vram, x + 1, y, r, g, b)
            drawPixel(vram, x + 2, y, r, g, b)
            drawPixel(vram, x + 3, y, r, g, b)
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 4, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 4, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            drawPixel(vram, x + 3, y + 4, r, g, b)
            return 5

        case UInt8(ascii: "P"):
            drawPixel(vram, x, y, r, g, b)
            drawPixel(vram, x + 1, y, r, g, b)
            drawPixel(vram, x + 2, y, r, g, b)
            drawPixel(vram, x + 3, y, r, g, b)
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 4, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 1, y + 2, r, g, b)
            drawPixel(vram, x + 2, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x, y + 4, r, g, b)
            return 5

        case UInt8(ascii: "Y"):
            drawPixel(vram, x, y, r, g, b)
            drawPixel(vram, x + 4, y, r, g, b)
            drawPixel(vram, x + 1, y + 1, r, g, b)
            drawPixel(vram, x + 3, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 2, r, g, b)
            drawPixel(vram, x + 2, y + 3, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            return 5

        case UInt8(ascii: "a"):
            drawPixel(vram, x, y, r, g, b)
            drawPixel(vram, x + 1, y, r, g, b)
            drawPixel(vram, x + 2, y, r, g, b)
            drawPixel(vram, x + 3, y + 1, r, g, b)
            drawPixel(vram, x + 1, y + 2, r, g, b)
            drawPixel(vram, x + 2, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            drawPixel(vram, x + 3, y + 4, r, g, b)
            return 4

        case UInt8(ascii: "b"):
            drawPixel(vram, x, y - 1, r, g, b)
            drawPixel(vram, x, y, r, g, b)
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 1, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            return 4

        case UInt8(ascii: "d"):
            drawPixel(vram, x + 3, y - 1, r, g, b)
            drawPixel(vram, x + 3, y, r, g, b)
            drawPixel(vram, x + 1, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 1, r, g, b)
            drawPixel(vram, x + 3, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            return 4

        case UInt8(ascii: "e"):
            drawPixel(vram, x + 1, y, r, g, b)
            drawPixel(vram, x + 2, y, r, g, b)
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 3, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 1, y + 2, r, g, b)
            drawPixel(vram, x + 2, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            drawPixel(vram, x + 3, y + 4, r, g, b)
            return 4

        case UInt8(ascii: "i"):
            drawPixel(vram, x, y, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x, y + 4, r, g, b)
            return 1

        case UInt8(ascii: "m"):
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 1, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 1, r, g, b)
            drawPixel(vram, x + 4, y + 1, r, g, b)
            drawPixel(vram, x + 5, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x + 6, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x + 6, y + 3, r, g, b)
            drawPixel(vram, x, y + 4, r, g, b)
            drawPixel(vram, x + 3, y + 4, r, g, b)
            drawPixel(vram, x + 6, y + 4, r, g, b)
            return 7;

        case UInt8(ascii: "n"):
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 1, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x, y + 4, r, g, b)
            drawPixel(vram, x + 3, y + 4, r, g, b)
            return 4

        case UInt8(ascii: "l"):
            drawPixelsVertical(vram, x, (y-1)...(y+4), r, g, b)
            return 1

        case UInt8(ascii: "o"):
            drawPixel(vram, x + 1, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            return 4

        case UInt8(ascii: "p"):
            drawPixel(vram, x + 1, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            drawPixel(vram, x, y + 4, r, g, b)
            drawPixel(vram, x, y + 5, r, g, b)
            drawPixel(vram, x, y + 6, r, g, b)
            return 4

        case UInt8(ascii: "r"):
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 1, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x, y + 4, r, g, b)
            return 4

        case UInt8(ascii: "s"):
            drawPixel(vram, x + 1, y, r, g, b)
            drawPixel(vram, x + 2, y, r, g, b)
            drawPixel(vram, x + 3, y, r, g, b)
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 1, y + 2, r, g, b)
            drawPixel(vram, x + 2, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x, y + 4, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            return 4

        case UInt8(ascii: "t"):
            drawPixel(vram, x + 1, y, r, g, b)
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 1, y + 1, r, g, b)
            drawPixel(vram, x + 2, y + 1, r, g, b)
            drawPixel(vram, x + 1, y + 2, r, g, b)
            drawPixel(vram, x + 1, y + 3, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            return 3

        case UInt8(ascii: "u"):
            drawPixel(vram, x, y + 1, r, g, b)
            drawPixel(vram, x + 3, y + 1, r, g, b)
            drawPixel(vram, x, y + 2, r, g, b)
            drawPixel(vram, x + 3, y + 2, r, g, b)
            drawPixel(vram, x, y + 3, r, g, b)
            drawPixel(vram, x + 3, y + 3, r, g, b)
            drawPixel(vram, x + 1, y + 4, r, g, b)
            drawPixel(vram, x + 2, y + 4, r, g, b)
            drawPixel(vram, x + 3, y + 4, r, g, b)
            return 4

        default:
            // do nothing
            return 0
    }
}

func drawPixelsVertical(_ vram: GBVRAM, _ x: GBCoordinate, _ yRange : ClosedRange<GBCoordinate>, _ red: GBColor, _ green: GBColor, _ blue: GBColor) {
    for y in yRange {
        drawPixel(vram, x, y, red, blue, green)
    }
}

func drawPixelsHorizontal(_ vram: GBVRAM, _ xRange: ClosedRange<GBCoordinate>, _ y: GBCoordinate, _ red: GBColor, _ green: GBColor, _ blue: GBColor) {
    for x in xRange {
        drawPixel(vram, x, y, red, blue, green)
    }
}

func drawPixelsSquare(_ vram: GBVRAM, _ xRange: ClosedRange<GBCoordinate>, _ yRange : ClosedRange<GBCoordinate>, _ red: GBColor, _ green: GBColor, _ blue: GBColor) {
    for x in xRange {
        for y in yRange {
            drawPixel(vram, x, y, red, blue, green)
        }
    }
}

func drawPixel(_ vram: GBVRAM, _ x: GBCoordinate, _ y: GBCoordinate, _ red: GBColor, _ green: GBColor, _ blue: GBColor) {
    let redValue = UInt16(Float(red) / 255 * 31) & 0x1F
    let greenValue = UInt16(Float(green) / 255 * 31) & 0x1F
    let blueValue = UInt16(Float(blue) / 255 * 31) & 0x1F

    let color = redValue | (greenValue << 5) | (blueValue << 10)
    vram[x + y * 240] = color;
}

@_cdecl("__atomic_load_4")
func atomicLoad4(
    _ ptr: UnsafePointer<UInt32>,
    _ ordering: UInt32
) -> UInt32 {
    ptr.pointee
}

@_cdecl("__atomic_store_4")
func atomicStore4(
    _ ptr: UnsafeMutablePointer<UInt32>,
    _ value: UInt32,
    _ ordering: UInt32
) {
    ptr.pointee = value
}

@_cdecl("__atomic_store_2")
func atomicStore2(
    _ ptr: UnsafeMutablePointer<UInt16>,
    _ value: UInt16,
    _ ordering: UInt32
) {
    ptr.pointee = value
}

@_cdecl("__atomic_fetch_add_4")
func atomicFetchAdd4(
    _ ptr: UnsafeMutablePointer<UInt32>,
    _ value: UInt32,
    _ ordering: UInt32
) -> UInt32 {
    let tmp = ptr.pointee
    ptr.pointee += value
    return tmp
}

@_cdecl("__atomic_fetch_sub_4")
func atomicFetchSub4(
    _ ptr: UnsafeMutablePointer<UInt32>,
    _ value: UInt32,
    _ ordering: UInt32
) -> UInt32 {
    let tmp = ptr.pointee
    ptr.pointee -= value
    return tmp
}

@_cdecl("__atomic_compare_exchange_4")
func atomicCompareExchange4(
    _ ptr: UnsafeMutablePointer<UInt32>,
    _ expected: UnsafeMutablePointer<UInt32>,
    _ desired: UInt32,
    _ isWeak: Bool,
    _ successOrdering: UInt32,
    _ failureOrdering: UInt32
) -> Bool {
    if ptr.pointee == expected.pointee {
        ptr.pointee = desired
        return true
    } else {
        expected.pointee = ptr.pointee
        return false
    }
}
