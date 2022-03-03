
local snd = playdate.sound
local gfx = playdate.graphics

s = snd.sequence.new('giveyouup.mid')

function newsynth()
	local s = snd.synth.new(snd.kWaveSawtooth)
	s:setVolume(0.2)
	s:setAttack(0)
	s:setDecay(0.15)
	s:setSustain(0.2)
	s:setRelease(0)
	return s
end

function drumsynth(path, code)
	local sample = snd.sample.new(path)
	local s = snd.synth.new(sample)
	s:setVolume(0.5)
	return s
end

function newinst(n)
	local inst = snd.instrument.new()
	for i=1,n do
		inst:addVoice(newsynth())
	end
	return inst
end

function druminst()
	local inst = snd.instrument.new()
	inst:addVoice(drumsynth("drums/kick"), 35)
	inst:addVoice(drumsynth("drums/kick"), 36)
	inst:addVoice(drumsynth("drums/snare"), 38)
	inst:addVoice(drumsynth("drums/clap"), 39)
	inst:addVoice(drumsynth("drums/tom-low"), 41)
	inst:addVoice(drumsynth("drums/tom-low"), 43)
	inst:addVoice(drumsynth("drums/tom-mid"), 45)
	inst:addVoice(drumsynth("drums/tom-mid"), 47)
	inst:addVoice(drumsynth("drums/tom-hi"), 48)
	inst:addVoice(drumsynth("drums/tom-hi"), 50)
	inst:addVoice(drumsynth("drums/hh-closed"), 42)
	inst:addVoice(drumsynth("drums/hh-closed"), 44)
	inst:addVoice(drumsynth("drums/hh-open"), 46)
	inst:addVoice(drumsynth("drums/cymbal-crash"), 49)
	inst:addVoice(drumsynth("drums/cymbal-ride"), 51)
	inst:addVoice(drumsynth("drums/cowbell"), 56)
	inst:addVoice(drumsynth("drums/clav"), 75)
	return inst
end

local ntracks = s:getTrackCount()
local active = {}
local poly = 0
local tracks = {}

for i=1,ntracks do
	local track = s:getTrackAtIndex(i)
	if track ~= nil then
		local n = track:getPolyphony(i)
		if n > 0 then active[#active+1] = i end
		if n > poly then poly = n end
		print("track "..i.." has polyphony "..n)
	
		if i == 10 then
			track:setInstrument(druminst(n))
		else
			track:setInstrument(newinst(n))
		end
	end
end

s:play()

function playdate.update()
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
	
	for i=1,#active do
		local track = s:getTrackAtIndex(i)
		local n = track:getNotesActive(active[i])
		gfx.fillRect(400*(i-1)/#active, 240*(1-n/poly), 400/#active, 240)
	end
	
end
