import 'CoreLibs/sprites.lua'
import 'CoreLibs/graphics.lua'

local gfx = playdate.graphics

playdate.display.setScale(2)


tiles = gfx.imagetable.new('assets/ground')

bg = gfx.tilemap.new()

bg:setImageTable(tiles)
bg:setSize(13,8)

for y = 1,8 do
	for x = 1,13 do
		bg:setTileAtPosition(x,y,math.random(4))
	end
end

bgsprite = gfx.sprite.new()
bgsprite:setBounds(0,0,200,120)
bgsprite:add()

bgsprite.draw = function() bg:draw(0,0) end

for i = 1,40 do
	local box = gfx.sprite.new()
	local boximg = playdate.graphics.image.new('assets/box')
	box:setImage(boximg)
	-- we'll place the obstacles on a spaced grid to avoid overlap
	local x = math.random(20)
	local y = math.random(12)
	box:moveTo(x * 10, y * 10)
	box:setZIndex(y * 10)
	box:add()
end


local x = 100
local y = 60

local player = gfx.sprite.new()
local playerimg = playdate.graphics.image.new('assets/walk-left-1')
player:setImage(playerimg)
-- player:setImageDrawMode(gfx.kDrawModeInverted)
player:moveTo(x,y)
player:add()


function playdate.update()

	if rightdown then x = x + 1, player:setImageFlip(gfx.kImageFlippedX) end
	if leftdown then x = x - 1, player:setImageFlip(gfx.kImageUnflipped) end
	if downdown then y = y + 1 end
	if updown then y = y - 1 end

	player:moveTo(x,y)
	player:setZIndex(y)

	gfx.sprite.update()

end

function playdate.leftButtonDown()	leftdown = true		end
function playdate.leftButtonUp()	leftdown = false	end
function playdate.rightButtonDown()	rightdown = true	end
function playdate.rightButtonUp()	rightdown = false	end
function playdate.upButtonDown()	updown = true		end
function playdate.upButtonUp()		updown = false		end
function playdate.downButtonDown()	downdown = true		end
function playdate.downButtonUp()	downdown = false	end
