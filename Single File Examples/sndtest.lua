
snd = playdate.sound
sample = snd.sampleplayer.new("assets/audio-8000")
sample:setFinishCallback(function() print("finished!") end)

playdate.graphics.drawText("Press A or B to play sounds", 95, 100)

sampletests =
{
	-- playdate.sound.sampleplayer
	function()
		sample:play()
	end,
	
	function()
		sample:setRate(1.5)
		sample:play()
	end,
	
	function()
		sample:play(5, 1.2)
	end,

	function()
		sample:playAt(snd.getCurrentTime()+0.5, 0.3, 1.0, 0.8) -- time, left vol, right vol, rate
		-- XXX bug?: sets channel pan
	end
}

synthtests =
{
	-- playdate.sound.synth
	function()
		synth = snd.synth.new(snd.kWaveSawtooth)
		synth:playNote(220)
	end,
	
	function()
		synth:stop()
		synth:setDecay(0.5)
		synth:setSustain(0)
		synth:playNote(330)
	end,
	
	function()
		lfo = snd.lfo.new(snd.kLFOSampleAndHold)
		lfo:setRate(10)
		lfo:setDepth(2)
		synth:setFrequencyMod(lfo)
		synth:playNote(220)
	end,
	
	function()
		--synth:setFrequencyLFO(nil) -- XXX - can't clear it by setting to nil: function uses testudata to check object type
		filter = snd.twopolefilter.new("lowpass") -- XXX - snd.kFilterLowPass should work
		filter:setResonance(0.95)
		filter:setFrequency(1000)
		snd.addEffect(filter) -- XXX - addFilter() is a synonym. Is one of these deprecated?
		synth:playNote(220)
	end,
	
	function()
		snd.removeEffect(filter)
	end
}


n = 0

function playdate.AButtonDown()
	n = (n % #sampletests) + 1
	print(n)
	sampletests[n]()
end

m = 0

function playdate.BButtonDown()
	m = (m % #synthtests) + 1
	print(m)
	synthtests[m]()
end

function playdate.update()
	-- frame update callback, throws an error if not defined..
end
