--[[
	16-step sample sequencer
	
	D-pad to move cursor, B starts and stops playback, A button sets and removes notes.
	Hold A and push up/down to change volume of note.
]]

isRunning = true

local snd = playdate.sound

-- global effects: grungy with a bit of echo

o = snd.overdrive.new()
snd.addEffect(o)

lfo = playdate.sound.lfo.new(playdate.sound.kWaveTriangle)
o:setOffsetMod(lfo)
o:setGain(2.0)
o:setLimit(0.9)

d = snd.delayline.new(0.25)
d:setFeedback(0.1)
d:setMix(0.2)
snd.addEffect(d)


--[[
	We'll make a separate instrument for each track so that we can play each sample at different
	pitches if we want (though that's not implemented yet--we always use midi note 60=middle C,
	which plays back samples at normal rate). We could instead create one instrument with the
	samples assigned to different notes, using i:addVoice(s, note)
]]

function newTrack(file)
	local t = snd.track.new()
	local i = snd.instrument.new()
	local sample = snd.sample.new(file)
	local s = snd.synth.new(sample)
	s:setVolume(0.5)
	i:addVoice(s)
	t:setInstrument(i)
	return { track=t, name=file, synth=s, inst=i, notes={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} }
end

tracks =
{
	newTrack('KickDrum'),
	newTrack('SnareDrum'),	
	newTrack('HHClosed'),
	newTrack('HHOpen'),	
	newTrack('TomHi'),
	newTrack('TomMid'),
	newTrack('TomLow'),
	newTrack('Clap'),
	newTrack('Clav'),
	newTrack('Rimshot'),	
	newTrack('Cowbell'),
	newTrack('Maraca'),	
	newTrack('CongaHi'),
	newTrack('CongaMid'),	
	newTrack('CongaLow'),
}

sequence = snd.sequence.new()

for i=1,#tracks do sequence:addTrack(tracks[i].track) end

local LEVEL_INCREMENTS = 9

local function updateTrack(t, notes)
	local list = {}
	
	for i=1,#notes do
		if notes[i] > 0 then
			list[#list+1] = { note=60, step=i, length=1, velocity=notes[i]/LEVEL_INCREMENTS }
		end
	end

	t.track:setNotes(list)
	t.notes = notes
end

-- initial data

updateTrack(tracks[1], { 9, 0, 0, 0,  0, 0, 0, 0,  0, 0, 6, 0,  0, 0, 0, 0 })
updateTrack(tracks[2], { 0, 0, 0, 0,  9, 0, 0, 0,  0, 7, 0, 0,  9, 0, 0, 0 })
updateTrack(tracks[3], { 8, 0, 5, 0,  6, 0, 5, 0,  8, 0, 5, 0,  6, 0, 5, 0 })
updateTrack(tracks[9], { 0, 0, 0, 3,  0, 2, 0, 0,  0, 0, 0, 3,  0, 0, 0, 0 })

selectedRow = 1
selectedColumn = 1

function setBPM(bpm)
	local stepsPerBeat = 4
	local beatsPerSecond = bpm / 60
	local stepsPerSecond = stepsPerBeat * beatsPerSecond
	sequence:setTempo(stepsPerSecond)
end

setBPM(120)
sequence:setLoops(1,16,0)
sequence:play()


-- UI

local ROW_HEIGHT = 16
local TEXT_WIDTH = 90
local CELL_INSET = 2
local SELECTION_WIDTH = 2

local gfx = playdate.graphics
gfx.setStrokeLocation(gfx.kStrokeOutside)
playdate.display.setInverted(true)

local grid = gfx.image.new(400,240)

local function drawCell(col,row)
	local width = 1
	
	if col == selectedColumn and row == selectedRow then width = SELECTION_WIDTH end
	
	local x = TEXT_WIDTH + (col-1)*ROW_HEIGHT + CELL_INSET
	local y = (row-1) * ROW_HEIGHT + CELL_INSET
	local s = ROW_HEIGHT - 2*CELL_INSET
	
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x, y, s, s, width)

	local val = tracks[row].notes[col]
	
	if val ~= nil and val > 0 then
		gfx.setDitherPattern(1-val/LEVEL_INCREMENTS, gfx.image.kDitherTypeBayer4x4)
		gfx.fillRect(x+1, y+1, s-2, s-2)
	end
end

local function drawGrid()
	gfx.lockFocus(grid)
	gfx.clear(gfx.kColorWhite)
	for row = 1,#tracks do
		gfx.drawText(tracks[row].name, 0, (row-1)*ROW_HEIGHT)
		for col = 1,16 do
			drawCell(col,row)
		end
	end
end

drawGrid()

local function select(column,row)
	selectedRow = row
	selectedColumn = column
	drawGrid()
end

local laststep = 0

function playdate.update()
	-- The only thing we have to do here is update the display when the play step changes
	local step = sequence:getCurrentStep()

	if step ~= laststep then
		grid:draw(0,0)
		local x = TEXT_WIDTH + step * ROW_HEIGHT - ROW_HEIGHT/2
		gfx.fillRect(x-1, 0, 2, 240)
	end
end

local adjusted = false
local adjusting = false

function playdate.leftButtonDown()
	if adjusting then playdate.AButtonUp() adjusted = true end
	if selectedColumn > 1 then select(selectedColumn-1, selectedRow) end
end

function playdate.rightButtonDown()
	if adjusting then playdate.AButtonUp() adjusted = true end
	if selectedColumn < 16 then select(selectedColumn+1, selectedRow) end
end

local function setTrackNote(track, pos, val)
	track.notes[pos] = val
	updateTrack(track,track.notes)
	drawGrid()

	if not isRunning then
		track.inst:playNote(60,val/LEVEL_INCREMENTS)
	end
end

local function adjustSelectedNote(d)
	local track = tracks[selectedRow]
	adjusted = true
	
	local val = track.notes[selectedColumn] + d
	
	if val >= 0 and val <= LEVEL_INCREMENTS then
		setTrackNote(track,selectedColumn,val)
	end
end

function playdate.upButtonDown()
	if adjusting then
		adjustSelectedNote(1)
	else
		if selectedRow > 1 then select(selectedColumn, selectedRow-1) end
	end
end

function playdate.downButtonDown()
	if adjusting then
		adjustSelectedNote(-1)
	else
		if selectedRow < #tracks then select(selectedColumn, selectedRow+1) end
	end
end

function playdate.AButtonDown()
	adjusted = false
	adjusting = true
end

function playdate.AButtonUp()
	adjusting = false
	if adjusted then return end
	
	local track = tracks[selectedRow]
	
	if track.notes[selectedColumn] == 0 then
		setTrackNote(track,selectedColumn,LEVEL_INCREMENTS)
	else
		setTrackNote(track,selectedColumn,0)
	end
end

function playdate.BButtonDown()
	isRunning = not isRunning
	
	if isRunning then
		sequence:play()
	else
		sequence:stop()
	end
 end
