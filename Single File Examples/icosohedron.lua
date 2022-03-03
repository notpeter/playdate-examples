
import 'CoreLibs/3d.lua'

gfx = playdate.graphics

p = (math.sqrt(5) - 1) / 2

local x1 = vector3d.new(0, -p, 1)
local x2 = vector3d.new(0, p, 1)
local x3 = vector3d.new(0, p, -1)
local x4 = vector3d.new(0, -p, -1)

local y1 = vector3d.new(1, 0, p)
local y2 = vector3d.new(1, 0, -p)
local y3 = vector3d.new(-1, 0, -p)
local y4 = vector3d.new(-1, 0, p)

local z1 = vector3d.new(-p, 1, 0)
local z2 = vector3d.new(p, 1, 0)
local z3 = vector3d.new(p, -1, 0)
local z4 = vector3d.new(-p, -1, 0)

s = shape3d.new()

s:addFace(z1, y3, y4)
s:addFace(z1, x3, y3)
s:addFace(z1, z2, x3)
s:addFace(z1, x2, z2)
s:addFace(z1, y4, x2)

s:addFace(y4, y3, z4)
s:addFace(z4, y3, x4)
s:addFace(y3, x3, x4)
s:addFace(x4, x3, y2)
s:addFace(x3, z2, y2)
s:addFace(y2, z2, y1)
s:addFace(z2, x2, y1)
s:addFace(y1, x2, x1)
s:addFace(x2, y4, x1)
s:addFace(x1, y4, z4)

s:addFace(z3, y2, y1)
s:addFace(z3, y1, x1)
s:addFace(z3, x1, z4)
s:addFace(z3, z4, x4)
s:addFace(z3, x4, y2)

s:scaleBy(0.9)

scene = scene3d.new()
scene:addShape(s)

light = vector3d.new(-2, 3, 5)

scene:setLight(light / light:length())

angle = 0


local wireframeOn = false
local shadingOn = true


function playdate.update()

	gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(0, 0, 400, 240)

	if shadingOn then
		scene:draw()
	end
	
	if wireframeOn then
		gfx.setColor(gfx.kColorWhite)
		scene:drawWireframe()
	end
	
	angle = angle + 0.01
	s:rotateAroundY(math.cos(angle) / 20)
	s:rotateAroundX(math.sin(angle) / 20)
end



function playdate.AButtonDown()
	wireframeOn = not wireframeOn
end

function playdate.BButtonDown()
	shadingOn = not shadingOn
end
