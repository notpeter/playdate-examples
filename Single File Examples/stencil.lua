
local gfx = playdate.graphics

local ball = gfx.image.new('assets/ball')

gfx.setPattern({0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55})
gfx.fillRect(0,0,400,240)

local stencil = gfx.image.new(400, 240, gfx.kColorWhite)

gfx.lockFocus(stencil)
	gfx.setColor(gfx.kColorBlack)

	gfx.fillRect(50,0,20,240)
	gfx.fillRect(150,0,20,240)
	gfx.fillRect(250,0,20,240)
	gfx.fillRect(350,0,20,240)
gfx.unlockFocus()

gfx.setStencilImage(stencil)

local clock = gfx.image.new('assets/clock')
clock:draw(0,0, gfx.kImageFlippedX)

function playdate.update()

	gfx.setStencilImage(stencil)

	gfx.setColor(math.random(0,1))

	gfx.drawLine(math.random(0,400), math.random(0,240), math.random(0,400), math.random(0,240), 5)

	gfx.drawLine(math.random(0,400), math.random(0,240), math.random(0,400), math.random(0,240))

	gfx.drawEllipseInRect(math.random(-100,400), math.random(-100,240), math.random(0,100), math.random(0,100))

	ball:draw(math.random(0,400), math.random(0,240))
	ball:draw(math.random(0,400), math.random(0,240), gfx.kImageFlippedX)
end
