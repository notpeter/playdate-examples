
import "LCD"
import "Mountains/mountains"
import "Files/files"
import "Guy/guy"
import "HUD/hud"
import "Road/road"
import "Signs/signs"
import "Title/title"
import "Truck/truck"
import "sound"

gfx = playdate.graphics

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, 400, 240)

modules = { truck, road, files, mountains, signs, hud, title, guy, sound }

function setFileTarget(type)
	fileType = type
	signs:selectType(type)
end

function gameOver()
	-- go back to demo mode
	playing = false
	title:setVisible(true)
	hud:setPlaying(false)
	guy:done()
end

local function startup()
	-- first show all segments for one second

	drawHorizon()
	hud:drawScore()

	for i, v in pairs(modules)
	do
		v:showAll(true)
	end

	playdate.wait(1000)

	for i, v in pairs(modules)
	do
		v:showAll(false)
	end

	--

	truck:moveto(3)
	files:addRandomFile()

	setFileTarget(filetypes[math.random(#filetypes)])

	playing = false
	demoMoveTime = 20
	fileAddTime = 60
	t = 0

	gameOver()
end


function startGame()
	playing = true
	
	title:setVisible(false)
	hud:setPlaying(true)
	setFileTarget(filetypes[math.random(#filetypes)])
end

function playdate:update()
	-- startup code is in here instead of the top level of the file because we're calling
	-- playdate.wait(), which must be called from a coroutine (such as playdate.update())

	if startup then
		startup()
		startup = nil
	end

	local hitfile = nil

	for i, v in pairs(modules)
	do
		if v.updateScalar ~= nil and t % v.updateScalar == 0
		then
			if v == files
			then
				hitfile = files:update(truck.position)
			else
				v:update()
			end
		end
	end

	t = ((t + 1) % 600)

	if hitfile ~= nil
	then
		if hitfile.type == fileType then
			sound:gotFile()
			truck:goodReaction(60)

			if playing then
				hud:addFile()
			end
		else
			sound:crash()
			truck:badReaction(60)

			if playing and hud:removeLife()
			then
				gameOver()
			end
		end
	end

	if not playing
	then
		if t % demoMoveTime == 0
		then
			m = math.random(3)

			if m == 1 then
				truck:left()
			elseif m == 2 then
				truck:right()
			end
		end
	end

	if t % fileAddTime == 0 then
		files:addRandomFile()
	end
end


function fileDelivered()
	-- XXX add to score
	guy:done()
	hud:removeFile()
	sound:score()
	setFileTarget(filetypes[math.random(#filetypes)])
end


function left()
	if not playing
	then
		startGame()
	else
		if truck.position == 1 and hud.hasFile and guy.side == 'L'
		then
			fileDelivered()
		else
			truck:left()
		end
	end
end

function right()
	if not playing
	then
		startGame()
	else
		if truck.position == 5 and hud.hasFile and guy.side == 'R'
		then
			fileDelivered()
		else
			truck:right()
		end
	end
end


-- button functions

function playdate.leftButtonDown()
	left()
end

function playdate.rightButtonDown()
	right()
end

function playdate.upButtonDown()
end

function playdate.downButtonDown()
end

function playdate.BButtonDown()
	left()
end

function playdate.AButtonDown()
	right()
end
