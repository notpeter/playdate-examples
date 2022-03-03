
mountains = { updateScalar = 30, r = { 1, 3 }, l = { 2 } }

horizon = gfx.image.new('Mountains/Horizon')

function drawHorizon()
	gfx.setImageDrawMode(gfx.kDrawModeNXOR)
	horizon:draw(0, 73)
end

function mountains:showAll(flag)
	mountainsL:showAll(flag)
	mountainsR:showAll(flag)
end


function moveMountains(l)
	local outlist = {}

	if math.random(3) == 1 then
		table.insert(outlist, 1)
	end

	for i, v in pairs(l)
	do
		if v < 4 then
			table.insert(outlist, v + 1)
		end
	end

	return outlist
end

function mountains:update()
	self.l = moveMountains(self.l)
	mountainsL:selectList(self.l)

	self.r = moveMountains(self.r)
	mountainsR:selectList(self.r)
end


mountainsL = LCDGroup:new(
{
	LCD:new('Mountains/MountainL1', 148, 63),
	LCD:new('Mountains/MountainL2', 104, 57),
	LCD:new('Mountains/MountainL3', 45, 52),
	LCD:new('Mountains/MountainL4', 0, 46)
})

mountainsR = LCDGroup:new(
{
	LCD:new('Mountains/MountainR1', 225, 65),
	LCD:new('Mountains/MountainR2', 250, 60),
	LCD:new('Mountains/MountainR3', 287, 54),
	LCD:new('Mountains/MountainR4', 344, 47)
})
