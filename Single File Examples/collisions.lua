
import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

-- local references
local gfx = playdate.graphics
local Line = playdate.geometry.lineSegment

local af = playdate.geometry.affineTransform.new()
local dt = 0.05


class('Box').extends(playdate.graphics.sprite)
class('Player').extends(Box)


local player = Player()
player:setZIndex(1000)
player:setSize(20, 20)
player:addSprite()
player:setCollideRect(0,0,20,20)
player:moveTo(190, 223)
player.playerNumber = 1
player.velocityX = 60
player.velocityY = 50
player.rayRotation = 0

local player2 = Player()
player2:setZIndex(1000)
player2:setSize(16, 16)
player2:addSprite()
player2:setCollideRect(0,0,16,16)
player2:moveTo(100, 40)
player2.playerNumber = 1
player2.velocityX = 20
player2.velocityY = 30
player2.rayRotation = 13

local players = {}
players[1] = player
players[2] = player2


function Box:draw(x, y, width, height)
	local cx, cy, width, height = self:getCollideBounds()
	gfx.setColor(playdate.graphics.kColorWhite)
	gfx.fillRect(cx, cy, width, height)
	gfx.setColor(playdate.graphics.kColorBlack)
	gfx.drawRect(cx, cy, width, height)
end


function Player:draw(x, y, width, height)
	local cx, cy, width, height = self:getCollideBounds()
	gfx.setColor(playdate.graphics.kColorBlack)
	gfx.fillRect(cx, cy, width, height)
end


-- override Player's draw method so player1 gets drawn differently
function player:draw(x, y, width, height)
	local cx, cy, width, height = self:getCollideBounds()
	
	gfx.setColor(playdate.graphics.kColorBlack)
	gfx.fillRect(cx, cy, width, height)
	gfx.setColor(playdate.graphics.kColorWhite)
	gfx.fillRect(cx+6, cy+6, width-12, height-12)	
end


function Player:collisionResponse(other)
	return gfx.sprite.kCollisionTypeBounce
end


-- Player sprites just bounce around, reflecting off of each other and boxes
local function updatePlayer(dt, player)
	
  local speed = player.speed

  local dx, dy = 0, 0
  
  if playdate.buttonIsPressed(playdate.kButtonRight) then
  	player.velocityX = player.velocityX + 10
  	
  elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
  	player.velocityX = player.velocityX - 10
  end
  
  if playdate.buttonIsPressed(playdate.kButtonDown) then
  	player.velocityY = player.velocityY + 10
  	
  elseif playdate.buttonIsPressed(playdate.kButtonUp) then
		player.velocityY = player.velocityY - 10
  end
  
  dx = player.velocityX * dt
  dy = player.velocityY * dt

	if dx ~= 0 or dy ~= 0 then
		
		local actualX, actualY, cols, cols_len = player:moveWithCollisions(player.x + dx, player.y + dy)

	    for i=1, cols_len do
	      local col = cols[i]      
	    	-- not trying to be physics-accurate
	    	if col.normal.x ~= 0 then -- hit something in the X direction
				-- if we were sliding we'd just want to set our velocityX to zero, but we're bouncing, so...
				if col.other:isa(Player) then
					-- collided with another player, so transfer some of our velocity to that player
					col.other.velocityX = col.other.velocityX + (player.velocityX * 0.2)
					player.velocityX = -(player.velocityX * 0.8)
					player.velocityX = player.velocityX + (-col.other.velocityX * 0.2)
				else
					-- collided witih a box, so just bounce
					 player.velocityX = -player.velocityX
				end
			end
		  
		    if col.normal.y ~= 0 then -- hit something in the X direction
				if col.other:isa(Player) then
					col.other.velocityY = col.other.velocityY + (player.velocityY * 0.2)
					player.velocityY = -(player.velocityY * 0.8)
					player.velocityY = player.velocityY + (-col.other.velocityY * 0.2)
				else
					player.velocityY = -player.velocityY
				end
			end
	    end
	end
