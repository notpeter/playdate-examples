
truck = { position = 0, good = 0, bad = 0 }

function truck:showAll(flag)
	truckLCD:showAll(flag)
	truckBadLCD:showAll(flag)
	truckGoodLCD:showAll(flag)
end

function truck:moveto(p)
	self.position = p

	truckLCD:select(p)

	if self.good > 0 then
		truckGoodLCD:select(p)
		truckBadLCD:select(0)
	elseif self.bad > 0 then
		truckBadLCD:select(p)
		truckGoodLCD:select(0)
	end
end

function truck:left()
	if self.position > 1 	then
		self:moveto(self.position - 1)
		return true
	else
		return false
	end
end

function truck:right()
	if self.position < 5 then
		self:moveto(self.position + 1)
		return true
	else
		return false
	end
end

function truck:update()
	if self.bad > 0 then
		self.bad = self.bad - 1
		if self.bad == 0 then
			truckBadLCD:select(0)
			self.updateScalar = nil
		end
	elseif self.good > 0 then
		self.good = self.good - 1
		if self.good == 0 then
			truckGoodLCD:select(0)
			self.updateScalar = nil
		end
	end
end

function truck:badReaction(count)
	self.good = 0
	self.bad = count
	self:moveto(self.position)
	self.updateScalar = 1
end

function truck:goodReaction(count)
	self.bad = 0
	self.good = count
	self:moveto(self.position)
	self.updateScalar = 1
end


truckLCD = LCDGroup:new(
{
	LCD:new('Truck/TruckA', 32, 185),
	LCD:new('Truck/TruckB', 104, 185),
	LCD:new('Truck/TruckC', 182, 185),
	LCD:new('Truck/TruckD', 253, 185),
	LCD:new('Truck/TruckE', 319, 185)
})

truckBadLCD = LCDGroup:new(
{
	LCD:new('Truck/ReactBadA', 39, 177),
	LCD:new('Truck/ReactBadB', 113, 174),
	LCD:new('Truck/ReactBadC', 173, 176),
	LCD:new('Truck/ReactBadD', 245, 174),
	LCD:new('Truck/ReactBadE', 309, 177)
})

truckGoodLCD = LCDGroup:new(
{
	LCD:new('Truck/ReactGoodA', 23, 174),
	LCD:new('Truck/ReactGoodB', 92, 171),
	LCD:new('Truck/ReactGoodC', 174, 173),
	LCD:new('Truck/ReactGoodD', 247, 169),
	LCD:new('Truck/ReactGoodE', 309, 173)
})
