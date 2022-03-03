
-- for img.width shortcut
import 'CoreLibs/graphics.lua'

gfx = playdate.graphics

gfx.setPattern({0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55})
gfx.fillRect(0,0,400,240)

img = gfx.image.new('assets/ball')

-- draw image and mask by sampling pixels

for y= 0, img.height-1
do
	for x= 0, img.width-1
	do
		if img:sample(x,y) == gfx.kColorWhite then
			gfx.setColor(gfx.kColorWhite)
		else
			gfx.setColor(gfx.kColorBlack)
		end

		gfx.fillRect(80 + 5*x, 60 + 5*y, 5, 5)

		if img:sample(x,y) == gfx.kColorClear then
			gfx.setColor(gfx.kColorBlack)
		else
			gfx.setColor(gfx.kColorWhite)
		end

		gfx.fillRect(220+5*x, 60 + 5*y, 5, 5)
	end
end


function playdate.update()
end


playdate.stop()
