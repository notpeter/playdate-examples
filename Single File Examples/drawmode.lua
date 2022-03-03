
local gfx = playdate.graphics
local clock = gfx.image.new("assets/clock")
local im = gfx.image.new('assets/jump'):scaledImage(4,4)

modes = {"copy", "inverted", "XOR", "NXOR", "whiteTransparent", "blackTransparent", "fillWhite", "fillBlack"}
n = 1
mode = modes[n]

function redraw()
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
	clock:draw(0,0)
	gfx.drawText(mode, 10, 10)

	gfx.setImageDrawMode(mode)
	im:draw(260,60)
end

redraw()

function playdate.update()
end

function playdate.AButtonDown()
	n = n % #modes + 1
	mode = modes[n]
	print(mode)
	redraw()
end
