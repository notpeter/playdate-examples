
gfx = playdate.graphics

LCD = {}

function LCD:new(bitmap, x, y)
	o = { bitmap = gfx.image.new(bitmap), x = x, y = y, on = false }
	setmetatable(o, self)
	self.__index = self
	return o
end

function LCD:setOn(val)
	if val ~= self.on
	then
		gfx.setImageDrawMode(gfx.kDrawModeNXOR)
		self.bitmap:draw(self.x, self.y)
		self.on = val
	end
end


LCDGroup = {}

function LCDGroup:new(list)
	o = { list = list }
	setmetatable(o, self)
	self.__index = self
	return o
end

function LCDGroup:select(n)
	for i, v in pairs(self.list)
	do
		v:setOn(i == n)
	end
end

function LCDGroup:showAll(flag)
	for i, v in pairs(self.list)
	do
		v:setOn(flag)
	end
end

function LCDGroup:selectList(l)
	for i, v in pairs(self.list)
	do
		found = false

		for j, w in pairs(l)
		do
			if ( i == w )
			then
				found = true
				break
			end
		end

		v:setOn(found)
	end
end
