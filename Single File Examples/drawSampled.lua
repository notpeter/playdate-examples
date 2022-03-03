
gfx = playdate.graphics

im = gfx.image.new('assets/jump')

t = 0

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0,0,400,240)

gfx.setImageDrawMode(gfx.kDrawModeNXOR)

function playdate.update()

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0,0,400,240)

t = t + 0.05

im:drawSampled(0, 0, 400, 240,  -- x, y, width, height
				0.5, 0.5, -- center x, y
				math.cos(t) / (3 + math.sin(t)), math.sin(t) / (3 + math.sin(t)), -- dxx, dyx
				-math.sin(t) / (3 + math.sin(t)), math.cos(t) / (3 + math.sin(t)), -- dxy, dyy
				0, 0, -- dx, dy
				100, -- z
				t * 5, -- tilt angle
				false); -- tile

end
