
hud = { lives = 3, hasFile = false }

hudTruck = LCD:new('HUD/HUDTruck', 6, 12)
hudFile = LCD:new('HUD/HUDFile', 17, 4)
hudHearts = {
	LCD:new('HUD/HUDHeart', 41, 9),
	LCD:new('HUD/HUDHeart', 57, 9),
	LCD:new('HUD/HUDHeart', 73, 9)
}

function hud:drawScore()
	--gfx.drawBitmap(HUDScore, 306, 5, kDrawModeNXOR)
end

function hud:showAll(flag)
	hudTruck:setOn(flag)
	hudFile:setOn(flag)
	hudHearts[1]:setOn(flag)
	hudHearts[2]:setOn(flag)
	hudHearts[3]:setOn(flag)
end

function hud:setPlaying(flag)
	if flag
	then
		self.lives = 3
		self.hasFile = false

		hudHearts[1]:setOn(true)
		hudHearts[2]:setOn(true)
		hudHearts[3]:setOn(true)
		hudTruck:setOn(true)
		hudFile:setOn(false)
	else
		self:showAll(false)
		-- XXX - show time
	end
end

function hud:removeLife()
	hudHearts[self.lives]:setOn(false)
	self.lives = self.lives - 1
	return self.lives == 0
end

function hud:addFile()
	hudFile:setOn(true)
	self.hasFile = true
end

function hud:removeFile()
	hudFile:setOn(false)
	self.hasFile = false
end
