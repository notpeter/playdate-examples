import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx = playdate.graphics
gfx.clear()

class('Box').extends(playdate.graphics.sprite)
class('Player').extends(playdate.graphics.sprite)
class('Monster').extends(playdate.graphics.sprite)

local playerSprites = {}
local monsterSprites = {}

local playerImage = gfx.image.new('img/player')
local playerHitImage = gfx.image.new('img/player-hit')
local monsterImage = gfx.image.new('img/monster')
local monsterHitImage = gfx.image.new('img/monster-hit')

local kPlayerType = 1
local kMonsterType = 2

playdate.display.setRefreshRate(40)


local function createPlayerSprite()

	local player = Player()
	player.type = kPlayerType 	-- a custom field that we can check in our collision handler
	
	player:setImage(playerImage)
	local imageWidth, imageHeight = playerImage:getSize()
	player:setCollideRect(2, 2, imageWidth-4, imageHeight-4)
	player:moveTo(math.random(30, 370), math.random(30, 210))
	player.velocityX = math.random(-80, 80)
	player.velocityY = math.random(-80, 80)
	player.collisionResponse = gfx.sprite.kCollisionTypeBounce
	
	player:setGroups({2})					-- players are on layer 2
	-- player:setGroupMask(2) 				-- equivalent to above (binary: 0010 = 2)
	player:setCollidesWithGroups({3})		-- players only collide with sprites on layer 3 (monsters and walls)
	-- player:setCollidesWithGroupsMask(4)	-- equivalent to above (binary: 0100 = 4)
	
	playerSprites[#playerSprites+1] = player
	player:addSprite()
	
	return player
end


local function createMonsterSprite()

	local monster = Monster()
	monster.type = kMonsterType 	-- a custom field that we can check in our collision handler
	
	monster:setImage(monsterImage)
	local imageWidth, imageHeight = monsterImage:getSize()
	monster:setCollideRect(2, 2, imageWidth-6, imageHeight-4)
	
	monster:moveTo(math.random(30, 370), math.random(30, 210))
	monster.velocityX = math.random(-80, 80)
	monster.velocityY = math.random(-80, 80)
	monster.collisionResponse = gfx.sprite.kCollisionTypeBounce
	
	monster:setGroups({3})					-- monsters are on layer 3
	monster:setCollidesWithGroups({2})		-- players only collide with sprites on layer 2 (monsters and walls)
	
	monsterSprites[#monsterSprites+1] = monster
	monster:addSprite()
	
	return monster
end


local function addWallBlock(x,y,w,h)
	local block = Box()
	block:setCenter(0,0)
	block:setSize(w, h)
	block:moveTo(x, y)
	block:setCollideRect(0,0,w,h)
	block:setGroupMask(0xFFFFFFFF) -- everything should collide with a wall - djm DO! include this change
	block:addSprite()
end


function Box:draw(x, y, width, height)
	local cx, cy, cwidth, cheight = self:getCollideBounds()
	gfx.setColor(playdate.graphics.kColorWhite)
	gfx.fillRect(cx, cy, cwidth, cheight)
	gfx.setColor(playdate.graphics.kColorBlack)
	gfx.drawRect(cx, cy, cwidth, cheight)
end


function Player:hit()
	
	self:setImage(playerHitImage)
	
	if self.resetImageTimer ~= nil then
		self.resetImageTimer:remove()
	end
	
	self.resetImageTimer = playdate.timer.new(500, function() 
		self:setImage(playerImage)
	end)
end

function Monster:hit()
	
	self:setImage(monsterHitImage)
	
	if self.resetImageTimer ~= nil then
		self.resetImageTimer:remove()
	end
	
	self.resetImageTimer = playdate.timer.new(500, function() 
		self:setImage(monsterImage)
	end)
end


-- Player and Monster sprites just bounce off of each other, but don't collide with sprites of the same type (i.e. monsters don't collide with monsters, players don't collide with players)
local function updateMovingSprite(dt, s)
	
	local dx = s.velocityX * dt / 1000.0
	local dy = s.velocityY * dt / 1000.0

	local actualX, actualY, collisions, collisionCount = s:moveWithCollisions(s.x + dx, s.y + dy)
	
	    for i=1, collisionCount do
	    	local collision = collisions[i]
			
			-- when a player or monster collides with anything just bounce off of it
			if collision.normal.x ~= 0 then -- hit something in the X direction
				s.velocityX = -s.velocityX
			end
			if collision.normal.y ~= 0 then -- hit something in the Y direction
				s.velocityY = -s.velocityY
			end
			
			if ( s.type == kPlayerType and collision.other.type == kMonsterType ) or 
			   ( s.type == kMonsterType and collision.other.type == kPlayerType ) then
				-- a player and monster collided with each other!
				s:hit()
				collision.other:hit()
				
			end
	    end
end



-- set up walls for the sprites to bounce off of, set just offscreen on each edge
local borderSize = 10
local displayWidth = playdate.display.getWidth()
local displayHeight = playdate.display.getHeight()
addWallBlock(-borderSize, -borderSize, displayWidth+borderSize*2, borderSize)		-- top
addWallBlock(-borderSize, -borderSize, borderSize, displayHeight+borderSize*2)		-- left
addWallBlock(displayWidth, -borderSize, borderSize, displayHeight+borderSize*2)		-- right
addWallBlock(-borderSize, displayHeight, displayWidth+borderSize*2, borderSize)		-- bottom


-- set up some player and monster sprites
for i = 1, 10 do
	createPlayerSprite()
	createMonsterSprite()
end


local lastTime = playdate.getCurrentTimeMilliseconds()

function playdate.update()
	
	local currentTime = playdate.getCurrentTimeMilliseconds()
	local deltaTime = currentTime - lastTime
	lastTime = currentTime

	for i = 1, #playerSprites do
		updateMovingSprite(deltaTime, playerSprites[i])
	end
	
	for i = 1, #monsterSprites do
		updateMovingSprite(deltaTime, monsterSprites[i])
	end
		
	gfx.sprite:update()
	playdate.timer.updateTimers()

end

