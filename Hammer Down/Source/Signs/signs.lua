
signs = { }

pngSign = LCD:new('Signs/SignPNG', 312, 131)
txtSign = LCD:new('Signs/SignTXT', 289, 99)
zipSign = LCD:new('Signs/SignZIP', 56, 92)
avoidSign = LCD:new('Signs/SignAvoid', 28, 129)

signsL = LCDGroup:new({
	LCD:new('Signs/SignSm2', 147, 77),
	LCD:new('Signs/SignSm1', 118, 85)
})

signsR = LCDGroup:new({
	LCD:new('Signs/SignSm2', 236, 77),
	LCD:new('Signs/SignSm1', 257, 90)
})

function signs:showAll(flag)
	pngSign:setOn(flag)
	txtSign:setOn(flag)
	zipSign:setOn(flag)
	avoidSign:setOn(flag)
	signsL:showAll(flag)
	signsR:showAll(flag)
end

function signs:update()
	if self.p < 3
	then
		if self.type == 'png' or self.type == 'txt'
		then
			signsR:select(self.p)
		else
			signsL:select(self.p)
		end
	else
		signsL:showAll(false)
		signsR:showAll(false)
		_G[self.type .. 'Sign']:setOn(true)
		self.updateScalar = nil
	end

	self.p = self.p + 1
end

function signs:selectType(type)
	self:showAll(false)
	self.type = type
	self.p = 1
	self.updateScalar = 10

	if playing
	then
		if type == 'png' or type == 'txt'
		then
			guy:enterLeft()
		else
			guy:enterRight()
		end
	end
end
