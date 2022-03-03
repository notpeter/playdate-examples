
local gfx = playdate.graphics

local x = 0
local dx = 0.05

local points = {}
local npoints = 1

playdate.display.setRefreshRate(0)

for i=1,npoints do
	points[i] = { math.random(), math.random() }
end

local z = 0
local dz = 0.01

local speed = 0.1

	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, 400, 240)

	gfx.setColor(gfx.kColorBlack)

function playdate.update()

	for i=1,npoints do
		local p = points[i]
		local x,y = p[1], p[2]
		
		local dx = gfx.perlin(x,y,x+y+z, 0, 5, 0.8) - 0.5
		local dy = gfx.perlin(x,y,x+y+z+1, 0, 5, 0.8) - 0.5
		
		x += dx * speed
		y += dy * speed
		
		if x < 0 then x += 1 elseif x >= 1 then x -= 1 end
		if y < 0 then y += 1 elseif y >= 1 then y -= 1 end
				
		gfx.drawPixel(400*x, 240*y)

		points[i] = {x,y}

	end
	
	z += dz
end

function playdate.AButtonDown()
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, 400, 240)
	gfx.setColor(gfx.kColorBlack)
end