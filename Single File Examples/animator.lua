
import 'CoreLibs/animator'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local gfx = playdate.graphics
local geo = playdate.geometry
local Animator = playdate.graphics.animator

local animators = {}

local startPoint = geo.point.new(0, 0)
local endPoint = geo.point.new(400, 240)

gfx.setLineWidth(0)

---------------------------------------------------------------------------------
-- animation along a line segment, no repeats, delayed start time of 2 seconds --
---------------------------------------------------------------------------------
local ls = geo.lineSegment.new(170, 10, 300, 50)
local lsAnim = Animator.new(10000, ls, playdate.easingFunctions.linear, 2000)

-------------------------------------------------------------------------------------------------
-- animation along an arc, repeating 4 times, which means the animation actually plays 5 times --
-------------------------------------------------------------------------------------------------
local arc = geo.arc.new(120, 40, 30, -95, 100)
local arcAnim = Animator.new(2000, arc)
arcAnim.repeatCount = 2
arcAnim.reverses = true


---------------------------------------------------------------
-- animation along a star-shaped polygon, repeating 10 times --
---------------------------------------------------------------
local poly = geo.polygon.new(46,7, 46,29, 68,37, 46,44, 46,67, 32,48, 9,55, 23,37, 9,19, 32,26)
poly:close()
local polyAnim = Animator.new(360, poly)


--------------------------------------------------------------------------------
-- animation with multiple parts and one overall duration and easing function --
--------------------------------------------------------------------------------
local leftLine = geo.lineSegment.new(120, 160, 120, 80)
local topLine = geo.lineSegment.new(140, 60, 260, 60)
local rightLine = geo.lineSegment.new(280, 80, 280, 160)
local bottomLine = geo.lineSegment.new(260, 180, 140, 180)
local tlArc = geo.arc.new(140, 80, 20, 270, 360)
local trArc = geo.arc.new(260, 80, 20, 0, 90)
local brArc = geo.arc.new(260, 160, 20, 90, 180)
local blArc = geo.arc.new(140, 160, 20, 180, 270)

local parts = {topLine, trArc, rightLine, brArc, bottomLine, blArc, leftLine, tlArc}

local partsAnimation = Animator.new(2000, parts, playdate.easingFunctions.linear)
partsAnimation.repeatCount = -1


------------------------------------------------------------------------------------------------
-- animation with multiple parts, and individual durations and easing functions for each part --
------------------------------------------------------------------------------------------------
local leftLine2 = geo.lineSegment.new(140, 180, 140, 100)
local topLine2 = geo.lineSegment.new(160, 80, 280, 80)
local rightLine2 = geo.lineSegment.new(300, 100, 300, 180)
local bottomLine2 = geo.lineSegment.new(280, 200, 160, 200)
local tlArc2 = geo.arc.new(160, 100, 20, 270, 360)
local trArc2 = geo.arc.new(280, 100, 20, 0, 90)
local brArc2 = geo.arc.new(280, 180, 20, 90, 180)
local blArc2 = geo.arc.new(160, 180, 20, 180, 270)

local parts = {topLine2, trArc2, rightLine2, brArc2, bottomLine2, blArc2, leftLine2, tlArc2}
local durations = {700, 300, 800, 300, 1000, 300, 1000, 300}
local easingFuncs = {playdate.easingFunctions.outInSine, playdate.easingFunctions.linear, playdate.easingFunctions.outBounce, playdate.easingFunctions.linear, playdate.easingFunctions.inOutCirc, playdate.easingFunctions.linear, playdate.easingFunctions.outElastic, playdate.easingFunctions.linear}

local partsAnimation2 = Animator.new(durations, parts, easingFuncs)
partsAnimation2.repeatCount = -1


--------------------------------------------------------------------------------------------------------------
-- animation with two lines parts, which are the reverse of one another, to create a little bounch animation --
--------------------------------------------------------------------------------------------------------------
local bounceLine = geo.lineSegment.new(40, 80, 40, 160)
local bounceAnim = Animator.new(1000, bounceLine, playdate.easingFunctions.inCubic)
bounceAnim.repeats = true
bounceAnim.reverses = true


-----------------------------------
-- animation applied to a sprite --
-----------------------------------
local leftLine3 = geo.lineSegment.new(330, 200, 330, 40)
local rightLine3 = geo.lineSegment.new(370, 40, 370, 200)
local topArc3 = geo.arc.new(350, 40, 20, -90, 90)
local bottomArc3 = geo.arc.new(350, 200, 20, 90, 270)

local parts = {topArc3, rightLine3, bottomArc3, leftLine3}

