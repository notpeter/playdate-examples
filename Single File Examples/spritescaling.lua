--[[
	Scaled drawing/sprites demonstration
	
	Press B to switch between cached and direct drawing
	
	In cached mode, we use the sprite library's scaling function provided by the
	setImage(img, [flip, [xscale, [yscale] ] ]) function. In direct mode, we clear
	the sprite's image and use its draw() callback instead. Surprisingly, the
	direct mode isn't noticeably faster on the hardware, even though it renders
	to an intermediate buffer.
	
	Hold A to smear the sprites (sets the sprite background color to clear)
]]


import 'CoreLibs/sprites.lua'
import 'CoreLibs/graphics.lua'

local gfx = playdate.graphics
local img = gfx.image.new('assets/jump')

local pixiefont = gfx.font.new('assets/font-pixieval')
gfx.setFont(pixiefont)

local cacheImage = false

function newSprite()
	
	local s = gfx.sprite.new()
	
	if cacheImage then s:setImage(img) end
	
	s.go = function(self)
		self.time = 0
		self.angle = math.pi * math.random(360) / 180
		self:setScale(0)
		self:moveTo(200,120)
		self:add()
	end
	
	s.update = function(self)
		self.time += 1
		
		local d = self.time * self.time / 4
		local scale = d/40 + self.time/10
		
		self.scale = scale
		if cacheImage then
			if self:getImage() == nil then self:setImage(img) end
			
			--s:setScale(scale * (2+math.sin(self.time / 2)) / 3, scale * (2+math.cos(self.time / 2)) / 3)
			s:setScale(scale)
		else
			self:setImage(nil)
			s:setSize(img.width * scale, img.height * scale)
		end
		
		self:moveTo(200 + d * math.cos(self.angle), 120 + d * math.sin(self.angle))
		
		local x,y,w,h = self:getBounds()

		if x+w < 0 or x > 400 or y+h < 0 or y > 240 then
			self:remove()
		end
	end
	
	-- not called if cacheImage is true:
	s.draw = function(self, x, y, w, h)
		img:drawScaled(0, 0, self.scale)
	end
	
	return s
end


local sprites = {}

for i = 1,100
do
	sprites[i] = newSprite()
end

local n = 1
local t = 0
local lasttime = 0

function playdate.update()

	if t % 2 == 0 then
		sprites[n]:go()
		n = n+1
	
		if n > #sprites then n = 1 end
	end
	
	t += 1
	
	gfx.sprite.update()
	
	local time = playdate.getCurrentTimeMilliseconds()
	gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(0,225,400,15)
	gfx.drawText(time-lasttime, 380, 229)
	lasttime = time
	
	if cacheImage then
		gfx.drawText("cached", 4, 229)
	else
		gfx.drawText("direct", 4, 229)
	end
end

function playdate.AButtonDown()
	gfx.setBackgroundColor(gfx.kColorClear)
end

function playdate.AButtonUp()
	gfx.setBackgroundColor(gfx.kColorWhite)
	gfx.clear()
end

function playdate.BButtonDown()
	cacheImage = not cacheImage
end
