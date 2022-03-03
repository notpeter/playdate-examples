
import 'asteroid'
import 'player'

local gfx = playdate.graphics

function hypot(x,y)
	return math.sqrt(x*x+y*y)
end

local aspeed = 3
local acount = 5

function setup()
	for i = 1,5 do
		a = Asteroid:new()
		
		local x,y,dx,dy
		
		repeat
			x,y = math.random(400), math.random(240)
			dx,dy = aspeed * (2*math.random() - 1), aspeed * (2*math.random() - 1)
		until hypot(x+10*dx-200, y+10*dy-120) > 100
		
		a:moveTo(x,y)
		a:setVelocity(dx, dy, math.random(100) / 200.0 - 0.25)
		a:addSprite()
	end
end

player = Player:new()
player:moveTo(200, 120)
player:setScale(3)
player:setFillPattern({0xf0, 0xf0, 0xf0, 0xf0, 0x0f, 0x0f, 0x0f, 0x0f})
player:setStrokeColor(gfx.kColorWhite)
player.wraps = 1
player:addSprite()

setup()

gfx.setColor(gfx.kColorBlack)
gfx.fillRect(0, 0, 400, 240)
gfx.setBackgroundColor(gfx.kColorBlack)

gfx.setColor(gfx.kColorWhite)

function playdate.update()
	gfx.sprite.update()
end

local turn = 0

function playdate.leftButtonDown()	turn -= 1; player:turn(turn)	end
function playdate.leftButtonUp()	turn += 1; player:turn(turn)	end
function playdate.rightButtonDown()	turn += 1; player:turn(turn)	end
function playdate.rightButtonUp()	turn -= 1; player:turn(turn)	end

function playdate.upButtonDown()	player:startThrust()	end
function playdate.upButtonUp()		player:stopThrust()	end
function playdate.BButtonDown()		player:shoot()	end

function levelCleared() setup() end
