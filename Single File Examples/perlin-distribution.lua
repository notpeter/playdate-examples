
local gfx = playdate.graphics

bins = {}

function resetbins()
	for i=1,100 do
		bins[i] = 0
	end
end

resetbins()

local iterations = 1000
local octaves = 1
local persistence = 0.3
local dims = 1

function playdate.update()

	if dims == 1 then
		for i=1,iterations do
			v = gfx.perlin(100*math.random(), 0, 0, 0, octaves, persistence)
			bins[math.floor(#bins*v)+1] += 1
		end
	elseif dims == 2 then
		for i=1,iterations do
			v = gfx.perlin(100*math.random(), 100*math.random(), 0, 0, octaves, persistence)
			bins[math.floor(#bins*v)+1] += 1
		end
	else
		for i=1,iterations do
			v = gfx.perlin(100*math.random(), 100*math.random(), 100*math.random(), 0, octaves, persistence)
			bins[math.floor(#bins*v)+1] += 1
		end
	end		
	
	local max = 0
	
	for i=1,#bins do
		if bins[i] > max then max = bins[i] end
	end
	
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, 400, 240)
	
	if dims == 1 then
		gfx.drawText("perlin(x)", 10, 10)
	elseif dims == 2 then
		gfx.drawText("perlin(x,y)", 10, 10)
	else
		gfx.drawText("perlin(x,y,z)", 10, 10)
	end
	
	gfx.drawText("octaves: "..tostring(octaves), 10, 30)
	
	if octaves > 1 then
		gfx.drawText("persistence: "..tostring(persistence), 10, 50)
	end
	
	gfx.setColor(gfx.kColorBlack)

	for i=2,#bins do
		gfx.drawLine((i-2)*400/#bins, 240-240*bins[i-1]/max, (i-1)*400/#bins, 240-240*bins[i]/max)
	end
end

function playdate.upButtonDown()
	octaves += 1
	resetbins()
end

function playdate.downButtonDown()
	if octaves > 1 then
		octaves -= 1
		resetbins()
	end
end

function playdate.rightButtonDown()
	if persistence < 1.0 then
		persistence += 0.1
		resetbins()
	end
end

function playdate.leftButtonDown()
	if persistence > 0 then
		persistence -= 0.1
		resetbins()
	end
end

function playdate.AButtonDown()
	dims = (dims%3) + 1
	resetbins()
end