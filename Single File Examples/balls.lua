
import 'CoreLibs/sprites.lua'
import 'CoreLibs/graphics.lua'

local gfx = playdate.graphics

playdate.startAccelerometer()
local gravityx, gravityy = 0, 0

class("ball").extends(gfx.sprite)

local gravity = 0.4
local wallbounce = 0.8
local ballCount = 50

function ball:init()
	ball.super.init(self)
	self.radius = 5
	self:setSize(2*self.radius+1, 2*self.radius+1)
	self:setCollideRect(0, 0, 2*self.radius+1, 2*self.radius+1)
	self:moveTo(math.random(400), math.random(240))
	self:setVelocity(math.random(-5,5), math.random(-5,5))
	self:add()
end


function ball:draw()
	
	gfx.setColor(gfx.kColorBlack)
	
	gfx.setLineWidth(0)
	
	if self.collided then
		gfx.drawCircleAtPoint(self.radius, self.radius, self.radius)
	else
		gfx.drawCircleAtPoint(self.radius, self.radius, self.radius)
	end
	
	self.collided = false
end


function ball:setVelocity(dx, dy)
	self.dx = dx
	self.dy = dy
end


local function hypot(x,y)
	return math.sqrt(x*x+y*y)
end


function ball:collide(c)

	local sx = self.x
	local sy = self.y
	local cx = c.x
	local cy = c.y

	local xd = sx - cx
	local yd = sy - cy
	local d = hypot(xd, yd)

	if d == 0 or d >= 2 * self.radius then return end

	c.collided = true

	local nx = xd / d;
	local ny = yd / d;
	
	local p = (self.dx - c.dx) * nx + (self.dy - c.dy) * ny

	self:setVelocity(self.dx - p * nx, self.dy - p * ny)
	self:moveTo((sx + cx) / 2 + nx * self.radius, (sy + cy) / 2 + ny * self.radius)

	c:setVelocity(c.dx + p * nx, c.dy + p * ny)
	c:moveTo((cx + sx) / 2 - nx * self.radius, (cy + sy) / 2 - ny * self.radius)

end


local function checkCollisions()

	local collisions = gfx.sprite.allOverlappingSprites()	

	for i = 1, #collisions do		
		local collisionPair = collisions[i]
		local sprite1 = collisionPair[1]
		local sprite2 = collisionPair[2]
		sprite1:collide(sprite2)
	end	
end


function ball:update()
	
	if gravity > 0 then
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
		self:setVelocity(-self.dx * wallbounce, self.dy)
		self.collided = true
	elseif newx > right and self.dx > 0
	then 
		newx = right
		self:setVelocity(-self.dx * wallbounce, self.dy)
		self.collided = true
	end

	local top = self.radius
	local bottom = 240 - self.radius
	
	if newy < top and self.dy < 0
	then
		newy = top
		self:setVelocity(self.dx, -self.dy * wallbounce)
		self.collided = true
	elseif newy > bottom and self.dy > 0
	then
		newy = bottom
		self:setVelocity(self.dx, -self.dy * wallbounce)
		self.collided = true
	end
	
	self:moveTo(newx, newy)
end

-- create the ball sprites
for i = 1, ballCount do
	ball()
end


-- in the case of lots of small sprites spread across the full screen, it's
--  often faster to skip dirty rect checking and redraw the entire screen

local alwaysredraw = false

function playdate.AButtonDown()
	alwaysredraw = not alwaysredraw
	print("always redraw: "..tostring(alwaysredraw))
	gfx.sprite.setAlwaysRedraw(alwaysredraw)
end


function playdate.update()
	gravityx, gravityy = playdate.readAccelerometer()
	checkCollisions()
	gfx.sprite.update()
	playdate.drawFPS(0,0)
end







