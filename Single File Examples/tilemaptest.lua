
gfx = playdate.graphics

-- playdate.display.setScale(2)

tiles = gfx.imagetable.new('assets/link/tiles')

map = gfx.tilemap.new()

map:setImageTable(tiles)
map:setSize(100,100)

for y = 1,100 do
	for x = 1,100 do
		map:setTileAtPosition(x,y,math.random(22))
	end
end

x = 0
y = 0

leftdown = false
rightdown = false
updown = false
downdown = false

function playdate.update()

	if leftdown then x = x + 3 end
	if rightdown then x = x - 3 end
	if updown then y = y + 3 end
	if downdown then y = y - 3 end

	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0,0,400,240)

	map:draw(x,y)
end

function playdate.leftButtonDown()	leftdown = true		end
function playdate.leftButtonUp()	leftdown = false	end
function playdate.rightButtonDown()	rightdown = true	end
function playdate.rightButtonUp()	rightdown = false	end
function playdate.upButtonDown()	updown = true		end
function playdate.upButtonUp()		updown = false		end
function playdate.downButtonDown()	downdown = true		end
function playdate.downButtonUp()	downdown = false	end
