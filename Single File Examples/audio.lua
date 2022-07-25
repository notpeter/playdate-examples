
playdate.graphics.drawText("Press A or B to play sounds", 95, 100)

boing = playdate.sound.sampleplayer.new('assets/audio-8000')
boing:setVolume(0.2, 1)
boing:play()

boing2 = boing:copy()
boing3 = boing:copy()

playdate.stop()

function playdate.AButtonDown()
	local p = math.random()
	boing:setVolume(p, 1-p)
	boing:setRate(0.2 + 3 * math.random())
	boing:play()
end

function playdate.BButtonDown()
	boing:setRate(1.0)
	boing:setVolume(1)
	boing2:setRate(1.33333)
	boing3:setRate(1.5)
	
	boing:play()
	boing2:play()
	boing3:play()
end

function playdate.update()
end
