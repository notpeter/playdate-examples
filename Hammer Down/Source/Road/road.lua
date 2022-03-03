
road = { updateScalar = 3, p = 0 }

function road:update()
	self.p = 1 + self.p % 6

	sides = {1, 2, 3, 4, 5, 6}
	table.remove(sides, self.p)

	dividersA:selectList(sides)
	dividersF:selectList(sides)

	n = (self.p % 3)

	dividersB:selectList({n+1, n+4})
	dividersC:selectList({n-1, n+2, n+5})
	dividersD:selectList({n, n+3, n+6})
	dividersE:selectList({n-1, n+2, n+5})
end


function road:showAll(flag)
	for i, v in pairs(dividers)
	do
		v:showAll(flag)
	end
end


dividersA = LCDGroup:new(
{
  LCD:new('Road/DividerA5', 186, 75),
  LCD:new('Road/DividerA4', 167, 90),
  LCD:new('Road/DividerA3', 144, 106),
  LCD:new('Road/DividerA2', 115, 130),
  LCD:new('Road/DividerA1', 69, 160),
  LCD:new('Road/DividerA0', 0, 216)
})

dividersB = LCDGroup:new(
{
  LCD:new('Road/DividerB6', 191, 75),
  LCD:new('Road/DividerB5', 177, 91),
  LCD:new('Road/DividerB4', 168, 102),
  LCD:new('Road/DividerB3', 147, 123),
  LCD:new('Road/DividerB2', 123, 149),
  LCD:new('Road/DividerB1', 94, 175),
  LCD:new('Road/DividerB0', 67, 217)
})

dividersC = LCDGroup:new(
{
  LCD:new('Road/DividerC5', 196, 75),
  LCD:new('Road/DividerC4', 187, 92),
  LCD:new('Road/DividerC3', 178, 116),
  LCD:new('Road/DividerC2', 168, 143),
  LCD:new('Road/DividerC1', 152, 174),
  LCD:new('Road/DividerC0', 140, 217)
})

dividersD = LCDGroup:new(
{
  LCD:new('Road/DividerD5', 202, 75),
  LCD:new('Road/DividerD4', 208, 92),
  LCD:new('Road/DividerD3', 215, 116),
  LCD:new('Road/DividerD2', 224, 143),
  LCD:new('Road/DividerD1', 235, 174),
  LCD:new('Road/DividerD0', 249, 217)
})

dividersE = LCDGroup:new(
{
  LCD:new('Road/DividerE6', 207, 75),
  LCD:new('Road/DividerE5', 219, 91),
  LCD:new('Road/DividerE4', 227, 102),
  LCD:new('Road/DividerE3', 242, 123),
  LCD:new('Road/DividerE2', 262, 149),
  LCD:new('Road/DividerE1', 282, 175),
  LCD:new('Road/DividerE0', 313, 217)
})

dividersF = LCDGroup:new(
{
  LCD:new('Road/DividerF5', 211, 75),
  LCD:new('Road/DividerF4', 227, 90),
  LCD:new('Road/DividerF3', 246, 106),
  LCD:new('Road/DividerF2', 274, 130),
  LCD:new('Road/DividerF1', 308, 160),
  LCD:new('Road/DividerF0', 371, 216)
})

dividers = { dividersA, dividersB, dividersC, dividersD, dividersE, dividersF }
