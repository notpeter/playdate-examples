
File = { row = 5 }

function File:new(type, track)
	o = { track = track, type = type }
	setmetatable(o, self)
	self.__index = self
	return o
end

tracks = { 'A', 'B', 'C', 'D', 'E' }
filetypes = { 'zip', 'txt', 'png' }

function File:setRow(row)
	self.row = row
	_G['files' .. tracks[self.track]]:select(row)
	_G['files' .. tracks[self.track] .. self.type]:select(row)
end


files = { updateScalar = 10, list = {} }

function files:add(type, tracknum)
	local f = File:new(type, tracknum)

	-- newest at the front so that files roll off the end during update
	table.insert(self.list, 1, f)
end

function files:addRandomFile()
	self:add(filetypes[math.random(#filetypes)], math.random(5))
end


function files:showAll(flag)
	for i = 1,#tracks
	do
		_G['files' .. tracks[i]]:showAll(flag)
		_G['files' .. tracks[i] .. 'zip']:showAll(flag)
		_G['files' .. tracks[i] .. 'png']:showAll(flag)
		_G['files' .. tracks[i] .. 'txt']:showAll(flag)
	end
end


function files:update(truckpos)
	local hitfile = nil

	for i, f in pairs(self.list)
	do
		if f.row > 1 then
			f:setRow(f.row - 1)
		else
			f:setRow(0)

			if ( f.track == truckpos ) then
				hitfile = f
			end

			table.remove(self.list, i)
		end
	end

	return hitfile
end


filesA = LCDGroup:new(
{
	LCD:new('Files/Files1', 93, 139),
	LCD:new('Files/Files2', 127, 115),
	LCD:new('Files/Files3', 155, 96),
	LCD:new('Files/Files4', 174, 79),
	LCD:new('Files/Files5', 189, 67)
})

filesApng = LCDGroup:new(
{
	LCD:new('Files/Files1png', 97, 151),
	LCD:new('Files/Files2png', 130, 124),
	LCD:new('Files/Files3png', 158, 104),
	LCD:new('Files/Files4png', 177, 85)
})

filesAtxt = LCDGroup:new(
{
	LCD:new('Files/Files1txt', 99, 153),
	LCD:new('Files/Files2txt', 132, 126),
	LCD:new('Files/Files3txt', 160, 106),
	LCD:new('Files/Files4txt', 177, 84)
})

filesAzip = LCDGroup:new(
{
	LCD:new('Files/Files1zip', 104, 142),
	LCD:new('Files/Files2zip', 134, 118),
	LCD:new('Files/Files3zip', 158, 99),
	LCD:new('Files/Files4zip', 177, 81)
})


filesB = LCDGroup:new(
{
  LCD:new('Files/Files1', 140, 139),
  LCD:new('Files/Files2', 159, 115),
  LCD:new('Files/Files3', 174, 96),
  LCD:new('Files/Files4', 185, 79)
})

filesBpng = LCDGroup:new(
{
	LCD:new('Files/Files1png', 144, 151),
	LCD:new('Files/Files2png', 162, 124),
	LCD:new('Files/Files3png', 177, 104),
	LCD:new('Files/Files4png', 188, 85)
})

filesBtxt = LCDGroup:new(
{
	LCD:new('Files/Files1txt', 146, 153),
	LCD:new('Files/Files2txt', 164, 126),
	LCD:new('Files/Files3txt', 179, 106),
	LCD:new('Files/Files4txt', 188, 84)
})

filesBzip = LCDGroup:new(
{
	LCD:new('Files/Files1zip', 151, 142),
	LCD:new('Files/Files2zip', 166, 118),
	LCD:new('Files/Files3zip', 177, 99),
	LCD:new('Files/Files4zip', 188, 81)
})


filesC = LCDGroup:new(
{
  LCD:new('Files/Files1', 187, 139),
  LCD:new('Files/Files2', 191, 115),
  LCD:new('Files/Files3', 194, 96),
  LCD:new('Files/Files4', 196, 79),
  LCD:new('Files/Files5', 197, 67)
})

filesCpng = LCDGroup:new(
{
	LCD:new('Files/Files1png', 191, 151),
	LCD:new('Files/Files2png', 194, 124),
	LCD:new('Files/Files3png', 197, 104),
	LCD:new('Files/Files4png', 199, 85)
})

filesCtxt = LCDGroup:new(
{
	LCD:new('Files/Files1txt', 193, 153),
	LCD:new('Files/Files2txt', 196, 126),
	LCD:new('Files/Files3txt', 199, 106),
	LCD:new('Files/Files4txt', 199, 84)
})

filesCzip = LCDGroup:new(
{
	LCD:new('Files/Files1zip', 198, 142),
	LCD:new('Files/Files2zip', 198, 118),
	LCD:new('Files/Files3zip', 197, 99),
	LCD:new('Files/Files4zip', 199, 81)
})


filesD = LCDGroup:new(
{
  LCD:new('Files/Files1', 234, 139),
  LCD:new('Files/Files2', 223, 115),
  LCD:new('Files/Files3', 214, 96),
  LCD:new('Files/Files4', 207, 79)
})

filesDpng = LCDGroup:new(
{
	LCD:new('Files/Files1png', 238, 151),
	LCD:new('Files/Files2png', 226, 124),
	LCD:new('Files/Files3png', 217, 104),
	LCD:new('Files/Files4png', 210, 85)
})

filesDtxt = LCDGroup:new(
{
	LCD:new('Files/Files1txt', 240, 153),
	LCD:new('Files/Files2txt', 228, 126),
	LCD:new('Files/Files3txt', 219, 106),
	LCD:new('Files/Files4txt', 210, 84)
})

filesDzip = LCDGroup:new(
{
	LCD:new('Files/Files1zip', 245, 142),
	LCD:new('Files/Files2zip', 230, 118),
	LCD:new('Files/Files3zip', 217, 99),
	LCD:new('Files/Files4zip', 210, 81)
})


filesE = LCDGroup:new(
{
  LCD:new('Files/Files1', 281, 139),
  LCD:new('Files/Files2', 255, 115),
  LCD:new('Files/Files3', 233, 96),
  LCD:new('Files/Files4', 218, 79),
  LCD:new('Files/Files5', 205, 67)
})

filesEpng = LCDGroup:new(
{
	LCD:new('Files/Files1png', 285, 151),
	LCD:new('Files/Files2png', 258, 124),
	LCD:new('Files/Files3png', 236, 104),
	LCD:new('Files/Files4png', 221, 85)
})

filesEtxt = LCDGroup:new(
{
	LCD:new('Files/Files1txt', 287, 153),
	LCD:new('Files/Files2txt', 260, 126),
	LCD:new('Files/Files3txt', 238, 106),
	LCD:new('Files/Files4txt', 221, 84)
})

filesEzip = LCDGroup:new(
{
	LCD:new('Files/Files1zip', 292, 142),
	LCD:new('Files/Files2zip', 262, 118),
	LCD:new('Files/Files3zip', 236, 99),
	LCD:new('Files/Files4zip', 221, 81)
})

