import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "Fish/fish"
import "Ground/ground"
import "Seaweed/seaweed"
import "Score/score"

playdate.display.setRefreshRate(20)

local gfx = playdate.graphics
local spritelib = gfx.sprite
local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()

-- reset the screen to white
gfx.setBackgroundColor(gfx.kColorWhite)
gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, screenWidth, screenHeight)


-- ! game states

local kGameState = {initial, ready, playing, paused, over}
local currentState = kGameState.initial

local kGameInitialState, kGameGetReadyState, kGamePlayingState, kGamePausedState, kGameOverState = 0, 1, 2, 3, 4
local gameState = kGameInitialState


-- ! set up sprites

local score = Score()
score:setZIndex(900)
score:addSprite()

local titleSprite = spritelib.new()
titleSprite:setImage(gfx.image.new('images/getReady'))
titleSprite:moveTo(screenWidth / 2, screenHeight / 2.5)
titleSprite:setZIndex(950)
titleSprite:addSprite()

local background = spritelib.new()
background:setImage(gfx.image.new('images/bg'))
background:moveTo(200, 163)
background:addSprite()

local ground = Ground()
local seaweeds = {Seaweed(), Seaweed(), Seaweed(), Seaweed()}
local flippy = Fish()

local ticks = 0
local buttonDown = false


local function gameOver()

	gameState = kGameOverState

	titleSprite:setImage(gfx.image.new('images/gameOver'))
	titleSprite:setVisible(true)
	
	ticks = 0
end


local function startGame()
	
	gameState = kGameGetReadyState
	ticks = 0
	score:setScore(0)

	titleSprite:setImage(gfx.image.new('images/getReady'))
	titleSprite:setVisible(true)

	flippy:reset()
	for _, seaweed in ipairs(seaweeds) do
		seaweed:resetPosition()
		seaweed.visible = false
	end	
end


-- this function supplies an image to be displayed during the game when the player opens the system menu
function playdate.gameWillPause()

	local img = gfx.image.new('menuImage')

	gfx.lockFocus(img)
	gfx.setFont(score.scoreFont)
	gfx.drawTextAligned(score.score, 200, 6, kTextAlignment.right)
	gfx.unlockFocus()

	playdate.setMenuImage(img, 10)

end


function playdate.update()
	
	ticks = ticks + 1

	if gameState == kGameInitialState then

		gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 0, screenWidth, screenHeight)
		local playButton = gfx.image.new('images/playButton')
		local y = screenHeight/2 - playButton.height/2
		if buttonDown == false then
			y -= 3
		end
		playButton:draw(screenWidth/2 - playButton.width/2, y)

	elseif gameState == kGameGetReadyState then
		
		spritelib.update()
				
		if ticks > 30 then
			seaweeds[1].visible = true
			ground.paused = false
			flippy.fishState = flippy.kFishNormalState
			gameState = kGamePlayingState
			
			titleSprite:setVisible(false)
		end

	elseif gameState == kGamePlayingState then
		
		spritelib.update()	
	
		-- check the position of the rightmost seaweed to see if we need to maybe create a new one
		local rightmostSeaweedX = 0
		local potentialSeaweed = nil
		for _, seaweed in ipairs(seaweeds) do
		
			if seaweed.x < -60 then
				seaweed.visible = false
			end
			
			if seaweed.visible == false then
				potentialSeaweed = seaweed
			
			elseif seaweed.visible == true then			
				rightmostSeaweedX = math.max(rightmostSeaweedX, seaweed.x)
			end	
		end
		
		-- if there has been too long since a seaweed has appeared make a new one, otherwise make it a bit random
		if (potentialSeaweed ~= nil) and ((rightmostSeaweedX < 250) or (rightmostSeaweedX < 350 and math.random(1, 20) == 10)) then
			potentialSeaweed:resetPosition()
			potentialSeaweed.visible = true
		end
		
	elseif gameState == kGameOverState then
		
		if ticks < 5 then
			playdate.display.setInverted(ticks % 2)
		end
	end

end



function flippy:collisionResponse(other)
	if gameState ~= kGamePlayingState then
		return gfx.sprite.kCollisionTypeOverlap
	end
	
	if other == ground and flippy:alphaCollision(ground) then
		-- collided with the ground
		gameOver()
	else
		for _, seaweed in ipairs(seaweeds) do

			if other == seaweed and seaweed.pointAwarded == false then
				
				score:addOne()
				seaweed.pointAwarded = true
								
			elseif (other == seaweed.seaweedTop and flippy:alphaCollision(seaweed.seaweedTop)) or (other == seaweed.seaweedBottom and flippy:alphaCollision(seaweed.seaweedBottom)) then
				
				-- collided with a seaweed
				gameOver()
			end
		end
	end
	
	return gfx.sprite.kCollisionTypeOverlap
end



-- ! Button Functions


function playdate.leftButtonDown()
	if gameState == kGamePlayingState then
		flippy:left()
	end
end

function playdate.rightButtonDown()
	if gameState == kGamePlayingState then
		flippy:right()
	end
end

function playdate.upButtonDown()
	if gameState == kGamePlayingState then
		flippy:up()
	end
end

function playdate.AButtonDown()

	if gameState == kGameInitialState then
		buttonDown = true
	elseif gameState == kGameOverState and ticks > 5  then	-- the ticks thing is just so the player doesn't accidentally restart immediately
		startGame()
	elseif gameState == kGamePlayingState then
		flippy:up()		
	end
end

function playdate.BButtonDown()
	if gameState == kGameInitialState then
		buttonDown = true
	elseif gameState == kGameOverState and ticks > 5 then
		startGame()
	elseif gameState == kGamePlayingState then
		flippy:up()
	end
end

function playdate.AButtonUp()

	if gameState == kGameInitialState then
		buttonDown = false
		startGame()
	end
end

function playdate.BButtonUp()
	if gameState == kGameInitialState then
		buttonDown = false
		startGame()
	end
end