local spriteAnimation = Animator.new(5000, parts, playdate.easingFunctions.linear)
spriteAnimation.repeatCount = -1

local sprite = gfx.sprite.new()
sprite.i = 1
local spriteImages = { gfx.image.new("assets/sprite/s1"), gfx.image.new("assets/sprite/s2"), gfx.image.new("assets/sprite/s3"), gfx.image.new("assets/sprite/s4"), gfx.image.new("assets/sprite/s5"), gfx.image.new("assets/sprite/s6"), gfx.image.new("assets/sprite/s7"), gfx.image.new("assets/sprite/s8") }
sprite:setImage(spriteImages[sprite.i])
sprite:setCollideRect(0, 0, spriteImages[sprite.i]:getSize())
sprite.collisionResponse = gfx.sprite.kCollisionTypeFreeze
sprite:moveTo(330, 200)
sprite:add()

function sprite:update()
	-- update sprite image
	local i = sprite.i - 1
	i = (i + 1) % #spriteImages
	sprite.i = i + 1
	sprite:setImage(spriteImages[sprite.i])
end

-- IMPORTANT: only call sprite:setAnimator() after any custom update function has been defined
sprite:setAnimator(spriteAnimation, true, true)


-----------------------------------------
-- animation between two number values --
-----------------------------------------
function playdate.AButtonDown()
	animators[#animators+1] = Animator.new(1600, 0, 240, playdate.easingFunctions.outBounce)
end


----------------------------------
-- animation between two points --
----------------------------------
function playdate.BButtonDown()
	animators[#animators+1] = Animator.new(2000, startPoint, endPoint, playdate.easingFunctions.outBounce)
end


function playdate.downButtonDown()
	arcAnim:reset()
	bounceAnim:reset()
	lsAnim:reset()
end


function playdate.update()
	
	gfx.clear()
	
	gfx.sprite.update()
	
	-- draw the line segment animation
	if lsAnim then
		gfx.drawLine(ls)
		local p = lsAnim:currentValue()
		gfx.fillCircleAtPoint(p, 5)
	end
	
	-- draw the arc animation
	if arcAnim then
		gfx.drawArc(arc)
		local p = arcAnim:currentValue()
		gfx.fillCircleAtPoint(p, 5)
		
		gfx.drawTextAligned(math.floor(100*arcAnim:progress()).."%", 121, 30, kTextAlignment.center)
	end
	
	-- draw the polygon animation
	if polyAnim then
		gfx.drawPolygon(poly)
		local p = polyAnim:valueAtTime(playdate.getCrankPosition())
		gfx.fillCircleAtPoint(p, 5)
	end	

	-- draw the multi-part animation
	if partsAnimation ~= nil then
		gfx.drawLine(topLine)
		gfx.drawLine(rightLine)
		gfx.drawLine(bottomLine)
		gfx.drawLine(leftLine)
		gfx.drawArc(tlArc)
		gfx.drawArc(trArc)
		gfx.drawArc(brArc)
		gfx.drawArc(blArc)
		
		local p = partsAnimation:currentValue()
		gfx.fillCircleAtPoint(p, 5)		
	end

	-- draw the second multi-part animation	
	if partsAnimation2 ~= nil then
		gfx.drawLine(topLine2)
		gfx.drawLine(rightLine2)
		gfx.drawLine(bottomLine2)
		gfx.drawLine(leftLine2)
		gfx.drawArc(tlArc2)
		gfx.drawArc(trArc2)
		gfx.drawArc(brArc2)
		gfx.drawArc(blArc2)
	
		local p = partsAnimation2:currentValue()
		gfx.fillCircleAtPoint(p, 5)
	end
	
	-- draw the bounce animation
	if bounceAnim ~= nil then
		gfx.drawLine(bounceLine)
		local p = bounceAnim:currentValue()
		gfx.fillCircleAtPoint(p, 5)
	end
	
	-- draw the sprite animation
	if spriteAnimation ~= nil then
		gfx.drawLine(rightLine3)
		gfx.drawLine(leftLine3)
		gfx.drawArc(topArc3)
		gfx.drawArc(bottomArc3)
		
		-- the sprite itself will handle its own drawing here
	end
	
	-- draw the number and point animations if either exists
	local count = #animators
	if count > 0 then
		for i = count, 1, -1 do
			local a = animators[i]
			if a:ended() then
				table.remove(animators, i)
			else
				local v = a:currentValue()
				
				if type(v) == "number" then
					gfx.drawCircleAtPoint(80, v, 8)
				else
					gfx.fillCircleAtPoint(v, 8)
				end
			end
		end
	end

end