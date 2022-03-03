import "CoreLibs/graphics"
import "CoreLibs/sprites"

gfx = playdate.graphics

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, 400, 240)
gfx.setBackgroundColor(gfx.kColorWhite)

ball = gfx.sprite:new()
ball:setImage(gfx.image.new('ball'))
ball:moveTo(100,100)
ball:addSprite()

elapsedTime = 0
dx, dy = 0, 0

function playdate.leftButtonDown()
  dx -= 1
  print("Left Down")
end

function playdate.rightButtonDown()
  dx += 1
	print("Right Down")
end

function playdate.upButtonDown()
  dy -= 1
  print("Up Down")
end

function playdate.downButtonDown()
  dy += 1
  print("Down Down")
end

function playdate.leftButtonUp()
  dx += 1
  print("Left Up")
end

function playdate.rightButtonUp()
  dx -= 1
  print("Right Up")
end

function playdate.upButtonUp()
  dy += 1
  print("Up Up")
end

function playdate.downButtonUp()
  dy -= 1
  print("Down Up")
end

function playdate.update()

  dt = 1/20

  elapsedTime = elapsedTime + dt
  moveDistance = 100 * dt

  ball:moveTo(ball.x + dx * moveDistance, ball.y += dy * moveDistance)

  -- print(ball.x .. "," .. ball.y)

  gfx.sprite.update()

end
