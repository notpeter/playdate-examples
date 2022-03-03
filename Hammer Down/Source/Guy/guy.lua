
guy = {}

function guy:showAll(flag)
	guyBodyL:showAll(flag)
	guyArmsL:showAll(flag)
	guyBodyR:showAll(flag)
	guyArmsR:showAll(flag)
end

function guy:update()
	if self.p < 4
	then
		_G['guyBody' .. self.side]:select(self.p)
	else
		_G['guyArms' .. self.side]:select(1 + self.p % 2)
	end

	self.p = self.p + 1
end

function guy:enterLeft()
	self.updateScalar = 10
	self.p = 1
	self.side = 'L'
end

function guy:enterRight()
	self.updateScalar = 10
	self.p = 1
	self.side = 'R'
end

function guy:done()
	self:showAll(false)
	self.updateScalar = nil
	self.side = nil
end


guyBodyL = LCDGroup:new({
	LCD:new('Guy/GuyBodyL1', 1, 89),
	LCD:new('Guy/GuyBodyL2', 6, 117),
	LCD:new('Guy/GuyBodyL3', 4, 161)
})

guyArmsL = LCDGroup:new({
	LCD:new('Guy/GuyArmsL1', 23, 176),
	LCD:new('Guy/GuyArmsL2', 24, 167)
})

guyBodyR = LCDGroup:new({
	LCD:new('Guy/GuyBodyR1', 381, 89),
	LCD:new('Guy/GuyBodyR2', 373, 117),
	LCD:new('Guy/GuyBodyR3', 367, 161)
})

guyArmsR = LCDGroup:new({
	LCD:new('Guy/GuyArmsR1', 356, 176),
	LCD:new('Guy/GuyArmsR2', 362, 167)
})