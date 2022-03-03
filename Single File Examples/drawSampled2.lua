
gfx = playdate.graphics

im = gfx.image.new('assets/jump')

t = 0
x = 0

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0,0,400,240)

--gfx.setImageDrawMode(gfx.kDrawModeNXOR)

function playdate.update()

	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0,0,400,240)

	t = t + 0.05

	if leftDown then x = x - 0.3 end
	if rightDown then x = x + 0.3 end

	im:drawSampled(0, 0, 400, 240,  -- x, y, width, height
				0.5, 0, -- center x, y
				1, 0, -- dxx, dyx
				0, 1, -- dxy, dyy
				x, -3 * t, -- dx, dy
				100, -- z
				1.2, -- tilt angle
				true); -- tile

end

function playdate.leftButtonDown()
  leftDown = true
end

function playdate.leftButtonUp()
  leftDown = false
end

function playdate.rightButtonDown()
  rightDown = true
end

function playdate.rightButtonUp()
  rightDown = false
end
