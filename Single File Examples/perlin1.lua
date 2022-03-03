
gfx = playdate.graphics

local s,ms = playdate.getSecondsSinceEpoch()
math.randomseed(ms,s)

local perlin_x = math.random() * 100
local scale = 6

function lerp(minVal, maxVal, f)
	-- Linear interpolate.  perlin_lerp(0, 255, 0.5) == 127.5
	return minVal + f * (maxVal - minVal)
end

function playdate.update()

    gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, 400, 240)

    gfx.setColor(gfx.kColorBlack)

	local px = perlin_x
	local x
	
    for x = 0, 399 do
        px += 0.1
        local p = gfx.perlin(px / scale, 0, 0, 0, 6, 0.4)
        gfx.drawPixel(x, lerp(-40 , 40 + 239, p))
    end

    perlin_x += 0.1
    
end
