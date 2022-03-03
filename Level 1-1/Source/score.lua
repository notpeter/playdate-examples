
class('Score').extends(playdate.graphics.sprite)

local font = playdate.graphics.font.new('img/font-runner-2x')

function Score:init()
	
	Score.super.init(self)

	self.font = playdate.graphics.font.new('img/font-runner-2x')
	self.score = 0
	
	self:setZIndex(900)
	self:setIgnoresDrawOffset(true)
	self:setCenter(0, 0)
	self:setSize(40, 20)
	self:moveTo(10, 10)
end

function Score:addOne()
	self.score += 1
	self:markDirty()
end

function Score:draw()
	playdate.graphics.setFont(self.font)
	playdate.graphics.drawText(tostring(self.score), 0, 0)
end
