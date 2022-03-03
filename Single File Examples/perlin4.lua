
gfx = playdate.graphics

-- local patterns = gfx.imagetable.new('assets/pattern')
local patterns = gfx.imagetable.new('assets/patterns')
local s,ms = playdate.getSecondsSinceEpoch()
math.randomseed(ms,s)

local perlin_x = math.random() * 100
local perlin_y = math.random() * 100
local perlin_z = math.random() * 100

function lerp(minVal, maxVal, f)
	-- Linear interpolate.  perlin_lerp(0, 255, 0.5) == 127.5
	return minVal + f * (maxVal - minVal)
end

local x,y

	    gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 0, 400, 240)

function playdate.update()

	    gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 0, 400, 240)

    gfx.setColor(gfx.kColorBlack)

    local py = perlin_y

    for y = 0, 239, 8 do

	    local px = perlin_x

	    py += 0.2

	    for x = 0, 399, 8 do
	        px += 0.2
	        local p = gfx.perlin(px, py, perlin_z, 0)

	        patterns[math.floor(p * 65)+1]:draw(x,y)
	    end

    end

--	    perlin_x += 0.1
--	    perlin_y += 0.1
	    perlin_z += 0.1

end
