
import 'track.png'
import 'field.png'
import 'sky.png'
import 'truck.png'

local gfx = playdate.graphics
playdate.display.setScale(2)

track = gfx.image.new('track')
local trackwidth, trackheight = track:getSize()
local field = gfx.image.new('field')
local fieldwidth, fieldheight = field:getSize()
local sky = gfx.image.new('sky')
local truck = gfx.image.new('truck')

local fieldscale = 5
x = 130
y = 157
local angle = 130 * (math.pi/180)
local dangle = 0
local t = 0
local speed = 0
local maxspeed = 1.5
local maxspeed_offtrack = 0.3
local accel = 0.01
local turnspeed = 0.005
local maxturn = 0.05
local turndamp = 0.8
local speedcoast = 0.95
local speedbrake = 0.75
local ontrack = true

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0,0,400,240)

local leftDown = false
local rightDown = false

--gfx.setImageDrawMode(gfx.kDrawModeNXOR)

function playdate.update()

	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0,0,400,240)

	t = t + 0.05
	
	if leftDown then
		if dangle > -maxturn then dangle -= turnspeed end
	else
		if dangle < 0 and not rightDown then
			dangle *= turndamp
		end
	end
	
	if rightDown then
		if dangle < maxturn then dangle += turnspeed end
	else
		if dangle > 0 and not leftDown then
			dangle *= turndamp
		end
	end
	
	angle += math.sqrt(speed/maxspeed) * dangle
	
	if angle < 0 then angle += 2 * math.pi end
	if angle > 2 * math.pi then angle -= 2 * math.pi end

	local c = math.cos(angle)
	local s = math.sin(angle)

	local maxs = maxspeed
	if not ontrack then maxs = maxspeed_offtrack end

	if upDown and speed < maxs then
		speed += accel
	elseif downDown or not ontrack then
		speed *= speedbrake
	else
		speed *= speedcoast
	end

	x += s * speed
	y -= c * speed
	
	field:drawSampled(0, 70, 200, 50,  -- x, y, width, height
				0.5, 0.95, -- center x, y
				c / fieldscale, s / fieldscale, -- dxx, dyx
				-s / fieldscale, c / fieldscale, -- dxy, dyy
				x/fieldwidth, y/fieldheight, -- dx, dy
				16, -- z
				16.6, -- tilt angle
				true); -- tile

	track:drawSampled(0, 70, 200, 50,  -- x, y, width, height
				0.5, 0.95, -- center x, y
				c / fieldscale, s / fieldscale, -- dxx, dyx
				-s / fieldscale, c / fieldscale, -- dxy, dyy
				x/trackwidth, y/trackheight, -- dx, dy
				16, -- z
				16.6, -- tilt angle
				false); -- tile

	skyx = -300 * angle / math.pi
	sky:draw(skyx, 0)
	
	if skyx < -200 then
		sky:draw(skyx + 600, 0)
	end
	
	ontrack = (track:sample(x, y) == 1)
	local rumble = 0
	
	if not ontrack then
		rumble = (x + y) % 2;
	end

	local w, h = truck:getSize()
	truck:draw(100 - w / 2, 90 + rumble/2)
end

function playdate.leftButtonDown() leftDown = true end
function playdate.leftButtonUp() leftDown = false end
function playdate.rightButtonDown() rightDown = true end
function playdate.rightButtonUp() rightDown = false end
function playdate.upButtonDown() upDown = true end
function playdate.upButtonUp() upDown = false end
function playdate.downButtonDown() downDown = true end
function playdate.downButtonUp() downDown = false end