end



-- Draws some rays coming of of the main player to show off querySpriteInfoAlongLine(). Filled circles are drawn on collision entry points. Hollow circles are drawn on exit points. The size of the circle depends on how close the collision is to the beginnign of the line segment (which is the center of the sprite) Even though we do recieve information about all collisions, we're only drawing entry and exit points on the first box encountered.

function drawRays()
	
	gfx.setColor(gfx.kColorBlack)
	
	for _, player in pairs(players) do
	for extraAngle = 1, 12 do
	
		local line = Line.new(0,0, 500, 0)
		
		af:reset()
		player.rayRotation = (player.rayRotation + 0.05)
		af:rotate(player.rayRotation + extraAngle*30)
		af:translate(player.x, player.y)
	
		local tls = af:transformedLineSegment(line)

		local collisions, len = gfx.sprite.querySpriteInfoAlongLine(tls)
	
		if collisions then
			for _, collision in pairs(collisions) do
				if not collision.sprite:isa(Player) then	-- don't care about colliding with other player sprites
					gfx.drawCircleAtPoint(collision.entryPoint, 6 - 10*collision.ti1, 5)
					gfx.drawCircleAtPoint(collision.exitPoint, 5 - 10*collision.ti2, 0)
					gfx.drawLine(tls.x1, tls.y1, collision.entryPoint.x, collision.entryPoint.y)
					break
				end
			end
		end
	end
	end
end



local function addBlock(x,y,w,h)
	local block = Box()
	block:setSize(w, h)
	block:moveTo(x, y)
	block:setCenter(0,0)
	block:addSprite()
	block:setCollideRect(0,0,w,h)
end


-- set up some boxes for the player sprites to bounce off of

-- border edges
local borderSize = 5
local displayWidth = playdate.display.getWidth()
local displayHeight = playdate.display.getHeight()
addBlock(0, 0, displayWidth, borderSize)
addBlock(0, borderSize, borderSize, displayHeight-borderSize*2)
addBlock(displayWidth-borderSize, borderSize, borderSize, displayHeight-borderSize*2)
addBlock(0, displayHeight-borderSize, displayWidth, borderSize)


-- random blocks
for i=1,6 do
	addBlock( math.random(50, 320),
	          math.random(50, 150),
	          math.random(10, 40),
	          math.random(10, 100)
	)
end


local ms = playdate.getCurrentTimeMilliseconds
local floor = math.floor
local lastFrameTime = ms()
local MAXSAMPLES = 10
local tickindex = 1
local ticksum = 50 * MAXSAMPLES
local ticklist = {}
for i = 1, MAXSAMPLES do
	ticklist[i] = 50
end

local function calcAverageTick(newtick)
	ticksum = ticksum - ticklist[tickindex]  -- subtract value falling off
	ticksum = ticksum + newtick              -- add new value
	ticklist[tickindex] = newtick   -- save new value so it can be subtracted later
	tickindex = tickindex + 1
	if tickindex == MAXSAMPLES then    -- inc buffer index
		tickindex=1
	end
	-- return average
	return(ticksum/MAXSAMPLES);
end
function fps(x,y)
	-- draw fps
	local currentTime = ms()
	local avgTick = calcAverageTick(currentTime - lastFrameTime)
	local fps = floor((1000/avgTick) + 0.5)
	lastFrameTime = currentTime
		
	gfx.drawText(fps, x, y)
end


gfx.setBackgroundColor(gfx.kColorClear)

function playdate.update()

  	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, playdate.display.getWidth(), playdate.display.getHeight())
	gfx.setColor(gfx.kColorBlack)
  
	for _, player in pairs(players) do
		updatePlayer(dt, player)
	end
	
	if not playdate.buttonIsPressed(playdate.kButtonA) then
		drawRays()
	end
	
	fps(10, 10)
	
	gfx.sprite:update()
-- 	Input.afterUpdate()
end

