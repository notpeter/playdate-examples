gfx = playdate.graphics

local r = 50
local centerX = 200
local centerY = 120
local angle = 0

function normalizeAngle(a)
  if a >= 360 then a = a - 360 end
  if a < 0 then a = a + 360 end
  return a
end

function degreesToCoords(angle)
  local crankRads = math.rad(angle)
  local x = math.sin(crankRads)
  local y = -1 * math.cos(crankRads)

  x = (r * x) + centerX
  y = (r * y) + centerY

  return x,y
end

local x,y = degreesToCoords(angle)

function playdate.update()
  local change = playdate.getCrankChange()

  if change ~= 0 then
    angle += change
    angle = normalizeAngle(angle)
    print(change, angle)

    x,y = degreesToCoords(angle)

  end

  gfx.setColor(gfx.kColorBlack)
  gfx.fillRect(0,0,400,240)

  gfx.setColor(gfx.kColorWhite)
  gfx.drawLine(200, 120, x, y, 2)

end