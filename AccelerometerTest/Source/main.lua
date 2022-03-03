
import 'CoreLibs/sprites.lua'
import 'CoreLibs/graphics.lua'

gfx = playdate.graphics

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, 400, 240)
gfx.setBackgroundColor(gfx.kColorWhite)

local radius = 20

local gravity = 0.4
local wallbounce = 0.8

local ball = gfx.sprite:new()
ball:setSize(2*radius+1, 2*radius+1)
ball:moveTo(200,120)
ball:addSprite()

function hypot(x,y)
	return math.sqrt(x*x+y*y)
end

local dx,dy = math.random(-20,20), math.random(-20,20)

ball.draw = function()
	gfx.setColor(gfx.kColorBlack)

	if ball.collided then
		gfx.fillCircleAtPoint(radius, radius, radius)
		ball.collided = false
	else
		gfx.drawCircleAtPoint(radius, radius, radius)
	end
end

ball.update = function()
	if gravity > 0 then
		dx,dy = dx + gravityx / 4, dy + gravityy / 4
	end

	-- bounce off the walls

	local left = radius
	local right = 400 - radius

	local newx = ball.x + dx
	local newy = ball.y + dy

	if newx < left and dx < 0
	then
		newx = left
		dx *= -wallbounce
		ball.collided = true
	elseif newx > right and dx > 0
	then
		newx = right
		dx *= -wallbounce
		ball.collided = true
	end

	local top = radius
	local bottom = 240 - radius

	if newy < top and dy < 0
	then
		newy = top
		dy *= -wallbounce
		ball.collided = true
	elseif newy > bottom and dy > 0
	then
		newy = bottom
		dy *= -wallbounce
		ball.collided = true
	end

	ball:moveTo(newx, newy)
end


playdate.startAccelerometer()

function playdate.update()
	gravityx, gravityy = playdate.readAccelerometer()
	gfx.sprite.update()
end
