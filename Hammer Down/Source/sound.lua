
sound = { updateScalar = 10, n = 0, notes = {}, waveform = kWaveSquare }

pan = { {0.4, 0.2}, {0.4, 0.3}, {0.4, 0.4}, {0.3, 0.4}, {0.2, 0.4} }

snd = playdate.sound.synth.new()

function sound:update()
	local p = truck.position

	if #self.notes > 0
	then
		if self.n == 0
		then
			snd:setWaveform(self.waveform)
			snd:playNote(self.notes[1][1], 1, pan[p][1], pan[p][2])
			self.n = self.notes[1][2]
			table.remove(self.notes, 1)
		else
			self.n = self.n - 1
		end
	elseif playing
	then
		self.updateScalar = 10

		-- rumble
		self.n = 1 - self.n

		snd:setWaveform(playdate.sound.kWaveSawtooth)

		if self.n == 0 then
			snd:playNote(playdate.sound.kWaveSawtooth, 30, 10, pan[p][1], pan[p][2])
		else
			snd:playNote(playdate.sound.kWaveSawtooth, 35, 10, pan[p][1], pan[p][2])
		end
	end
end

function sound:playNotes(waveform, list)
	self.n = 0
	self.waveform = waveform
	self.notes = list
	self.updateScalar = 1
end

function sound:crash()
	snd:setWaveform(playdate.sound.kWaveNoise)
	snd:playNote(50, 1.0, 1)
end

function sound:gotFile()
	self:playNotes(playdate.sound.kWaveSquare, {{220, 1}, {330, 1}, {440, 1}})
end

function sound:score()
	self:playNotes(playdate.sound.kWaveSquare, {{660, 1}, {440, 1}, {660, 1}, {440, 1}, {660, 1}, {440, 1}, {660, 1}})
end

function sound:showAll()
end
