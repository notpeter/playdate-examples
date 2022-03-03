
import "CoreLibs/graphics"

local gfx = playdate.graphics

i = gfx.image.new('assets/jump'):scaledImage(4)

local dithers = 
{
	gfx.image.kDitherTypeNone,
	gfx.image.kDitherTypeDiagonalLine,
	gfx.image.kDitherTypeVerticalLine,
	gfx.image.kDitherTypeHorizontalLine,
	gfx.image.kDitherTypeScreen,
	gfx.image.kDitherTypeBayer2x2,
	gfx.image.kDitherTypeBayer4x4,
	gfx.image.kDitherTypeBayer8x8,
	gfx.image.kDitherTypeFloydSteinberg,
	gfx.image.kDitherTypeBurkes,
	gfx.image.kDitherTypeAtkinson
}

local ditherNames = 
{
	"gfx.image.kDitherTypeNone",
	"gfx.image.kDitherTypeDiagonalLine",
	"gfx.image.kDitherTypeVerticalLine",
	"gfx.image.kDitherTypeHorizontalLine",
	"gfx.image.kDitherTypeScreen",
	"gfx.image.kDitherTypeBayer2x2",
	"gfx.image.kDitherTypeBayer4x4",
	"gfx.image.kDitherTypeBayer8x8",
	"gfx.image.kDitherTypeFloydSteinberg",
	"gfx.image.kDitherTypeBurkes",
	"gfx.image.kDitherTypeAtkinson"
}


d = 1

local colors =
{
	gfx.kColorWhite,
	gfx.kColorBlack
}

c = 1
gfx.setBackgroundColor(colors[c])

function draw(dither)

	gfx.clear()
	
	i:draw(200-32, 120-64)

	local one = i:blurredImage(10, 2, dither, false)
	one:draw(100-32, 120-64)

	local two = i:blurredImage(10, 2, dither, true)
	two:draw(300-32-10, 120-64-10)

	gfx.setColor(colors[3-c])
	
	local w,h = one:getSize()
	gfx.drawRect(100-32-1, 120-64-1, w+2, h+2)
	
	w,h = two:getSize()
	gfx.drawRect(300-32-10-1, 120-64-10-1, w+2, h+2)
	
	gfx.setImageDrawMode(gfx.kDrawModeNXOR)
	gfx.drawTextAligned(ditherNames[d], 200, 14, kTextAlignment.center)
	
	gfx.drawTextAligned("A: change dither type   B: change background color", 200, 214, kTextAlignment.center)

end

draw(dithers[d])

function playdate.AButtonDown()
	d = (d % #dithers) + 1
	draw(dithers[d])
end

function playdate.BButtonDown()

	c = 3 - c
	gfx.setBackgroundColor(colors[c])

	draw(dithers[d])

end


function playdate.update()
end

