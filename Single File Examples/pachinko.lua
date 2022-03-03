
import 'CoreLibs/sprites.lua'
import 'CoreLibs/graphics.lua'

local gfx = playdate.graphics
local spritelib = gfx.sprite

gfx.setBackgroundColor(gfx.kColorWhite)
gfx.clear()

local ball = gfx.sprite.new()
ball.dx = 0
ball.dy = 0
ball.radius = 5

local gravityx = 0.0
local gravityy = 0.5
local wallbounce = 0.95

function drawPeg(s, x, y, w, h)
	gfx.setColor(gfx.kColorBlack)
	 gfx.setLineWidth(0)
	 gfx.drawCircleAtPoint(s.radius, s.radius, s.radius)
end

function newPeg(x, y)
	local peg = gfx.sprite.new()
	peg.draw = drawPeg
	peg.radius = 5
	peg:moveTo(x, y)
	peg:setSize(12, 12)
	peg:setCollideRect(1, 1, 10, 10)
	peg:add()
	peg.dx = math.random(5)
	return peg
end

ball:setSize(12, 12)
ball:moveTo(103, 50)
ball:setCollideRect(1, 1, 10, 10)
ball:add()
ball.draw = drawPeg

pegs = {}

local i = 0

for y = 100, 200, 60 do
	for x = 20, 380, 30 do
		pegs[i] = newPeg(x, y)
		pegs[i+1] = newPeg(x+15, y+30)
		i += 2
	end
end

function playdate.update()

	local c = ball:overlappingSprites()
	-- could also use spritelib.querySpritesInRect(ball:getBounds()) here, in which case we wouldn't need ball's collide rect to be set
	-- it also provides additional information, which we don't need here
	-- local c = spritelib.querySpritesInRect(ball:getBounds())
	
	if c then
		-- if `ball` had its collision rect set, it would show up in this list as well
		local i = 1
		while i <= #c do
			local peg = c[i]
			i += 1
			ball:collide(peg)
		end
	end
	
	spritelib.update()
end

function hypot(x,y)
	return math.sqrt(x*x+y*y)
end

local elasticity = 0.95

function ball:collide(c)

	local sx = self.x
	local sy = self.y
	local cx = c.x
	local cy = c.y

	local xd = sx - cx
	local yd = sy - cy
	local d = hypot(xd, yd)

	if d == 0 or d >= 2 * self.radius then return end

	local nx = xd / d;
	local ny = yd / d;
	
	local p = self.dx * nx + self.dy * ny

	self:setVelocity(elasticity * (self.dx - 2 * p * nx), elasticity * (self.dy - 2 * p * ny))
	self:moveTo((sx + cx) / 2 + nx * self.radius, (sy + cy) / 2 + ny * self.radius)

end

function ball:update()
	
	if gravityy > 0 then
		self:setVelocity(self.dx + gravityx / 4, self.dy + gravityy / 4)
	end
	
	-- bounce off the walls
	
	local left = self.radius
	local right = 400 - self.radius
	
	local newx = self.x + self.dx
	local newy = self.y + self.dy
	
	if newx < left and self.dx < 0
	then
		newx = left
		self:setVelocity(-self.dx * wallbounce, self.dy * wallbounce)
	elseif newx > right and self.dx > 0
	then 
		newx = right
		self:setVelocity(-self.dx * wallbounce, self.dy * wallbounce)
	end

	local top = self.radius
	local bottom = 240 - self.radius
	
	if newy < top and self.dy < 0
	then
		newy = top
		self:setVelocity(self.dx * wallbounce, -self.dy * wallbounce)
	elseif newy > bottom and self.dy > 0
	then
		newy = bottom
		self:setVelocity(self.dx * wallbounce, -self.dy * wallbounce)
	end
	
	self:moveTo(newx, newy)
end

function ball:setVelocity(dx, dy)
	self.dx = dx
	self.dy = dy
end
