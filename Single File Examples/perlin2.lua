
gfx = playdate.graphics

local s,ms = playdate.getSecondsSinceEpoch()
math.randomseed(ms,s)

local perlin_x = math.random() * 100
local perlin_y = math.random() * 100
local scale = 6

function lerp(minVal, maxVal, f)
	-- Linear interpolate.  perlin_lerp(0, 255, 0.5) == 127.5
	return minVal + f * (maxVal - minVal)
end

local y = 220

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, 400, 240)

function playdate.update()

	if y == -220 then
	    gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 0, 400, 240)
		y = 220
	end
	
    gfx.setColor(gfx.kColorBlack)
    
    last_perlin_x = perlin_x
    last_perlin_y = perlin_y
    
    for x = 0, 399 do
        perlin_x = perlin_x + 0.1
        local p = gfx.perlin(perlin_x / scale, perlin_y / scale, 0, 0, 6, 0.4)
        gfx.drawPixel(x, y + lerp(-40 , 40 + 239, p) / 2)
    end
    
    y -= 2
    
    perlin_x = last_perlin_x + 0.1
    perlin_y = last_perlin_y + 0.1
end
