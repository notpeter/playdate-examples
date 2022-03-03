
playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
playdate.graphics.drawText("Press A or B to play sounds", 95, 100)

function playdate.update()
end

local snd = playdate.sound
local synth = snd.synth.new(snd.kWaveSawtooth)

--notes = { 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 25, 27, 28 } -- err: 27.3
--notes = { 21, 22, 23, 25, 26, 28, 29, 31, 33, 35, 37, 39, 42 } -- err: 22.2
--notes = { 24, 25, 27, 28, 30, 32, 34, 36, 38, 40, 42, 45, 48 } -- err: 18.5
--notes = { 29, 31, 33, 35, 37, 39, 41, 44, 46, 49, 52, 55, 58 } -- err: 13.5
notes = { 30, 32, 34, 36, 38, 40, 43, 45, 48, 51, 54, 57, 60 } -- err: 12.6

scale = { 1, 3, 5, 6, 8, 10, 12, 13 }

local n = 0

function playdate.AButtonDown()
	n += 1
	if n > #scale then n = 1 end
	synth:stop()
	synth:playNote(5*notes[scale[n]])
end

function playdate.BButtonDown()
	n += 1
	if n > #notes then n = 1 end
	synth:stop()
	synth:playNote(5*notes[n])
end
