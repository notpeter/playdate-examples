
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
-- import 'CoreLibs/input'

local gfx = playdate.graphics

-- playdate.inputHandlers.push(playdate.input)

local s, ms = playdate.getSecondsSinceEpoch()
math.randomseed(ms,s)

local font = gfx.font.new('images/font/whiteglove-stroked')

local maxEnemies = 10
local enemyCount = 0

local maxBackgroundPlanes = 10
local backgroundPlaneCount = 0

local player = nil

local score = 0

local bgY = 0
local bgH = 0


local explosionImages = {}
for i = 1, 8 do
	explosionImages[i] = gfx.image.new('images/x/'..i)
end



local function createBackgroundSprite()

	local bg = gfx.sprite.new()
	local bgImg = gfx.image.new('images/background.png')
	local w, h = bgImg:getSize()
	bgH = h
	bg:setBounds(0, 0, 400, 240)

	function bg:draw(x, y, width, height)
		bgImg:draw(0, bgY)
		bgImg:draw(0, bgY-bgH)

	end

	function bg:update()
		bgY += 1
		if bgY > bgH then
			bgY = 0
		end
		self:markDirty()
	end

	bg:setZIndex(0)
	bg:add()
end



local function createExplosion(x, y)

	local s = gfx.sprite.new()
	s.frame = 1
	local img = gfx.image.new('images/explosion/'..s.frame)
	s:setImage(img)
	s:moveTo(x, y)

	function s:update()
		s.frame += 1
		if s.frame > 11 then
			s:remove()
		else
			local img = gfx.image.new('images/explosion/'..s.frame)
			s:setImage(img)
		end
	end

	s:setZIndex(2000)
	s:add()

end


local function destroyEnemyPlane(plane)

	createExplosion(plane.x, plane.y)
	plane:remove()
	enemyCount -= 1

end


local function createPlayer(x, y)
	local plane = gfx.sprite.new()
	local playerImage = gfx.image.new('images/player')
	local w, h = playerImage:getSize()
	plane:setImage(playerImage)
	plane:setCollideRect(5, 5, w-10, h-10)
	plane:moveTo(x, y)
	plane:add()


	function plane:collisionResponse(other)
		return gfx.sprite.kCollisionTypeOverlap
	end



	function plane:update()

		local dx = 0
		local dy = 0

		if playdate.buttonIsPressed("UP") then
			dy = -4
		elseif playdate.buttonIsPressed("DOWN") then
			dy = 4
		end
		if playdate.buttonIsPressed("LEFT") then
			dx = -4
		elseif playdate.buttonIsPressed("RIGHT") then
			dx = 4
		end

-- 		self:moveBy(dx, dy)

		local actualX, actualY, collisions, length = plane:moveWithCollisions(plane.x + dx, plane.y + dy)
		for i = 1, length do
			local collision = collisions[i]
			if collision.other.isEnemy == true then	-- crashed into enemy plane
				destroyEnemyPlane(collision.other)
				collision.other:remove()
				score -= 1
			end
		end

	end

	plane:setZIndex(1000)
	return plane
end





local function playerFire()
	local s = gfx.sprite.new()
	local img = gfx.image.new('images/doubleBullet')
	local imgw, imgh = img:getSize()
	s:setImage(img)
	s:moveTo(player.x, player.y)
	s:setCollideRect(0, 0, imgw, imgh)

	function s:collisionResponse(other)
		return gfx.sprite.kCollisionTypeOverlap
	end

	function s:update()

		local newY = s.y - 20

		if newY < -imgh then
			s:remove()
		else
			local actualX, actualY, collisions, length = s:moveWithCollisions(s.x, newY)
			for i = 1, length do
				local collision = collisions[i]
				if collision.other.isEnemy == true then
					destroyEnemyPlane(collision.other)
					s:remove()
					score += 1
				end
			end
		end

	end

	s:setZIndex(999)
	s:add()

end




local function createEnemyPlane(x, y)

	local plane = gfx.sprite.new()

	local planeImg

	planeImg = gfx.image.new('images/plane1')

	local w, h = planeImg:getSize()
	plane:setImage(planeImg)
	plane:setCollideRect(0, 0, w, h)
	plane:moveTo(math.random(400), -math.random(30) - h)
	plane:add()

	plane.isEnemy = true

	enemyCount += 1


	function plane:collisionResponse(other)
		return gfx.sprite.kCollisionTypeOverlap
	end


	function plane:update()

		local newY = plane.y + 4

		if newY > 400 + h then
			plane:remove()
			enemyCount -= 1
		else

			plane:moveTo(plane.x, newY)

		end
	end


	plane:setZIndex(500)
	return plane
end



local function spawnEnemyIfNeeded()
	if enemyCount < maxEnemies then
		if math.random(math.ceil(120/maxEnemies)) == 1 then
			createEnemyPlane()
		end
	end
end



local function createBackgroundPlane()

	local plane = gfx.sprite.new()

	local planeImg

	planeImg = gfx.image.new('images/plane2')

	local w, h = planeImg:getSize()
	plane:setImage(planeImg)
	plane:moveTo(math.random(400), -math.random(30))
	plane:add()

	backgroundPlaneCount += 1


	function plane:update()

		local newY = plane.y + 2

		if newY > 400 + h then
			plane:remove()
			backgroundPlaneCount -= 1
		else
			plane:moveTo(plane.x, newY)
		end
	end


	plane:setZIndex(100)
	return plane
end



local function spawnBackgroundPlaneIfNeeded()
	if backgroundPlaneCount < maxBackgroundPlanes then
		if math.random(math.floor(120/maxBackgroundPlanes)) == 1 then
			createBackgroundPlane()
		end
	end
end



createBackgroundSprite()
player = createPlayer(200, 180)


function playdate.cranked(change, acceleratedChange)

	if change > 1 then
		maxEnemies += 1
	elseif change < -1 then
		maxEnemies -= 1
	end

end


function playdate.update()

	if playdate.buttonJustPressed("B") or playdate.buttonJustPressed("A") then
		playerFire()
	end

	spawnEnemyIfNeeded()
	spawnBackgroundPlaneIfNeeded()

	gfx.sprite.update()

	gfx.setFont(font)
	gfx.drawText('sprite count: '..#gfx.sprite.getAllSprites(), 2, 2)
	gfx.drawText('max enemies: '..maxEnemies, 2, 16)
	gfx.drawText('score: '..score, 2, 30)

	playdate.drawFPS(2, 224)

end
