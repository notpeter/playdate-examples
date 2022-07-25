
-- Accellerometer-controlled synth

gfx = playdate.graphics
gfx.clear(gfx.kColorBlack)
gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
gfx.drawText("Hold A to play sounds", 95, 90)
gfx.drawText("Tilt device to change tone", 94, 120)


local snd = playdate.sound

-- these generators have adjustable parameters:
--s = snd.synth.new(snd.kWaveSquare)
s = snd.synth.new(snd.kWavePOPhase)
--s = snd.synth.new(snd.kWavePODigital)
--s = snd.synth.new(snd.kWavePOVosim)

playdate.startAccelerometer()

local x,y = playdate.readAccelerometer()
local p1, p2

s:setDecay(0.5)
s:setSustain(0.6)
s:setRelease(1.0)

function updateparams()
	local x,y = playdate.readAccelerometer()
	local n1 = (x+1)/2
	local n2 = (y+1)/2

	if n1 ~= p1 then s:setParameter(0,n1) p1 = n1 end
	if n2 ~= p2 then s:setParameter(1,n2) p2 = n2 end
end

function playdate.update()
	updateparams()
end

function playdate.AButtonDown()
	s:playNote(200)
	updateparams()
end

function playdate.AButtonUp()
	s:noteOff()
end
